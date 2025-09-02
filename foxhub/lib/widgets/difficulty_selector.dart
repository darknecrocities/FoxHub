import 'package:flutter/material.dart';


class DifficultySelector extends StatelessWidget {
  final String? value; // Beginner | Intermediate | Advanced
  final ValueChanged<String> onChanged;


  const DifficultySelector({super.key, required this.value, required this.onChanged});


  @override
  Widget build(BuildContext context) {
    final levels = const ["Beginner", "Intermediate", "Advanced"];


    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: levels.map((lvl) {
        final selected = value == lvl;
        return ChoiceChip(
          label: Text(lvl),
          selected: selected,
          onSelected: (_) => onChanged(lvl),
          elevation: selected ? 4 : 0,
          pressElevation: 0,
          avatar: selected ? const Icon(Icons.check, size: 16) : null,
        );
      }).toList(),
    );
  }
}