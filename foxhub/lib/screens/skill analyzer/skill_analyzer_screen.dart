import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:foxhub/widgets/appbar/customize_appbar.dart';
import 'package:foxhub/widgets/navbar/customize_navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SkillAnalyzerScreen extends StatefulWidget {
  const SkillAnalyzerScreen({super.key});

  @override
  State<SkillAnalyzerScreen> createState() => _SkillAnalyzerScreenState();
}

class _SkillAnalyzerScreenState extends State<SkillAnalyzerScreen>
    with SingleTickerProviderStateMixin {
  String? selectedCareer;
  String? selectedCourse;
  File? resumeFile;
  bool analyzing = false;
  Map<String, String> analysisResult = {};

  final List<String> careers = [
    "Software Engineer",
    "Mobile Developer",
    "AI Engineer",
    "Data Scientist",
    "Cybersecurity Specialist",
    "Web Developer",
    "Cloud Engineer",
    "Network Administrator",
    "Embedded Systems Engineer",
    "DevOps Engineer",
    "UI/UX Designer",
    "Game Developer",
    "IoT Engineer",
    "Blockchain Developer",
    "Full-stack Developer",
    "Front-end Developer",
    "Back-end Developer",
    "IT Support Specialist",
    "Machine Learning Engineer",
    "Robotics Engineer",
  ];

  final Map<String, List<String>> courses = {
    "Software Engineer": ["Java", "C#", "Python", "Software Design"],
    "Mobile Developer": ["Flutter", "Kotlin", "Swift", "Mobile UI/UX"],
    "AI Engineer": ["Machine Learning", "Deep Learning", "NLP", "Computer Vision"],
    "Data Scientist": ["Python", "R", "Data Analysis", "Statistics"],
    "Cybersecurity Specialist": ["Network Security", "Ethical Hacking", "Forensics"],
    "Web Developer": ["HTML/CSS", "JavaScript", "React", "Node.js"],
    "Cloud Engineer": ["AWS", "Azure", "Google Cloud", "DevOps"],
    "Network Administrator": ["CCNA", "Network Admin", "Cloud Networking"],
    "Embedded Systems Engineer": ["C", "Microcontrollers", "IoT"],
    "DevOps Engineer": ["CI/CD", "Docker", "Kubernetes"],
    "UI/UX Designer": ["Figma", "Adobe XD", "Prototyping"],
    "Game Developer": ["Unity", "Unreal Engine", "C#"],
    "IoT Engineer": ["Sensors", "Raspberry Pi", "Arduino"],
    "Blockchain Developer": ["Solidity", "Smart Contracts", "Ethereum"],
    "Full-stack Developer": ["React", "Node.js", "Databases", "REST APIs"],
    "Front-end Developer": ["HTML", "CSS", "JavaScript", "React"],
    "Back-end Developer": ["Node.js", "Django", "Flask", "Databases"],
    "IT Support Specialist": ["Troubleshooting", "Windows Admin", "Networking Basics"],
    "Machine Learning Engineer": ["Python", "ML Models", "TensorFlow", "Data Processing"],
    "Robotics Engineer": ["Robotics Design", "Sensors", "C++"],
  };

  final String apiKey = 'YOUR_API_KEY';

  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        resumeFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> takePicture() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        resumeFile = File(image.path);
      });
    }
  }

  Future<String> extractText(File file) async {
    final inputImage = InputImage.fromFile(file);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    return recognizedText.text;
  }

  Future<void> analyzeResume() async {
    if (resumeFile == null || selectedCareer == null || selectedCourse == null) return;

    setState(() {
      analyzing = true;
      analysisResult = {};
    });

    try {
      // 1️⃣ Extract text from resume
      String resumeText = await extractText(resumeFile!);
      if (resumeText.trim().isEmpty) {
        setState(() {
          analysisResult = {"Error": "No text detected from resume."};
        });
        return;
      }

      // 2️⃣ Short, structured Gemini prompt
      String prompt = """
You are a career analysis assistant. Review this resume and give short, clear insights.

1. Skill Level (Beginner, Intermediate, or Advanced)
2. Career Recommendation (related to $selectedCareer and $selectedCourse)
3. Project Ideas (2 short ideas)
4. Learning Resources (2 tutorials or websites)
5. Daily Tips (3 short lines)

Keep it under 200 words. Resume:
$resumeText
""";

      // 3️⃣ Gemini API call
      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": prompt}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.6,
            "maxOutputTokens": 600,
            "topP": 0.9,
            "topK": 40
          }
        }),
      );

      // 4️⃣ Handle Gemini response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("✅ Gemini raw response: $data");

        // Safely extract generated text (handles multiple JSON formats)
        String? textResult;
        try {
          textResult = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        } catch (_) {}
        textResult ??= data['candidates']?[0]?['content']?['text'];

        // Safely trim with null-aware operator
        final trimmedText = textResult?.trim() ?? '';

        if (trimmedText.isEmpty) {
          setState(() {
            analysisResult = {
              "Error": "Gemini returned no text. Try again or check API key access."
            };
          });
          return;
        }

        // 5️⃣ Display organized result
        setState(() {
          analysisResult = {"Analysis": trimmedText};
        });
      } else {
        setState(() {
          analysisResult = {
            "Error": "Gemini API returned ${response.statusCode}: ${response.body}"
          };
        });
      }
    } catch (e) {
      setState(() {
        analysisResult = {"Error": e.toString()};
      });
    } finally {
      setState(() {
        analyzing = false;
      });
    }
  }


  Widget buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 14,
              color: Colors.orange,
            )),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: Colors.orange.shade100,
          items: items
              .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13))))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.orange.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.orange, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAnalysisCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.deepOrangeAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.6),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(3, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: analysisResult.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.key,
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Colors.deepOrange,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  e.value,
                  style: const TextStyle(
                    fontFamily: 'CourierPrime',
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orange;

    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: const CustomizeAppBar(title: ''),
      drawer: buildAppDrawer(context),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildDropdown("Select Career Path", careers, selectedCareer, (val) {
              setState(() {
                selectedCareer = val;
                selectedCourse = null;
              });
            }),
            const SizedBox(height: 16),
            if (selectedCareer != null)
              buildDropdown(
                "Select Course / Skill Focus",
                courses[selectedCareer!]!,
                selectedCourse,
                    (val) => setState(() => selectedCourse = val),
              ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "UPLOAD YOUR RESUME",
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 12,
                  color: orange.shade900,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text("UPLOAD"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange.shade400,
                    shadowColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: takePicture,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("CAMERA"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange.shade400,
                    shadowColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (resumeFile != null)
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade200,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.deepOrange, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.insert_drive_file, color: Colors.brown),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          resumeFile!.path.split('/').last,
                          style: const TextStyle(
                            fontFamily: 'CourierPrime',
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () => setState(() => resumeFile = null),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: analyzing ? null : analyzeResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: analyzing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("ANALYZE", style: TextStyle(fontFamily: 'PressStart2P', fontSize: 12)),
              ),
            ),
            const SizedBox(height: 20),
            if (analysisResult.isNotEmpty) buildAnalysisCard(),
          ],
        ),
      ),
    );
  }
}
