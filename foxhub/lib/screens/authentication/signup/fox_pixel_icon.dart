import 'package:flutter/material.dart';

class FoxPixelIcon extends StatelessWidget {
  const FoxPixelIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFCE8D8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'lib/assets/images/fox_icon.png',
            width: 100, // adjust size as needed
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
