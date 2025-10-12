import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/roadmap_entry.dart';

class RoadmapDetailPage extends StatelessWidget {
  final RoadmapEntry entry;

  const RoadmapDetailPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orangeAccent.shade400;

    return Scaffold(
      appBar: AppBar(title: Text(entry.title), backgroundColor: orange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: entry.description.isNotEmpty
                  ? entry.description
                  : "No description available.",
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16),
                strong: TextStyle(fontWeight: FontWeight.bold, color: orange),
              ),
            ),
            const SizedBox(height: 20),
            if (entry.links.isNotEmpty)
              const Text(
                "Links:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ...entry.links.map(
                  (link) => ListTile(
                leading: Icon(
                  link.type == "video"
                      ? Icons.play_circle_fill
                      : (link.type == "article" ? Icons.article : Icons.link),
                  color: orange,
                ),
                title: Text(link.title),
                onTap: () async {
                  final url = Uri.parse(link.url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Could not open link")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
