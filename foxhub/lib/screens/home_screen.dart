import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:foxhub/screens/community.dart';
import 'package:foxhub/screens/internship.dart';
import 'package:foxhub/screens/organization.dart';
import 'package:foxhub/screens/roadmap.dart';
import 'package:foxhub/screens/search_screen.dart';
import 'package:foxhub/widgets/customize_appbar.dart';
import 'package:foxhub/widgets/customize_navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

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

class _HomeScreenState extends State<HomeScreen> {
  String firstName = "";

  final TextEditingController _searchController = TextEditingController();
  List<RoadmapEntry> searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadUserFirstName();
  }

  Future<void> _loadUserFirstName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        final data = doc.data();
        final fullName = data != null ? (data['username'] ?? '') : '';
        if (fullName.isNotEmpty) {
          setState(() {
            firstName = fullName.split(' ').first;
          });
        } else {
          setState(() {
            firstName = 'Friend';
          });
        }
      } else {
        setState(() {
          firstName = 'Friend';
        });
      }
    } else {
      setState(() {
        firstName = 'Friend';
      });
    }
  }

  Timer? _debounce;

  void onSearchChanged(String query) {
    // Cancel previous timer if still active
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new 500ms timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isEmpty) {
        setState(() => searchResults = []);
        return;
      }

      // Perform search (can be isolate-based for speed)
      final results = await SearchService.searchRoadmaps(query);

      setState(() => searchResults = results);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget foxLogo({double size = 100}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.15),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Image.asset(
        'lib/assets/images/fox.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ListView(
          children: [
            Row(
              children: [
                foxLogo(size: 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Welcome back, ${firstName.isNotEmpty ? firstName : "Friend"}!",
                    style: GoogleFonts.pressStart2p(
                      fontSize: 14,
                      color: Colors.orange.shade700,
                      shadows: [
                        Shadow(
                          color: Colors.orange.shade300,
                          blurRadius: 6,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar
            // Replace your TextField with this:
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                onSearchChanged(value); // live search results
              },
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(keyword: value.trim()),
                    ),
                  );
                }
              },
              decoration: InputDecoration(
                hintText: "Search roadmap, organization, internship...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.orangeAccent.shade400),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search Results List
            // Live search suggestions
            if (_searchController.text.isNotEmpty && searchResults.isNotEmpty)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final entry = searchResults[index];
                    return _buildSearchSuggestionItem(context, entry);
                  },
                ),
              ),

            const SizedBox(height: 20),

            // Filter Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterChip(
                  label: const Text("Date"),
                  onSelected: (_) {},
                  selectedColor: Colors.orange.shade100,
                ),
                FilterChip(
                  label: const Text("Category"),
                  onSelected: (_) {},
                  selectedColor: Colors.orange.shade100,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Feature Buttons
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildFeatureButton(
                  context,
                  Icons.map,
                  "Career Roadmaps",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RoadmapScreen()),
                    );
                  },
                ),
                _buildFeatureButton(
                  context,
                  Icons.work,
                  "Internships",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InternshipScreen(),
                      ),
                    );
                  },
                ),
                _buildFeatureButton(
                  context,
                  Icons.group,
                  "Organizations",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrganizationScreen(),
                      ),
                    );
                  },
                ),
                _buildFeatureButton(
                  context,
                  Icons.forum,
                  "Community Forums",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CommunityScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 0),
    );
  }

  Widget _buildSearchSuggestionItem(BuildContext context, RoadmapEntry entry) {
    return ListTile(
      title: Text(entry.title),
      leading: const Icon(Icons.search, color: Colors.orange),
      onTap: () {
        // Navigate to SearchScreen with the tapped title as keyword
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SearchScreen(keyword: entry.title)),
        );
      },
    );
  }

  void _showEntryDetails(BuildContext context, RoadmapEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.orange.shade50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  entry.description.isNotEmpty
                      ? entry.description
                      : "No description available.",
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
                          : (link.type == "article"
                                ? Icons.article
                                : Icons.link),
                      color: Colors.orange.shade600,
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
      },
    );
  }

  Widget _buildFeatureButton(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: (MediaQuery.of(context).size.width / 2) - 24,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.orange.shade400),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------- Search Service and Models ------------

class RoadmapEntry {
  final String id;
  final String title;
  final String description;
  final List<LinkItem> links;

  // Precomputed lowercase for search
  late final String _lowerTitle;
  late final List<String> _lowerLinkTitles;

  RoadmapEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.links,
  }) {
    _lowerTitle = title.toLowerCase();
    _lowerLinkTitles = links.map((l) => l.title.toLowerCase()).toList();
  }

  bool matches(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    if (_lowerTitle.contains(lowerKeyword)) return true;
    for (final linkTitle in _lowerLinkTitles) {
      if (linkTitle.contains(lowerKeyword)) return true;
    }
    return false;
  }

  factory RoadmapEntry.fromMap(String id, Map<String, dynamic> map) {
    return RoadmapEntry(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      links: map['links'] != null
          ? List<LinkItem>.from(map['links'].map((x) => LinkItem.fromMap(x)))
          : [],
    );
  }
}

class LinkItem {
  final String title;
  final String url;
  final String type;

  LinkItem({required this.title, required this.url, required this.type});

  factory LinkItem.fromMap(Map<String, dynamic> map) {
    return LinkItem(
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      type: map['type'] ?? 'article',
    );
  }
}

class SearchService {
  // List all your roadmap JSON files here:
  static List<String> jsonFiles = [
    'lib/data/search/search_data.json',
    // Add more files if you have
  ];

  static Map<String, RoadmapEntry> _allEntries = {};

  // Load all JSON data once
  static Future<void> loadAllData() async {
    _allEntries.clear();
    for (var path in jsonFiles) {
      final jsonStr = await rootBundle.loadString(path);

      // Parse in background isolate
      final Map<String, dynamic> data = await compute(parseJson, jsonStr);

      data.forEach((key, value) {
        final entry = RoadmapEntry.fromMap(key, value);
        _allEntries[key] = entry;
      });
    }
  }

  // Helper for compute
  static Map<String, dynamic> parseJson(String jsonStr) {
    return json.decode(jsonStr) as Map<String, dynamic>;
  }

  static List<RoadmapEntry>? _entriesList;

  static Future<List<RoadmapEntry>> searchRoadmaps(String keyword) async {
    if (_allEntries.isEmpty) {
      await loadAllData();
    }

    _entriesList ??= _allEntries.values.toList(); // only once
    final lowerKeyword = keyword.toLowerCase();

    final List<RoadmapEntry> results = [];

    for (final entry in _entriesList!) {
      // Priority: title match first
      if (entry._lowerTitle.contains(lowerKeyword)) {
        results.add(entry);
      } else {
        // Check links only if title didn't match
        for (final linkTitle in entry._lowerLinkTitles) {
          if (linkTitle.contains(lowerKeyword)) {
            results.add(entry);
            break; // No need to check other links
          }
        }
      }

      // Stop early if we already have 10 results
      if (results.length >= 15) break;
    }

    print('Search "$keyword" found ${results.length} results');
    return results;
  }
}
