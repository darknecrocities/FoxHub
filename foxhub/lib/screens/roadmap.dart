import 'package:flutter/material.dart';
import 'package:foxhub/screens/computer_science.dart';
import 'package:foxhub/screens/cybersecurity.dart';
import 'package:foxhub/screens/net_ad.dart';
import 'package:foxhub/screens/web_dev.dart';
import 'package:foxhub/widgets/customize_appbar.dart';
import 'package:foxhub/widgets/customize_navbar.dart';
import 'package:google_fonts/google_fonts.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orangeGradient = LinearGradient(
      colors: [Colors.orange.shade300, Colors.deepOrange.shade400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final courses = [
      {
        "title": "BS Computer Science",
        "icon": Icons.computer,
        "screen": const ComputerScienceScreen(),
      },
      {
        "title": "BS IT - Web Development",
        "icon": Icons.code,
        "screen": const WebDevScreen(),
      },
      {
        "title": "BS IT - Network Administration",
        "icon": Icons.router,
        "screen": const NetAdScreen(),
      },
      {
        "title": "BS IT - Cybersecurity",
        "icon": Icons.security,
        "screen": const CyberSecurityScreen(),
      },
    ];

    return Scaffold(
      appBar: const CustomizeAppBar(title: ''),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 0),
      body: Container(
        decoration: BoxDecoration(gradient: orangeGradient),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              "Choose Your Course",
              style: GoogleFonts.pressStart2p(
                fontSize: 18,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...courses.map((course) => _buildCourseCard(context, course)),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Map<String, dynamic> course) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => course["screen"],
            transitionsBuilder: (_, animation, __, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.orange.shade200, Colors.deepOrange.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(course["icon"], size: 40, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                course["title"],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
