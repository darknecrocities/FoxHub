// =====================================
// FILE: lib/screens/project_screen.dart
// =====================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/project.dart';
import '../../services/project_service.dart';
import '../../widgets/appbar/customize_appbar.dart';
import '../../widgets/navbar/customize_navbar.dart';
import '../../widgets/selector/difficulty_selector.dart';
import '../../widgets/cards/project_card.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final String apiKey = "AIzaSyCpwrfw4KoMaCyuykTUT3Zcrh1KkeZ1ltg";
  String? selectedCareer;
  String? selectedLevel = "Beginner"; // default selection
  bool loading = false;
  Project? project;

  final List<String> careerOptions = const [
    "Software Engineering",
    "Data Science",
    "AI & Machine Learning",
    "Cybersecurity",
    "Web Development",
    "Mobile Development",
    "Game Development",
    "UI/UX Design",
    "Cloud Computing",
  ];

  late final ProjectService _service = ProjectService(apiKey);

  Future<void> _generate({bool regenerate = false}) async {
    if (selectedCareer == null || selectedLevel == null) return;
    setState(() => loading = true);
    try {
      final p = await _service.generateProject(
        career: selectedCareer!,
        level: selectedLevel!,
      );
      setState(() {
        project = p;
      });
    } catch (e) {
      setState(() {
        project = Project(
          title: "Error",
          description: "There was an issue with the API: ${e.toString()}",
          concept: "",
          techStack: const [],
          difficulty: 0,
          salary: 0,
          level: selectedLevel ?? "",
          courseOutline: const [],
        );
      });
      if (e.toString().contains('503')) {
        // Retry logic, e.g., try again after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        await _generate(regenerate: regenerate); // retry the request
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orangeAccent.shade400;

    return Scaffold(
      appBar: const CustomizeAppBar(title: ''),
      drawer: buildAppDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "Choose Your Career Field",
              style: GoogleFonts.pressStart2p(
                fontSize: 12,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              value: selectedCareer,
              hint: const Text("Select a career field"),
              items: careerOptions
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCareer = val),
            ),

            const SizedBox(height: 16),
            Text(
              "Difficulty Level",
              style: GoogleFonts.pressStart2p(
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            DifficultySelector(
              value: selectedLevel,
              onChanged: (v) => setState(() => selectedLevel = v),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: loading ? null : () => _generate(),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text("Generate Project Idea"),
                  ),
                ),
                const SizedBox(width: 10),
                if (project != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: orange),
                      ),
                    ),
                    onPressed: loading
                        ? null
                        : () => _generate(regenerate: true),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Regenerate"),
                  ),
              ],
            ),

            const SizedBox(height: 20),
            if (loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            if (!loading && project != null) ProjectCard(project: project!),
          ],
        ),
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 0),
    );
  }
}

// =====================================
// NOTES
// =====================================
// • Replace REPLACE_WITH_YOUR_API_KEY with your Gemini API key or load from .env/secure storage.
// • New components:
//    - models/project.dart: Strongly-typed model
//    - services/project_service.dart: Networking + parsing
//    - widgets/difficulty_selector.dart: UI for Beginner/Intermediate/Advanced
//    - widgets/project_card.dart: Pretty card with improved chart and course outline
// • Prompt now includes `level` and `courseOutline`. The chart uses average salary from the returned range.
// • UI: better buttons, chip selector, improved gradients, and rounded gradient bars.
