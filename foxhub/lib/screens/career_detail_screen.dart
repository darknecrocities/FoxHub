import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foxhub/widgets/customize_appbar.dart';
import 'package:foxhub/widgets/customize_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

class CareerDetailScreen extends StatefulWidget {
  final String title;
  final String jsonPath;

  const CareerDetailScreen({
    super.key,
    required this.title,
    required this.jsonPath,
  });

  @override
  State<CareerDetailScreen> createState() => _CareerDetailScreenState();
}

class _CareerDetailScreenState extends State<CareerDetailScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? careerData;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    loadCareerData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadCareerData() async {
    final String response = await rootBundle.loadString(widget.jsonPath);
    final Map<String, dynamic> data = json.decode(response);
    if (mounted) {
      setState(() => careerData = data);
      _controller.forward();
    }
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  // Parse text for **bold** and divider --divider--
  List<Widget> parseText(String text) {
    List<Widget> widgets = [];
    final lines = text.split('\n');
    for (var line in lines) {
      line = line.trim();
      if (line == '--divider--') {
        widgets.add(
          Divider(
            color: Colors.orangeAccent.withOpacity(0.7),
            thickness: 2,
            height: 20,
          ),
        );
      } else if (line.contains('**')) {
        final parts = line.split('**');
        List<InlineSpan> spans = [];
        for (var i = 0; i < parts.length; i++) {
          spans.add(
            TextSpan(
              text: parts[i],
              style: TextStyle(
                fontWeight: i.isOdd ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          );
        }
        widgets.add(
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, height: 1.4),
              children: spans,
            ),
          ),
        );
      } else {
        widgets.add(
          Text(
            line,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        );
      }
      widgets.add(const SizedBox(height: 6));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizeAppBar(title: widget.title),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: careerData == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.orangeAccent),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: careerData!.entries.map((entry) {
                    final section = entry.value as Map<String, dynamic>;
                    final title = section["title"] ?? "Untitled Section";
                    final description =
                        section["description"] ?? "No description available.";
                    final links = section["links"] as List<dynamic>? ?? [];

                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _controller.value,
                          child: Transform.translate(
                            offset: Offset(0, 50 * (1 - _controller.value)),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orangeAccent.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(4, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.deepOrange,
                            width: 2.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "PressStart2P",
                                color: Colors.deepOrange,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 1,
                                    color: Colors.orangeAccent,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...parseText(description),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: links.map<Widget>((link) {
                                final linkMap = link as Map<String, dynamic>;
                                final linkTitle = linkMap["title"] ?? "";
                                final linkUrl = linkMap["url"] ?? "";
                                return InkWell(
                                  onTap: () => _launchUrl(linkUrl),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.orangeAccent,
                                        width: 1.5,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.orangeAccent,
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      linkTitle,
                                      style: const TextStyle(
                                        fontFamily: "PressStart2P",
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 1),
    );
  }
}
