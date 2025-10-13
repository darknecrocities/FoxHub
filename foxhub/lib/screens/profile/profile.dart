import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/appbar/customize_appbar.dart';
import '../../widgets/navbar/customize_navbar.dart';

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

  // Load user profile
  Future<void> _loadUserProfile() async {
    try {
      final res = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user.uid)
          .single();

      final data = res as Map<String, dynamic>?;

      if (data != null) {
        setState(() {
          fullNameController.text = data['full_name'] ?? '';
          bioController.text = data['bio'] ?? '';
          linkedinController.text = data['linkedin'] ?? '';
          githubController.text = data['github'] ?? '';
          photoUrl = data['photo_url'];
          bannerUrl = data['banner_url'];
        });
      }
    } catch (e) {
      print("Error fetching user data from Supabase: $e");
    }
  }


  // Pick and upload image to Supabase Storage
  Future<void> _pickAndUploadImage({required bool isBanner}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => loading = true);

    try {
      final file = File(pickedFile.path);
      final fileExt = pickedFile.path.split('.').last;
      final fileName = isBanner ? 'banner.$fileExt' : 'profile.$fileExt';

      // Supabase Storage
      final bucket = Supabase.instance.client.storage.from('profile');
      final path = '${user.uid}/$fileName';

      // Upload the image (no response object in current supabase_flutter)
      await bucket.upload(path, file, fileOptions: const FileOptions(upsert: true));

      // Get public URL (returns String)
      final urlRes = bucket.getPublicUrl(path);

      // Update local state to show image immediately
      setState(() {
        if (isBanner) {
          bannerUrl = urlRes;
        } else {
          photoUrl = urlRes;
        }
      });

      // Upsert to Supabase table
      final updateData = {
        'id': user.uid,
        'email': user.email,
        'full_name': fullNameController.text,
        'bio': bioController.text,
        'linkedin': linkedinController.text,
        'github': githubController.text,
        ...{isBanner ? 'banner_url' : 'photo_url': urlRes},
      };


      await Supabase.instance.client
          .from('users')
          .upsert(updateData, onConflict: 'id'); // onConflict expects String

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isBanner ? "Banner updated!" : "Profile picture updated!")),
      );
    } catch (e) {
      print("Upload failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }




  // Save other profile data (full name, bio, links)
  Future<void> _saveProfile() async {
    setState(() => loading = true);

    try {
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
    } catch (e) {
      print("Profile save failed: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to save profile: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orangeAccent.shade400;

    return Scaffold(
      appBar: const CustomizeAppBar(title: ''),
      drawer: buildAppDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner image
            // Banner + Profile Picture (floating)
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner
                GestureDetector(
                  onTap: () => _pickAndUploadImage(isBanner: true),
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
                // Profile Picture (floating)
                Positioned(
                  bottom: -60, // half of CircleAvatar radius to overlap
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _pickAndUploadImage(isBanner: false),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: photoUrl != null
                            ? (photoUrl!.startsWith("http")
                            ? NetworkImage(photoUrl!)
                            : AssetImage(photoUrl!)) as ImageProvider
                            : const AssetImage(""),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80), // leave space for floating avatar

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildTextField(controller: fullNameController, label: "Full Name", icon: Icons.person),
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
                  _buildTextField(controller: bioController, label: "Bio", icon: Icons.info, maxLines: 3),
                  const SizedBox(height: 12),
                  _buildTextField(controller: linkedinController, label: "LinkedIn URL", icon: Icons.business_center),
                  const SizedBox(height: 12),
                  _buildTextField(controller: githubController, label: "GitHub URL", icon: Icons.code),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: loading ? null : _saveProfile,
                    icon: const Icon(Icons.save),
                    label: const Text("Save Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  if (loading) const SizedBox(height: 12),
                  if (loading) const CircularProgressIndicator(color: Colors.orangeAccent),
                ],
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: orange, width: 2)),
      ),
    );
  }
}
