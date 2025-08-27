import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final Function({String? filterAuthor}) onFilterApplied;

  const FilterButton({super.key, required this.onFilterApplied});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: () => _showFilterDialog(context),
          icon: const Icon(Icons.filter_alt, size: 18),
          label: const Text("Filter posts"),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final filterController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Filter posts by author"),
        content: TextField(
          controller: filterController,
          decoration: const InputDecoration(hintText: "Author name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onFilterApplied(filterAuthor: filterController.text.trim());
            },
            child: const Text("Apply"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onFilterApplied();
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }
}
