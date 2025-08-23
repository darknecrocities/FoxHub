/*
import 'dart:convert';
import 'package:http/http.dart' as http;

// Job model
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
    return Job(
      title: json['title'] ?? 'N/A',
      company: json['company'] ?? 'N/A',
      location: json['location'] ?? 'N/A',
      contractType: json['contractType'] ?? 'N/A',
      salary: json['salary'] ?? 'N/A',
      description: json['description'] ?? 'No description available',
    );
  }
}

// Service to fetch jobs
class AdzunaService {
  final String baseUrl = "https://fox-hub.vercel.app/api/jobs";

  Future<List<Job>> fetchJobs({String query = "developer"}) async {
    try {
      final url = Uri.parse("$baseUrl?query=$query");
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body); // direct List
        return data.map((e) => Job.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        print("Error from backend: ${response.statusCode} ${response.body}");
        return [];
      }
    } catch (e) {
      print("Backend fetch error: $e");
      return [];
    }
  }
}
*/