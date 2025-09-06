import 'package:flutter/material.dart';

class CustomizeBackButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CustomizeBackButton({super.key, required this.onPressed});

  @override
  State<CustomizeBackButton> createState() => _CustomizeBackButtonState();
}

class _CustomizeBackButtonState extends State<CustomizeBackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.orangeAccent,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(6), // Pixel-ish corners
            boxShadow: [
              BoxShadow(
                color: Colors.orangeAccent.withOpacity(0.8),
                blurRadius: 0,
                spreadRadius: 2,
                offset: const Offset(3, 3), // pixel shadow style
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pixelated arrow (not just the default icon)
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.orangeAccent, width: 3),
                    bottom: BorderSide(color: Colors.orangeAccent, width: 3),
                  ),
                ),
                transform: Matrix4.rotationZ(-0.8),
              ),
              const SizedBox(width: 8),
              Text(
                "BACK",
                style: TextStyle(
                  fontFamily: "PressStart2P",
                  fontSize: 12,
                  color: Colors.orangeAccent,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.8),
                      offset: const Offset(1, 1),
                    ),
                    const Shadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


