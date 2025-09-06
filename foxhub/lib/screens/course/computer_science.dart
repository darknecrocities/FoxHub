import 'package:flutter/material.dart';
import 'package:foxhub/widgets/customize_back_button.dart';
import 'package:foxhub/widgets/customize_navbar.dart';
import 'package:foxhub/widgets/customize_appbar.dart';

import 'detail/career_detail_screen.dart';

class ComputerScienceScreen extends StatelessWidget {
  const ComputerScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final careers = {
      "AI Engineer": "lib/data/roadmap-content/ai-engineer.json",
      "AI Data Scientist": "lib/data/roadmap-content/ai-data-scientist.json",
      "Data Analyst": "lib/data/roadmap-content/data-analyst.json",
      "Full Stack Developer": "lib/data/roadmap-content/full-stack.json",
      "Game Developer": 'lib/data/roadmap-content/game-developer.json',
      "Software Architect": "lib/data/roadmap-content/software-architect.json",
      "Blockchain Developer": "lib/data/roadmap-content/blockchain.json",
      "Prompt Engineer": "lib/data/roadmap-content/prompt-engineering.json",
      "Backend Developer": "lib/data/roadmap-content/backend.json",
      "DevOps": "lib/data/roadmap-content/devops.json",
      "Cloud Engineer (AWS)": "lib/data/roadmap-content/aws.json",
    };

    return Scaffold(
      appBar: const CustomizeAppBar(
        title: "Computer Science Roadmap", // ✅ use custom app bar
      ),
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
            // Pixelated fox back button inside the body
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
                        border: Border.all(
                          color: Colors.orangeAccent,
                          width: 3,
                        ),
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
                      ),
                      child: Text(
                        careerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "PressStart2P",
                          color: Colors.orangeAccent,
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
