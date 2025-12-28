import 'package:flutter/material.dart';
import 'package:starry_christmas_wish/star.dart';

class StarWidget extends StatefulWidget {
  final Star star;
  const StarWidget({required this.star, super.key, required Size screenSize});

  @override
  State<StarWidget> createState() => _StarWidgetState();
}

class _StarWidgetState extends State<StarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.star.twinkleDuration,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ageMilliseconds = DateTime.now().difference(widget.star.birthTime).inMilliseconds;
    final age = ageMilliseconds < 0 ? 0 : ageMilliseconds;
    final maxAge = 4000; // 4 seconds
    double fadeOpacity = 1.0;

    if (widget.star.isBurst && age > maxAge - 1000) {
        fadeOpacity = ((maxAge - age) / 1000).clamp(0.0, 1.0);
    }

    final Size screenSize = MediaQuery.of(context).size;

    return Positioned(
      left: widget.star.position.dx.clamp(0.0, screenSize.width - 50),
      top: widget.star.position.dy.clamp(0.0, screenSize.height - 50),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Opacity(
            opacity:
                widget.star.opacity *
                (0.5 + _controller.value * 0.5) *
                fadeOpacity,
            child: Icon(
              Icons.star,
              color: widget.star.isBurst ? Colors.yellow : Colors.white,
              size: widget.star.size * 8,
              shadows: [
                Shadow(
                  color: Colors.yellow.withValues(
                    alpha: widget.star.isBurst ? 0.9 : 0.6,
                  ),
                  blurRadius: widget.star.isBurst ? 20 : 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
