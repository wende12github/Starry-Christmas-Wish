import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starry_christmas_wish/snowflake.dart';
import 'package:starry_christmas_wish/snowflake_widget.dart';
import 'package:starry_christmas_wish/star.dart';
import 'package:starry_christmas_wish/star_widget.dart';

void main() {
  runApp(const StarryChristmasWish());
}

class StarryChristmasWish extends StatelessWidget {
  const StarryChristmasWish({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ChristmasScreen(),
    );
  }
}
