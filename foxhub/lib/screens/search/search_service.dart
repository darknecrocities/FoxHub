import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:foxhub/models/roadmap_entry.dart';

class SearchService {
  static List<String> jsonFiles = [
    'lib/data/search/search_data.json',
  ];

  static Map<String, RoadmapEntry> _allEntries = {};
  static List<RoadmapEntry>? _entriesList;

  static Future<void> loadAllData() async {
    _allEntries.clear();
    for (var path in jsonFiles) {
      final jsonStr = await rootBundle.loadString(path);
      final Map<String, dynamic> data = await compute(parseJson, jsonStr);
      data.forEach((key, value) {
        final entry = RoadmapEntry.fromMap(key, value);
        _allEntries[key] = entry;
      });
    }
  }

  static Map<String, dynamic> parseJson(String jsonStr) {
    return json.decode(jsonStr) as Map<String, dynamic>;
  }

  static Future<List<RoadmapEntry>> searchRoadmaps(String keyword) async {
    if (_allEntries.isEmpty) {
      await loadAllData();
    }

    _entriesList ??= _allEntries.values.toList();
    final lowerKeyword = keyword.toLowerCase();
    final List<RoadmapEntry> results = [];

    for (final entry in _entriesList!) {
      if (entry.matches(lowerKeyword)) {
        results.add(entry);
      }
      if (results.length >= 15) break;
    }

    print('Search "$keyword" found ${results.length} results');
    return results;
  }
}
