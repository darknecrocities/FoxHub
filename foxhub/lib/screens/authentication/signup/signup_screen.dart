import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../login_screen.dart';
import 'fox_pixel_icon.dart';
import 'signup_forms.dart';
import 'signup_helpers.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _fullname = TextEditingController();
  final _username = TextEditingController();
  final _number = TextEditingController();

  String _selectedCourse = 'Bachelor Science in Computer Science';

  final List<String> _courses = [
    'Bachelor Science in Computer Science',
    'Bachelor Science in Information Technology major in Web Development',
    'Bachelor Science in Information Technology major in NetAD',
    'Bachelor Science in CyberSecurity',
    'Bachelor Science in Multimedia',
  ];

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _fullname.dispose();
    _username.dispose();
    _number.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        uid: '',
        fullName: _fullname.text.trim(),
        username: _username.text.trim(),
        email: _email.text.trim(),
        course: _selectedCourse,
        number: _number.text.trim(),
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(user, _pass.text.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? 'Registration successful! Please login.'
            : 'Registration failed. Try again.'),
      ));
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orangeAccent.shade400;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      body: Stack(
        children: [
          buildBackgroundDecorations(orange),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FoxPixelIcon(),
                  const SizedBox(height: 24),
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SignUpForm(
                    formKey: _formKey,
                    fullname: _fullname,
                    username: _username,
                    number: _number,
                    email: _email,
                    pass: _pass,
                    courses: _courses,
                    selectedCourse: _selectedCourse,
                    onCourseChanged: (val) =>
                        setState(() => _selectedCourse = val),
                    onRegister: _register,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
