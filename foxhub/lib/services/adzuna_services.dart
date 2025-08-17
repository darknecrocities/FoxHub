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
      company: json['company']['display_name'] ?? 'N/A',
      location: json['location']['display_name'] ?? 'N/A',
      contractType: json['contract_type'] ?? 'N/A',
      salary: salaryText,
      description: json['description'] ?? 'No description available',
    );
  }
}

class AdzunaService {
  final String appId = 'YOUR_APP_ID'; // Your Adzuna App ID
  final String appKey = 'API_KEY'; // Your App Key

  Future<List<Job>> fetchJobs({
    String query = 'developer',
    String location = '', // optional
    String jobTypeFilter = 'all',
    String sort = 'date',
  }) async {
    final url = Uri.parse(
      'https://api.adzuna.com/v1/api/jobs/us/search/1?app_id=$appId&app_key=$appKey&results_per_page=20&what=$query${location.isNotEmpty ? '&where=$location' : ''}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        return results.map((e) => Job.fromJson(e)).toList();
      } else {
        print(response.body);
        throw Exception("Failed to fetch jobs");
      }
    } catch (e) {
      print("Error fetching jobs: $e");
      return [];
    }
  }
}
