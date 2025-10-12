import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foxhub/screens/community/community.dart';
import 'package:foxhub/screens/internship.dart';
import 'package:foxhub/screens/organizations/organization.dart';
import 'package:foxhub/screens/roadmap.dart';
import 'package:foxhub/screens/search/search_screen.dart';
import 'package:foxhub/widgets/customize_appbar.dart';
import 'package:foxhub/widgets/customize_navbar.dart';
import 'package:foxhub/screens/project/project_screen.dart';
import 'package:foxhub/models/roadmap_entry.dart';
import 'package:foxhub/screens/search/search_service.dart';
import 'community/fox_logo.dart';
import 'community/feature_button.dart';
import 'search/search_suggestion.dart';
import 'skill_analyzer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstName = "";
  final TextEditingController _searchController = TextEditingController();
  List<RoadmapEntry> searchResults = [];
  Timer? _debounce;

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
        setState(() {
          firstName = fullName.isNotEmpty ? fullName.split(' ').first : 'Friend';
        });
      } else {
        setState(() => firstName = 'Friend');
      }
    } else {
      setState(() => firstName = 'Friend');
    }
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isEmpty) {
        setState(() => searchResults = []);
        return;
      }
      final results = await SearchService.searchRoadmaps(query);
      setState(() => searchResults = results);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                const FoxLogo(size: 64),
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
              textInputAction: TextInputAction.search,
              onChanged: onSearchChanged,
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
                  borderSide: BorderSide(color: orange),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search Results List
            if (_searchController.text.isNotEmpty && searchResults.isNotEmpty)
              SearchSuggestionList(entries: searchResults),

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
                FeatureButton(
                  icon: Icons.map,
                  title: "Career Roadmaps",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RoadmapScreen()),
                  ),
                ),
                FeatureButton(
                  icon: Icons.work,
                  title: "Internships",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InternshipScreen()),
                  ),
                ),
                FeatureButton(
                  icon: Icons.group,
                  title: "Organizations",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrganizationScreen()),
                  ),
                ),
                FeatureButton(
                  icon: Icons.forum,
                  title: "Community Forums",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CommunityScreen()),
                  ),
                ),
                FeatureButton(
                  icon: Icons.lightbulb,
                  title: "Project Ideas",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProjectScreen()),
                  ),
                ),
                FeatureButton(
                  icon: Icons.analytics,
                  title: "Skill Analyzer",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SkillAnalyzerScreen()),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 0),
    );
  }
}
