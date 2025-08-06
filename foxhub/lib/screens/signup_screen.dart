import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _number = TextEditingController();

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

  // Use the pixelBlock & foxPixelIcon from your login screen here for consistency:
  Widget pixelBlock(Color color, {double size = 12}) {
    return Container(width: size, height: size, color: color);
  }

  Widget foxPixelIcon() {
    const Color darkBrown = Color(0xFF5C2A00);
    const Color orange = Color(0xFFF97316);
    const Color lightOrange = Color(0xFFFBAF4C);
    const Color white = Color(0xFFF5E6D0);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCE8D8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            pixelBlock(Colors.transparent, size: 12),
            pixelBlock(darkBrown),
            pixelBlock(darkBrown),
            pixelBlock(Colors.transparent, size: 12),
            pixelBlock(Colors.transparent, size: 12),
            pixelBlock(darkBrown),
            pixelBlock(darkBrown),
            pixelBlock(Colors.transparent, size: 12),
          ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            pixelBlock(darkBrown),
            pixelBlock(orange),
            pixelBlock(orange),
            pixelBlock(darkBrown),
            pixelBlock(darkBrown),
            pixelBlock(orange),
            pixelBlock(orange),
            pixelBlock(darkBrown),
          ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            pixelBlock(orange),
            pixelBlock(orange),
            pixelBlock(lightOrange),
            pixelBlock(lightOrange),
            pixelBlock(lightOrange),
            pixelBlock(lightOrange),
            pixelBlock(orange),
            pixelBlock(orange),
          ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            pixelBlock(orange),
            pixelBlock(white),
            pixelBlock(white),
            pixelBlock(darkBrown),
            pixelBlock(darkBrown),
            pixelBlock(white),
            pixelBlock(white),
            pixelBlock(orange),
          ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            pixelBlock(Colors.transparent, size: 12),
            pixelBlock(darkBrown),
            pixelBlock(Colors.transparent, size: 12),
            pixelBlock(darkBrown),
            pixelBlock(darkBrown),
            pixelBlock(Colors.transparent, size: 12),
            pixelBlock(darkBrown),
            pixelBlock(Colors.transparent, size: 12),
          ]),
        ],
      ),
    );
  }

  String? _validateNotEmpty(String? val, String field) {
    if (val == null || val.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  String? _validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(val)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? val) {
    if (val == null || val.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
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

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please login.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed. Try again.')),
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
          // Subtle decorative circles like on login background
          Positioned(
            top: 40,
            left: 30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 40,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: orange.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fox pixel icon on top with margin
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: foxPixelIcon(),
                  ),

                  // Title
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Form card with white background and shadows
                  Container(
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
                      key: _formKey,
                      child: Column(
                        children: [
                          // Full Name
                          TextFormField(
                            controller: _fullname,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
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
                            validator: (val) => _validateNotEmpty(val, 'Full Name'),
                          ),
                          const SizedBox(height: 18),

                          // Username
                          TextFormField(
                            controller: _username,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: const Icon(Icons.account_circle_outlined, color: Colors.grey),
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
                            validator: (val) => _validateNotEmpty(val, 'Username'),
                          ),
                          const SizedBox(height: 18),

                          // Contact Number
                          TextFormField(
                            controller: _number,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Contact Number',
                              prefixIcon: const Icon(Icons.phone_outlined, color: Colors.grey),
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
                            validator: (val) => _validateNotEmpty(val, 'Contact Number'),
                          ),
                          const SizedBox(height: 18),

                          // Email
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
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
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 18),

                          // Password
                          TextFormField(
                            controller: _pass,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
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
                            validator: _validatePassword,
                          ),

                          const SizedBox(height: 22),

                          // Course Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedCourse,
                            decoration: InputDecoration(
                              labelText: 'Select Course',
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
                            items: _courses
                                .map((course) => DropdownMenuItem(
                              value: course,
                              child: Text(course),
                            ))
                                .toList(),
                            onChanged: (val) => setState(() => _selectedCourse = val!),
                          ),

                          const SizedBox(height: 30),

                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _register,
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
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Login redirect text button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an account? ',
                                  style: TextStyle(fontSize: 14, color: Colors.grey)),
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
                          ),
                        ],
                      ),
                    ),
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
