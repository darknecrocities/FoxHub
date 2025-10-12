import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/customize_appbar.dart';
import '../widgets/customize_navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController bioController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController githubController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  String? photoUrl;
  String? bannerUrl;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user profile with fallback to default images
  Future<void> _loadUserProfile() async {
    try {
      final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          fullNameController.text = data["fullName"] ?? "";
          bioController.text = data["bio"] ?? "";
          linkedinController.text = data["linkedin"] ?? "";
          githubController.text = data["github"] ?? "";

          photoUrl = data["photoUrl"] ?? "lib/assets/images/default_avatar.png";
          bannerUrl = data["bannerUrl"] ?? "lib/assets/images/default_banner.png";
        });
      } else {
        setState(() {
          photoUrl = "lib/assets/images/default_avatar.png";
          bannerUrl = "lib/assets/images/default_banner.png";
        });
      }
    } catch (e) {
      setState(() {
        photoUrl = "lib/assets/images/default_avatar.png";
        bannerUrl = "lib/assets/images/default_banner.png";
      });
      print("Error fetching user data: $e");
    }
  }

  // Upload profile or banner image
  Future<void> _pickAndUploadImage(bool isBanner) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => loading = true);

    try {
      final file = File(pickedFile.path);
      final user = FirebaseAuth.instance.currentUser!;

      final ref = FirebaseStorage.instance
          .ref('users/${user.uid}/${isBanner ? "banner" : "profile"}.jpg');

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        isBanner ? "bannerUrl" : "photoUrl": downloadUrl,
      }, SetOptions(merge: true));

      setState(() {
        if (isBanner) {
          bannerUrl = downloadUrl;
        } else {
          photoUrl = downloadUrl;
        }
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print("Upload failed: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to upload image: $e")));
    }
  }

  // Save other profile data
  Future<void> _saveProfile() async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "fullName": fullNameController.text,
      "bio": bioController.text,
      "linkedin": linkedinController.text,
      "github": githubController.text,
      "photoUrl": photoUrl,
      "bannerUrl": bannerUrl,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Profile Updated!")));
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orangeAccent.shade400;

    return Scaffold(
      appBar: const CustomizeAppBar(title: "My Profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Banner + Profile Avatar
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () => _pickAndUploadImage(true),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: bannerUrl != null
                          ? DecorationImage(
                        image: bannerUrl!.startsWith("http")
                            ? NetworkImage(bannerUrl!)
                            : AssetImage(bannerUrl!) as ImageProvider,
                        fit: BoxFit.cover,
                      )
                          : null,
                      color: Colors.grey[300],
                    ),
                    child: bannerUrl == null
                        ? Center(
                      child: Text(
                        "Tap to add banner",
                        style: TextStyle(
                          color: orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                        : null,
                  ),
                ),
                // 🔸 Floating Avatar
                Positioned(
                  bottom: -60,
                  child: GestureDetector(
                    onTap: () => _pickAndUploadImage(false),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: photoUrl != null
                            ? (photoUrl!.startsWith("http")
                            ? NetworkImage(photoUrl!) as ImageProvider
                            : AssetImage(photoUrl!))
                            : const AssetImage("lib/assets/images/default_avatar.png"),
                        child: photoUrl == null
                            ? Icon(Icons.person, size: 60, color: orange)
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),

            // 🔹 Profile Form with Card Style
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: fullNameController,
                      label: "Full Name",
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      controller: TextEditingController(text: user.email),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: bioController,
                      label: "Bio",
                      icon: Icons.info,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: linkedinController,
                      label: "LinkedIn URL",
                      icon: Icons.business_center,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: githubController,
                      label: "GitHub URL",
                      icon: Icons.code,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: loading ? null : _saveProfile,
                      icon: const Icon(Icons.save),
                      label: const Text("Save Profile"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: orange.withOpacity(0.4),
                      ),
                    ),
                    if (loading) const SizedBox(height: 12),
                    if (loading)
                      const CircularProgressIndicator(color: Colors.orangeAccent),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 2),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    final orange = Colors.orangeAccent.shade400;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        prefixIcon: Icon(icon, color: orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: orange, width: 2),
        ),
      ),
    );
  }
}
