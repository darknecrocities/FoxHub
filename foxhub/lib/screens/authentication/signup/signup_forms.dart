import 'package:flutter/material.dart';
import '../login_screen.dart';
import 'signup_helpers.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullname;
  final TextEditingController username;
  final TextEditingController number;
  final TextEditingController email;
  final TextEditingController pass;
  final List<String> courses;
  final String selectedCourse;
  final Function(String) onCourseChanged;
  final VoidCallback onRegister;

  const SignUpForm({
    super.key,
    required this.formKey,
    required this.fullname,
    required this.username,
    required this.number,
    required this.email,
    required this.pass,
    required this.courses,
    required this.selectedCourse,
    required this.onCourseChanged,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orangeAccent.shade400;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: orange.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _input(fullname, 'Full Name', Icons.person_outline,
                    (v) => validateNotEmpty(v, 'Full Name')),
            const SizedBox(height: 18),
            _input(username, 'Username', Icons.account_circle_outlined,
                    (v) => validateNotEmpty(v, 'Username')),
            const SizedBox(height: 18),
            _input(number, 'Contact Number', Icons.phone_outlined,
                    (v) => validateNotEmpty(v, 'Contact Number'),
                keyboardType: TextInputType.phone),
            const SizedBox(height: 18),
            _input(email, 'Email', Icons.email_outlined, validateEmail,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 18),
            _input(pass, 'Password', Icons.lock_outline, validatePassword,
                obscureText: true),
            const SizedBox(height: 22),
            _courseDropdown(orange),
            const SizedBox(height: 30),
            _registerButton(orange),
            const SizedBox(height: 15),
            _loginRedirect(context, orange),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label, IconData icon,
      String? Function(String?)? validator,
      {bool obscureText = false, TextInputType? keyboardType}) {
    final orange = Colors.orangeAccent.shade400;
    return TextFormField(
      controller: c,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: orange),
        ),
        fillColor: Colors.grey.shade50,
        filled: true,
      ),
      validator: validator,
    );
  }

  Widget _courseDropdown(Color orange) => DropdownButtonFormField<String>(
    value: selectedCourse,
    decoration: InputDecoration(
      labelText: 'Select Course',
      contentPadding:
      const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: orange),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    ),
    isExpanded: true,
    items: courses
        .map((course) => DropdownMenuItem(
      value: course,
      child: Text(course, overflow: TextOverflow.ellipsis),
    ))
        .toList(),
    onChanged: (val) => onCourseChanged(val!),
  );

  Widget _registerButton(Color orange) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: orange,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        shadowColor: Colors.orangeAccent,
        elevation: 10,
      ),
      child: const Text(
        'Register',
        style: TextStyle(fontSize: 18, color: Colors.white ,fontWeight: FontWeight.bold),
      ),
    ),
  );

  Widget _loginRedirect(BuildContext context, Color orange) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Already have an account? ',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        style: TextButton.styleFrom(
          foregroundColor: orange,
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Login here',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    ],
  );
}
