import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orangeAccent.shade400;
    final bg = Theme.of(context).colorScheme.surface;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: orange.withOpacity(.35),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      project.title,
                      style: GoogleFonts.pressStart2p(
                        fontSize: 16,
                        color: orange,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: orange.withOpacity(.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: orange),
                    ),
                    child: Text(project.level, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _kv("Description", project.description),
              const SizedBox(height: 8),
              _kv("Concept", project.concept),
              const SizedBox(height: 16),

              Text("Tech Stack", style: GoogleFonts.pressStart2p(fontSize: 12)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.techStack
                    .map((tech) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: orange),
                  ),
                  child: Text(tech, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ))
                    .toList(),
              ),

              const SizedBox(height: 20),
              Text("Difficulty vs Salary", style: GoogleFonts.pressStart2p(fontSize: 12)),
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    maxY: _computeMaxY(project),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text("Difficulty");
                              case 1:
                                return const Text("Salary/10k");
                              default:
                                return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: project.difficulty.toDouble(),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(colors: [Colors.orangeAccent, orange]),
                          )
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: (project.salary / 10000).toDouble(),
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(colors: [Colors.deepOrangeAccent, orange]),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text("Course Outline", style: GoogleFonts.pressStart2p(fontSize: 12)),
              const SizedBox(height: 8),
              ..._buildCourseOutline(project.courseOutline, bg),
            ],
          ),
        ),
      ),
    );
  }

  double _computeMaxY(Project p) {
    final d = p.difficulty.toDouble();
    final s = (p.salary / 10000).toDouble();
    return (d > s ? d : s) + 2;
  }

  Widget _kv(String k, String v) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        children: [
          TextSpan(text: "$k: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: v),
        ],
      ),
    );
  }

  List<Widget> _buildCourseOutline(List<String> items, Color bg) {
    if (items.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bg.withOpacity(.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text("No course outline provided by AI this time. Try regenerating."),
        )
      ];
    }

    return items.asMap().entries.map((e) {
      final idx = e.key + 1;
      final text = e.value;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orangeAccent.withOpacity(.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 12, child: Text("$idx", style: const TextStyle(fontSize: 12))),
            const SizedBox(width: 8),
            Expanded(child: Text(text)),
          ],
        ),
      );
    }).toList();
  }
}

