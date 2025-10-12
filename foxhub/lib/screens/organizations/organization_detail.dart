import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foxhub/widgets/appbar/customize_appbar.dart';
import 'package:foxhub/widgets/navbar/customize_navbar.dart';

class OrganizationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> org;
  const OrganizationDetailScreen({super.key, required this.org});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizeAppBar(title: org["name"]),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  org["banner"],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // Logo + Name
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(org["logo"]),
                    radius: 35,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      org["name"],
                      style: GoogleFonts.pressStart2p(
                        fontSize: 14,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Category
              _buildTag("Category", org["category"], Colors.orange.shade100, Colors.orange.shade900),

              const SizedBox(height: 10),
              // Career Path
              _buildTag("Career Path", org["careerPath"], Colors.blue.shade100, Colors.blue.shade900),

              const SizedBox(height: 20),

              // Description
              Text(
                org["description"],
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 20),

              // Features
              Text(
                "Key Features:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
              ),
              const SizedBox(height: 8),
              ...org["features"].map<Widget>((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Colors.orange),
                    const SizedBox(width: 6),
                    Expanded(child: Text(f, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              )),

              const SizedBox(height: 30),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.group_add, color: Colors.white),
                    label: const Text("Join", style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    label: const Text("Learn More", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 1),
    );
  }

  Widget _buildTag(String label, String value, Color bg, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.4)),
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
