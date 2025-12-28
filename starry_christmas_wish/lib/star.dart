import 'dart:math';

import 'package:flutter/material.dart';

class Star {
  final Offset position;
  final double size;
  final double opacity;
  final Duration twinkleDuration;
  final bool isBurst;
  final DateTime birthTime;

  Star({
    required this.position,
    required this.size,
    required this.opacity,
    required this.twinkleDuration,
    this.isBurst = false,
    required this.birthTime,
  });

  static Star generate(Random random) {
    return Star(
      position: Offset(random.nextDouble() * 1000, random.nextDouble() * 2000),
      size: 2 + random.nextDouble() * 4,
      opacity: 0.5 + random.nextDouble() * 0.5,
      twinkleDuration: Duration(milliseconds: 2000 + random.nextInt(3000)),
      birthTime: DateTime.now(),
    );
  }

  static Star generateBurst(Random random, Size screenSize, Offset tapPos) {
    return Star(
      position: Offset(
        tapPos.dx + random.nextDouble() * 300 - 150,
        tapPos.dy + random.nextDouble() * 300 - 150,
      ),
      size: 6 + random.nextDouble() * 10,
      opacity: 1.0,
      twinkleDuration: const Duration(milliseconds: 800),
      isBurst: true,
      birthTime: DateTime.now(),
    );
  }
}