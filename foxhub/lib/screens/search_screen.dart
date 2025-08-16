import 'package:flutter/material.dart';
import 'package:foxhub/widgets/customize_appbar.dart';
import 'package:foxhub/widgets/customize_navbar.dart';
import 'package:foxhub/screens/home_screen.dart'; // for RoadmapEntry and SearchService
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SearchScreen extends StatefulWidget {
  final String keyword;

  const SearchScreen({super.key, required this.keyword});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<RoadmapEntry> searchResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  Future<void> _performSearch() async {
    final results = await SearchService.searchRoadmaps(widget.keyword);
    setState(() {
      searchResults = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orangeAccent.shade400;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade100,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back,
              color: orange,
              size: 28,
            ),
          ),
        ),
        title: Text(
          'Search Results',
          style: GoogleFonts.pressStart2p(
            fontSize: 14,
            color: orange,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : searchResults.isEmpty
            ? Center(
          child: Text(
            'No results found for "${widget.keyword}"',
            style: GoogleFonts.pressStart2p(
              fontSize: 14,
              color: Colors.orange.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final entry = searchResults[index];
            return _buildResultCard(context, entry, orange);
          },
        ),
      ),
    );
  }

  Widget _buildResultCard(
      BuildContext context, RoadmapEntry entry, Color orange) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: Colors.orange.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.title,
              style: GoogleFonts.pressStart2p(
                fontSize: 18,
                color: orange,
              ),
            ),
            const SizedBox(height: 12),
            MarkdownBody(
              data: entry.description.isNotEmpty
                  ? entry.description
                  : "No description available.",
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 14),
                strong: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: orange,
                ),
              ),
            ),
            if (entry.links.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                "Links:",
                style: GoogleFonts.pressStart2p(
                  fontSize: 14,
                  color: orange,
                ),
              ),
              const SizedBox(height: 8),
              ...entry.links.map((link) => GestureDetector(
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
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        link.type == "video"
                            ? Icons.play_circle_fill
                            : (link.type == "article"
                            ? Icons.article
                            : Icons.link),
                        color: orange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          link.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            ]
          ],
        ),
      ),
    );
  }
}
