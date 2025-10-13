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
    if (!_formKey.currentState!.validate()) return;

    // Extra password validation
    final passError = validatePassword(_pass.text.trim());
    if (passError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(passError)));
      return;
    }

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

    if (success) {
      // Show animated success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 12),
                  Text(
                    'Registration Successful!',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 1200));
      Navigator.of(context).pop(); // close dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Try again.')),
      );
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
                    onCourseChanged: (val) => setState(() => _selectedCourse = val),
                    onRegister: _register, // callback passed to child
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
