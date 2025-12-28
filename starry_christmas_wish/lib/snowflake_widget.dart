import 'dart:math';

import 'package:flutter/material.dart';
import 'package:starry_christmas_wish/snowflake.dart';

class SnowflakeWidget extends StatefulWidget {
  final Snowflake snowflake;
  final double screenHeight;
  final VoidCallback onComplete;

  const SnowflakeWidget({
    required this.snowflake,
    required this.screenHeight,
    required this.onComplete,
    super.key,
  });

  @override
  State<SnowflakeWidget> createState() => _SnowflakeWidgetState();
}

class _SnowflakeWidgetState extends State<SnowflakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fallAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            duration: Duration(seconds: (widget.snowflake.speed + 4).toInt()),
            vsync: this,
          )
          ..addListener(() {
            if (_controller.isCompleted) widget.onComplete();
          })
          ..forward();

    _fallAnimation = Tween<double>(
      begin: widget.snowflake.position.dy,
      end: widget.screenHeight + 50,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final sway =
            sin(_controller.value * 8) * widget.snowflake.swayAmplitude;
        return Positioned(
          left: widget.snowflake.position.dx + sway,
          top: _fallAnimation.value,
          child: Icon(
            Icons.ac_unit,
            color: Colors.white.withValues(alpha: .85),
            size: widget.snowflake.size,
          ),
        );
      },
    );
  }
}
