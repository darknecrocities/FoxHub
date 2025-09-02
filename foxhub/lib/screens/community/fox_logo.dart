import 'package:flutter/material.dart';

class FoxLogo extends StatelessWidget {
  final double size;

  const FoxLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.15),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Image.asset(
        'lib/assets/images/fox.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
