import 'package:flutter/material.dart';

class CyberSecurityScreen extends StatelessWidget {
  const CyberSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cybersecurity Roadmap"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          roadmapCard(
            "Ethical Hacker",
            "Master penetration testing and vulnerability assessment.",
            "https://www.eccouncil.org/programs/certified-ethical-hacker-ceh/",
          ),
          roadmapCard(
            "Security Analyst",
            "Monitor systems, analyze threats, and prevent attacks.",
            "https://www.isc2.org/Certifications/CISSP",
          ),
          roadmapCard(
            "Cloud Security Specialist",
            "Secure cloud environments like AWS, Azure, GCP.",
            "https://aws.amazon.com/certification/",
          ),
        ],
      ),
    );
  }

  Widget roadmapCard(String title, String desc, String link) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orangeAccent, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {},
            child: Text(
              link,
              style: const TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
