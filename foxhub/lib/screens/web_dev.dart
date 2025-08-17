import 'package:flutter/material.dart';
import 'package:foxhub/screens/career_detail_screen.dart';
import 'package:foxhub/widgets/customize_appbar.dart';
import 'package:foxhub/widgets/customize_navbar.dart';

class WebDevScreen extends StatelessWidget {
  const WebDevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Map of Web Dev career options and their JSON files
    final careers = {
      "Frontend Developer": "lib/data/roadmap-content/frontend.json",
      "Backend Developer": "lib/data/roadmap-content/backend.json",
      "Fullstack Developer": "lib/data/roadmap-content/full-stack.json",
      "Mobile Developer (Flutter)": "lib/data/roadmap-content/flutter.json",
      "UI/UX Designer": "lib/data/roadmap-content/ux-design.json",
      "Game Developer": "lib/data/roadmap-content/game-developer.json",
      "Javascript Developer": "lib/data/roadmap-content/javascript.json",
      "IOS Developer": "lib/data/roadmap-content/ios.json",
    };

    return Scaffold(
      appBar: const CustomizeAppBar(title: "IT - Web Development Roadmap"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: careers.length,
          itemBuilder: (context, index) {
            final careerName = careers.keys.elementAt(index);
            final filePath = careers.values.elementAt(index);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CareerDetailScreen(
                      title: careerName,
                      jsonPath: filePath,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orangeAccent, width: 3),
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.6),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(4, 4),
                    ),
                  ],
                  gradient: const LinearGradient(
                    colors: [Colors.orangeAccent, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  careerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "PressStart2P",
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 1),
    );
  }
}
