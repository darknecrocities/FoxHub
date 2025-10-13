import 'package:flutter/material.dart';

/// Background decorations for SignUp/Login screens
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

/// Validation Helpers

/// Checks if a field is not empty
String? validateNotEmpty(String? val, String field) =>
    (val == null || val.trim().isEmpty) ? '$field is required' : null;

/// Validates email format
String? validateEmail(String? val) {
  if (val == null || val.trim().isEmpty) return 'Email is required';
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return !emailRegex.hasMatch(val) ? 'Enter a valid email' : null;
}

/// Validates strong password
String? validatePassword(String? val) {
  if (val == null || val.isEmpty) return 'Password cannot be empty';
  if (val.length < 8) return 'Password must be at least 8 characters';
  if (!RegExp(r'[A-Z]').hasMatch(val)) return 'Password must include an uppercase letter';
  if (!RegExp(r'[a-z]').hasMatch(val)) return 'Password must include a lowercase letter';
  if (!RegExp(r'[0-9]').hasMatch(val)) return 'Password must include a number';
  return null; // password is valid
}
