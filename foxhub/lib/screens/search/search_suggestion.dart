import 'package:flutter/material.dart';
import 'package:foxhub/models/roadmap_entry.dart';
import 'search_screen.dart';

class SearchSuggestionList extends StatelessWidget {
  final List<RoadmapEntry> entries;

  const SearchSuggestionList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return ListTile(
            title: Text(entry.title),
            leading: const Icon(Icons.search, color: Colors.orange),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(keyword: entry.title),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
