import 'package:flutter/material.dart';
import 'package:foxhub/screens/home_screen.dart';
import 'package:foxhub/screens/organizations/organization.dart';
import 'package:foxhub/screens/profile/profile.dart';

class CustomizeNavBar extends StatelessWidget {
  final int? currentIndex;
  const CustomizeNavBar({super.key, this.currentIndex});

  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 🔹 You can try different animations below (fade, slide, scale, rotation, etc.)
          const beginOffset = Offset(0.0, 0.2); // slide from bottom
          const endOffset = Offset.zero;
          final curve = Curves.easeOutCubic;

          final tween = Tween(begin: beginOffset, end: endOffset)
              .chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          currentIndex: currentIndex ?? -1,
          selectedItemColor: Colors.orange.shade400,
          unselectedItemColor: Colors.grey.shade500,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == currentIndex) return; // no re-navigation if same tab
            switch (index) {
              case 0:
                _navigateWithAnimation(context, const HomeScreen());
                break;
              case 1:
                _navigateWithAnimation(context, const OrganizationScreen());
                break;
              case 2:
                _navigateWithAnimation(context, const ProfileScreen());
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment_outlined),
              activeIcon: Icon(Icons.apartment),
              label: "Organization",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
