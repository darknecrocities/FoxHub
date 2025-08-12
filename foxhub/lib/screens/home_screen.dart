import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:foxhub/screens/community.dart';
import 'package:foxhub/screens/internship.dart';
import 'package:foxhub/screens/organization.dart';
import 'package:foxhub/screens/roadmap.dart';
import 'package:foxhub/widgets/customize_appbar.dart';
import 'package:foxhub/widgets/customize_navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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

  Future<void> onSearchChanged(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    final results = await SearchService.searchRoadmaps(query);
    setState(() {
      searchResults = results;
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
      appBar: const CustomizeAppBar(),
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
            TextField(
              controller: _searchController,
              onChanged: onSearchChanged,
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
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: orange),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search Results List
            if (searchResults.isNotEmpty)
              ...searchResults.map(
                (entry) => _buildSearchResultItem(context, entry),
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

  Widget _buildSearchResultItem(BuildContext context, RoadmapEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        title: Text(
          entry.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () => _showEntryDetails(context, entry),
      ),
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

  RoadmapEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.links,
  });

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
    'lib/data/roadmap-content/ai-agents.json',
    'lib/data/roadmap-content/ai-data-scientist.json',
    'lib/data/roadmap-content/ai-engineer.json',
    'lib/data/roadmap-content/ai-red-teaming.json',
    'lib/data/roadmap-content/android.json',
    'lib/data/roadmap-content/angular.json',
    'lib/data/roadmap-content/api-design.json',
    'lib/data/roadmap-content/aspnet-core.json',
    'lib/data/roadmap-content/aws.json',
    'lib/data/roadmap-content/backend.json',
    'lib/data/roadmap-content/blockchain.json',
    'lib/data/roadmap-content/cloudflare.json',
    'lib/data/roadmap-content/computer-science.json',
    'lib/data/roadmap-content/cpp.json',
    'lib/data/roadmap-content/cyber-security.json',
    'lib/data/roadmap-content/data-analyst.json',
    'lib/data/roadmap-content/devops.json',
    // Add more files if you have
  ];

  static Map<String, RoadmapEntry> _allEntries = {};

  // Load all JSON data once
  static Future<void> loadAllData() async {
    _allEntries.clear();
    for (var path in jsonFiles) {
      final jsonStr = await rootBundle.loadString(path);
      final Map<String, dynamic> data = json.decode(jsonStr);
      data.forEach((key, value) {
        final entry = RoadmapEntry.fromMap(key, value);
        _allEntries[key] = entry;
      });
    }
  }

  static Future<List<RoadmapEntry>> searchRoadmaps(String keyword) async {
    if (_allEntries.isEmpty) {
      await loadAllData();
    }
    final lowerKeyword = keyword.toLowerCase();
    final results = _allEntries.values
        .where((entry) => entry.title.toLowerCase().contains(lowerKeyword))
        .toList();
    print('Search "$keyword" found ${results.length} results');
    return results;
  }
}
