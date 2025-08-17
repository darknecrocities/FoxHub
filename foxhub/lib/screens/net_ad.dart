import 'package:flutter/material.dart';
import 'package:foxhub/widgets/customize_appbar.dart';
import 'package:foxhub/widgets/customize_navbar.dart';

import 'career_detail_screen.dart';

class NetAdScreen extends StatelessWidget {
  const NetAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Map career names to their JSON files
    final careers = {
      "Network Administrator":
          "lib/data/roadmap-content/network-administrator.json",
      "Server Side Game Developer ":
          "lib/data/roadmap-content/server-side-game-developer.json",
      "DevOps": "lib/data/roadmap-content/devops.json",
      "DevRel": "lib/data/roadmap-content/devrel.json",
      "Cloud Developer (AWS)": "lib/data/roadmap-content/aws.json",
      "Docker Developer": "lib/data/roadmap-content/docker.json",
      "System Design": "lib/data/roadmap-content/system-design.json",
    };

    return Scaffold(
      appBar: const CustomizeAppBar(title: "IT - Network Admin Roadmap"),
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
            final jsonPath = careers.values.elementAt(index);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CareerDetailScreen(
                      title: careerName,
                      jsonPath: jsonPath,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orangeAccent, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(3, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 2,
                  ),
                ),
                child: Text(
                  careerName,
                  style: const TextStyle(
                    fontFamily: "PressStart2P",
                    fontSize: 14,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(1, 1),
                        blurRadius: 1,
                      ),
                    ],
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
