import 'dart:convert';
import 'package:http/http.dart' as http;

// Job class
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

// Backend service that fetches jobs
class BackendService {
  final String baseUrl =  "http://192.168.100.62:3000/api/jobs";

  Future<List<Job>> fetchJobs({String query = "developer"}) async {
    try {
      final url = Uri.parse("$baseUrl?query=$query");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => Job.fromJson(e)).toList();
      } else {
        print("Error from backend: ${response.body}");
        throw Exception("Failed to fetch jobs from backend");
      }
    } catch (e) {
      print("Backend fetch error: $e");
      return [];
    }
  }
}
