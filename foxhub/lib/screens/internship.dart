import 'package:flutter/material.dart';
import 'dart:convert';

import '../services/adzuna_services.dart';
import '../widgets/customize_appbar.dart';
import '../widgets/customize_navbar.dart';
import 'package:http/http.dart' as http; // for http.get

class InternshipScreen extends StatefulWidget {
  const InternshipScreen({super.key});

  @override
  State<InternshipScreen> createState() => _InternshipScreenState();
}

class _InternshipScreenState extends State<InternshipScreen> {
  final AdzunaService _service = AdzunaService();
  List<Job> jobs = [];
  String jobTypeFilter = 'all';
  String sortFilter = 'date';
  bool loading = true;
  final String baseUrl = "http://192.168.100.62:3000/api/jobs";
  final Map<int, bool> expandedMap = {}; // track which card is expanded

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs({String query = "developer"}) async {
    setState(() => loading = true);
    try {
      final uri = Uri.parse(baseUrl).replace(queryParameters: {'query': query});
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          jobs = data.map((e) => Job.fromJson(e as Map<String, dynamic>)).toList();
          loading = false;
        });
      } else {
        print("Error from backend: ${response.statusCode} ${response.body}");
        setState(() => loading = false);
      }
    } catch (e) {
      print("Backend fetch error: $e");
      setState(() => loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomizeAppBar(title: "Internships"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Filters
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: jobTypeFilter,
                    dropdownColor: Colors.deepOrange,
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text("All")),
                      DropdownMenuItem(value: 'remote', child: Text("Remote")),
                      DropdownMenuItem(
                        value: 'f2f',
                        child: Text("Face to Face"),
                      ),
                      DropdownMenuItem(value: 'hybrid', child: Text("Hybrid")),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => jobTypeFilter = val);
                        fetchJobs();
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: sortFilter,
                    dropdownColor: Colors.deepOrange,
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(value: 'date', child: Text("Newest")),
                      DropdownMenuItem(value: 'salary', child: Text("Salary")),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => sortFilter = val);
                        fetchJobs();
                      }
                    },
                  ),
                ],
              ),
            ),

            // Job List
            Expanded(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                  : jobs.isEmpty
                  ? const Center(
                      child: Text(
                        "No internships found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        final isExpanded = expandedMap[index] ?? false;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orangeAccent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orangeAccent.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                expandedMap[index] = !isExpanded;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "PressStart2P",
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    job.company,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${job.location} • ${job.contractType}",
                                    style: const TextStyle(
                                      color: Colors.white54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Salary: ${job.salary}",
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Expandable description
                                  AnimatedCrossFade(
                                    firstChild: Text(
                                      job.description.length > 100
                                          ? job.description.substring(0, 100) +
                                                "..."
                                          : job.description,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    secondChild: Text(
                                      job.description,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    crossFadeState: isExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                  const SizedBox(height: 12),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                            const InternshipApplyDialog(),
                                      );
                                    },
                                    child: const Text("Apply"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 1),
    );
  }
}

class InternshipApplyDialog extends StatelessWidget {
  const InternshipApplyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      title: const Text(
        "Apply for Internship",
        style: TextStyle(color: Colors.orangeAccent),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Full Name",
              labelStyle: TextStyle(color: Colors.orangeAccent),
            ),
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: Colors.orangeAccent),
            ),
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Resume URL",
              labelStyle: TextStyle(color: Colors.orangeAccent),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Application submitted!")),
            );
          },
          child: const Text(
            "Submit",
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
      ],
    );
  }
}
