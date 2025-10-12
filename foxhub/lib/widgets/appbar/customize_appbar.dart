import 'package:flutter/material.dart';
import 'package:foxhub/screens/authentication/login_screen.dart';
import 'package:foxhub/screens/profile/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomizeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomizeAppBar({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return AppBar(
      backgroundColor: Colors.orange.shade400,
      elevation: 4,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      centerTitle: true,
      title: Text(
        "FoxHub",
        style: GoogleFonts.pressStart2p(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),

      // 🔹 Profile Picture from Firestore
      actions: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              // 🔸 Show default avatar while loading or missing
              return _defaultAvatar(context);
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;
            final photoUrl = data?['photoUrl'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  backgroundImage: (photoUrl != null && photoUrl.toString().isNotEmpty)
                      ? NetworkImage(photoUrl)
                      : const AssetImage("lib/assets/images/default_avatar.png")
                  as ImageProvider,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _defaultAvatar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
        child: const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("lib/assets/images/default_avatar.png"),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Drawer
Drawer buildAppDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // 🔹 Profile pic in Drawer too
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData ||
                      !snapshot.data!.exists) {
                    return const CircleAvatar(
                      radius: 28,
                      backgroundImage:
                      AssetImage("lib/assets/images/default_avatar.png"),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  final photoUrl = data?['photoUrl'];

                  return CircleAvatar(
                    radius: 28,
                    backgroundImage: (photoUrl != null && photoUrl.toString().isNotEmpty)
                        ? NetworkImage(photoUrl)
                        : const AssetImage("lib/assets/images/default_avatar.png")
                    as ImageProvider,
                  );
                },
              ),
              const SizedBox(width: 12),
              const Text(
                "Menu",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text("Logout"),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ],
    ),
  );
}
