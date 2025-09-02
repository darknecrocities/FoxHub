class Project {
  final String title;
  final String description;
  final String concept;
  final List<String> techStack;
  final int difficulty; // 1-10
  final int salary; // average monthly salary (parsed from range)
  final String level; // Beginner | Intermediate | Advanced
  final List<String> courseOutline; // optional from AI


  Project({
    required this.title,
    required this.description,
    required this.concept,
    required this.techStack,
    required this.difficulty,
    required this.salary,
    required this.level,
    required this.courseOutline,
  });
}