import 'package:flutter/material.dart';
import 'package:foxhub/widgets/customize_appbar.dart';
import 'package:foxhub/widgets/customize_back_button.dart';
import 'package:foxhub/widgets/customize_navbar.dart';

import 'detail/career_detail_screen.dart';

class CyberSecurityScreen extends StatelessWidget {
  const CyberSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final careers = {
      "Cloud Engineer (AWS)": "lib/data/roadmap-content/aws.json",
      "Security Analyst":
          "lib/data/roadmap-content/cybersecurity-security-analyst.json",
      "Cloud Security Specialist":
          "lib/data/roadmap-content/cloud-security-specialist.json",
      "Cybersecurity": "lib/data/roadmap-content/cyber-security.json",
      "Network Engineer": "lib/data/roadmap-content/network-engineer.json",
      "Application Security Engineer":
          "lib/data/roadmap-content/application-security-engineer.json",
      "Penetration Tester": "lib/data/roadmap-content/pentester.json",
      "Linux Developer": "lib/data/roadmap-content/linux.json",
    };

    return Scaffold(
      appBar: const CustomizeAppBar(title: "Cybersecurity Roadmap"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Pixelated fox back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomizeBackButton(
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Career list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
          ],
        ),
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 0),
    );
  }
}
