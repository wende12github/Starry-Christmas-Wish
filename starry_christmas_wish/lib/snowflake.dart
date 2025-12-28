import 'dart:math';

import 'package:flutter/material.dart';

class Snowflake {
  final Offset position;
  final double size;
  final double speed;
  final double swayAmplitude;

  Snowflake({
    required this.position,
    required this.size,
    required this.speed,
    required this.swayAmplitude,
  });

  static Snowflake generate(Random random, Size screenSize) {
    return Snowflake(
      position: Offset(random.nextDouble() * screenSize.width, -50),
      size: 10 + random.nextDouble() * 20,
      speed: 2 + random.nextDouble() * 4,
      swayAmplitude: 20 + random.nextDouble() * 40,
    );
  }
}
