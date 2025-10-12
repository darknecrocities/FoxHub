import 'dart:convert';

import 'package:http/http.dart' as http;

class Job {
  final String title;
  final String company;
  final String location;
  final String contractType;
  final String salary;
  final String description;

  Job({
    required this.title,
    required this.company,
    required this.location,
    required this.contractType,
    required this.salary,
    required this.description,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    String salaryText;
    if (json['salary_min'] != null && json['salary_max'] != null) {
      salaryText = '${json['salary_min']} - ${json['salary_max']} per year';
    } else {
      salaryText = 'N/A';
    }

    return Job(
      title: json['title'] ?? 'N/A',
      company: json['company']?['display_name'] ?? 'N/A',
      location: json['location']?['display_name'] ?? 'N/A',
      contractType: json['contract_type'] ?? 'N/A',
      salary: salaryText,
      description: json['description'] ?? 'No description available',
    );
  }
}

class AdzunaService {
  final String appId = '4e8b8448'; // Your Adzuna App ID
  final String appKey = 'YOUR_APP_KEY'; // Your App Key

  /// List of IT job queries
  final List<String> itQueries = [
    "software engineer",
    "data analyst",
    "AI engineer",
    "prompt engineer",
    "backend developer",
    "frontend developer",
    "cloud engineer",
    "machine learning engineer",
    "cybersecurity",
    "full stack developer",
    "web developer",
    "IT support",
    "DevOps engineer",
  ];

  Future<List<Job>> fetchJobs({
    String location = '', // optional
    String sort = 'date',
    required String jobTypeFilter,
    required String query,
  }) async {
    List<Job> allJobs = [];

    try {
      for (String query in itQueries) {
        final url = Uri.parse(
          'https://api.adzuna.com/v1/api/jobs/us/search/1'
          '?app_id=$appId&app_key=$appKey'
          '&results_per_page=10'
          '&what=$query'
          '${location.isNotEmpty ? '&where=$location' : ''}'
          '&sort_by=$sort',
        );

        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List results = data['results'];
          allJobs.addAll(results.map((e) => Job.fromJson(e)).toList());
        } else {
          print(
            "API Error [${response.statusCode}] for query $query: ${response.body}",
          );
        }
      }
    } catch (e) {
      print("Error fetching jobs: $e");
    }

    return allJobs;
  }
}
