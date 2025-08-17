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
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Tap scale animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Gradient animation for text
    _colorAnimation = ColorTween(
      begin: Colors.orangeAccent,
      end: Colors.deepOrange,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Loop gradient animation
    _controller.repeat(reverse: true);
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.orangeAccent, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white70, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.withOpacity(0.6),
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => Text(
                  "Back",
                  style: TextStyle(
                    fontFamily: "PressStart2P",
                    fontSize: 14,
                    color: _colorAnimation.value,
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        color: Colors.white.withOpacity(0.7),
                        offset: const Offset(1, 1),
                      ),
                      Shadow(
                        blurRadius: 3,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(-1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
