import 'package:flutter/material.dart';

Widget buildBackgroundDecorations(Color orange) => Stack(
  children: [
    Positioned(
      top: 40,
      left: 30,
      child: _decorCircle(orange.withOpacity(0.1), 100),
    ),
    Positioned(
      bottom: 100,
      right: 40,
      child: _decorCircle(orange.withOpacity(0.12), 130),
    ),
  ],
);

Widget _decorCircle(Color color, double size) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
);

// Validation helpers
String? validateNotEmpty(String? val, String field) =>
    (val == null || val.trim().isEmpty) ? '$field is required' : null;

String? validateEmail(String? val) {
  if (val == null || val.trim().isEmpty) return 'Email is required';
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return !emailRegex.hasMatch(val) ? 'Enter a valid email' : null;
}

String? validatePassword(String? val) =>
    (val == null || val.length < 6) ? 'Password must be at least 6 characters' : null;
