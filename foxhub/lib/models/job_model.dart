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
    // Handle salary if backend has salary_min and salary_max
    String salaryText;
    if (json['salary_min'] != null && json['salary_max'] != null) {
      salaryText = '${json['salary_min']} - ${json['salary_max']} per year';
    } else if (json['salary'] != null) {
      salaryText = json['salary'];
    } else {
      salaryText = 'N/A';
    }

    return Job(
      title: json['title'] ?? 'N/A',
      company: json['company'] != null
          ? json['company']['display_name'] ?? 'N/A'
          : 'N/A',
      location: json['location'] != null
          ? json['location']['display_name'] ?? 'N/A'
          : 'N/A',
      contractType: json['contract_type'] ?? 'N/A',
      salary: salaryText,
      description: json['description'] ?? 'No description available',
    );
  }
}
