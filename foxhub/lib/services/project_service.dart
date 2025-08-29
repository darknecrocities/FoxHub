// ===============================
// FILE: lib/services/project_service.dart
// ===============================
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';

class ProjectService {
  final String apiKey; // Move this to secure storage for production
  ProjectService(this.apiKey);

  Future<Project> generateProject({
    required String career,
    required String level, // Beginner | Intermediate | Advanced
  }) async {
    final prompt = """
Generate a unique project idea for a career in $career.
The user-selected skill level is: $level.
Return ONLY JSON in this exact structure (no backticks, no surrounding text):
{
  "title": "Project Title",
  "description": "Project description",
  "concept": "Concept/Goal of the project",
  "techStack": ["Tech1", "Tech2"],
  "difficulty": 1-10,
  "salary": "50000-70000", // monthly local currency range (numbers only)
  "level": "$level",
  "courseOutline": [
    "Module 1 - ...",
    "Module 2 - ...",
    "Module 3 - ..."
  ]
}
""";

    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch project idea: ${response.statusCode}");
    }

    final decoded = jsonDecode(response.body);
    final text = decoded["candidates"][0]["content"]["parts"][0]["text"]
    as String;

    // Extract JSON substring defensively
    final jsonStart = text.indexOf('{');
    final jsonEnd = text.lastIndexOf('}');
    if (jsonStart == -1 || jsonEnd == -1 || jsonEnd <= jsonStart) {
      throw const FormatException("JSON not found in AI response");
    }
    final jsonString = text.substring(jsonStart, jsonEnd + 1);
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    // Parse salary range -> average
    int parseSalaryAvg(dynamic salaryRaw) {
      final onlyNums = salaryRaw.toString().replaceAll(RegExp(r"[^0-9-]"), "");
      final parts = onlyNums.split('-');
      if (parts.length == 2) {
        final a = int.tryParse(parts[0]) ?? 0;
        final b = int.tryParse(parts[1]) ?? a;
        return ((a + b) / 2).round();
      }
      return int.tryParse(onlyNums) ?? 0;
    }

    return Project(
      title: (data["title"] ?? "Untitled").toString(),
      description: (data["description"] ?? "").toString(),
      concept: (data["concept"] ?? "").toString(),
      techStack: (data["techStack"] as List?)?.map((e) => e.toString()).toList() ?? const [],
      difficulty: int.tryParse(data["difficulty"].toString()) ?? 5,
      salary: parseSalaryAvg(data["salary"]),
      level: (data["level"] ?? level).toString(),
      courseOutline: (data["courseOutline"] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }
}

