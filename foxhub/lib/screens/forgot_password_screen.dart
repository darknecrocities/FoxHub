import 'package:flutter/material.dart';
import 'package:foxhub/services/auth_service.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _email = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Enter Email')),
            ElevatedButton(
              onPressed: () {
                AuthService().resetPassword(_email.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Check your email.')));
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
