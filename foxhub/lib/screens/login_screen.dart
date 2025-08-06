import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foxhub/providers/auth_provider.dart';
import '../screens/home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  // Helper widget to build each pixel block for fox icon
  Widget pixelBlock(Color color, {double size = 12}) {
    return Container(
      width: size,
      height: size,
      color: color,
    );
  }

  // Fox pixel icon as a widget using Rows and Columns
  Widget foxPixelIcon() {
    // Colors
    const Color darkBrown = Color(0xFF5C2A00);
    const Color orange = Color(0xFFF97316);
    const Color lightOrange = Color(0xFFFBAF4C);
    const Color white = Color(0xFFF5E6D0);

    // Background orange with circles painted via Stack and Positioned containers with low opacity
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF97316), // bright orange bg
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade700.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle circle patterns (overlapping translucent circles)
          Positioned(
            top: 20,
            left: 15,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 50,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Center pixel fox face
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFCE8D8),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pixel rows for sharper fox face shape
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      pixelBlock(Colors.transparent, size: 12),
                      pixelBlock(darkBrown),
                      pixelBlock(orange),
                      pixelBlock(orange),
                      pixelBlock(orange),
                      pixelBlock(orange),
                      pixelBlock(darkBrown),
                      pixelBlock(Colors.transparent, size: 12),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      pixelBlock(darkBrown),
                      pixelBlock(lightOrange),
                      pixelBlock(lightOrange),
                      pixelBlock(lightOrange),
                      pixelBlock(lightOrange),
                      pixelBlock(lightOrange),
                      pixelBlock(lightOrange),
                      pixelBlock(darkBrown),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      pixelBlock(orange),
                      pixelBlock(lightOrange),
                      pixelBlock(white),
                      pixelBlock(white),
                      pixelBlock(white),
                      pixelBlock(white),
                      pixelBlock(lightOrange),
                      pixelBlock(orange),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      pixelBlock(orange),
                      pixelBlock(white),
                      pixelBlock(darkBrown),
                      pixelBlock(Colors.transparent, size: 12),
                      pixelBlock(Colors.transparent, size: 12),
                      pixelBlock(darkBrown),
                      pixelBlock(white),
                      pixelBlock(orange),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      pixelBlock(Colors.transparent, size: 12),
                      pixelBlock(darkBrown),
                      pixelBlock(Colors.transparent, size: 12),
                      pixelBlock(Colors.transparent, size: 12),
                      pixelBlock(Colors.transparent, size: 12),
                      pixelBlock(Colors.transparent, size: 12),
                      pixelBlock(darkBrown),
                      pixelBlock(Colors.transparent, size: 12),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orangeAccent.shade400;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1), // soft orange background
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fox pixel icon at the top, with shadow and margin
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: foxPixelIcon(),
                ),

                // Login card with rounded corners and shadow
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Foxhub",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Email TextField with icon prefix
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                          hintText: "Email Address",
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
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 18),

                      // Password TextField with icon prefix
                      TextField(
                        controller: pass,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
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
                      ),
                      const SizedBox(height: 28),

                      // Big rounded orange login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await Provider.of<AuthProvider>(context, listen: false)
                                .login(email.text.trim(), pass.text.trim());
                            if (success) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Login failed. Please check your credentials.")),
                              );
                            }
                          },
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
                            "Login",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Bottom text row with forgot password and signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[800],
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: orange,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "No account? Sign up",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
