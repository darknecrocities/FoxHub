import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RoadmapCard extends StatelessWidget {
  final String title;
  final String description;
  final List<LinkItem> links;
  final VoidCallback? onTap;

  const RoadmapCard({
    Key? key,
    required this.title,
    required this.description,
    required this.links,
    this.onTap,
  }) : super(key: key);

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),

              // Links section (if any)
              if (links.isNotEmpty) ...[
                const Text(
                  "Resources:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: links.map((link) {
                    return ActionChip(
                      backgroundColor: Colors.deepPurple.shade50,
                      label: Text(
                        link.title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple,
                        ),
                      ),
                      onPressed: () => _openUrl(link.url),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LinkItem {
  final String title;
  final String url;
  final String type;

  LinkItem({required this.title, required this.url, required this.type});
}
