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

class ChristmasScreen extends StatefulWidget {
  const ChristmasScreen({super.key});

  @override
  State<ChristmasScreen> createState() => _ChristmasScreenState();
}

class _ChristmasScreenState extends State<ChristmasScreen>
    with TickerProviderStateMixin {
  final Random _random = Random();
  final List<Star> _stars = [];
  final List<Snowflake> _snowflakes = [];
  bool _showSmile = false;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  Timer? _snowTimer;

  late Size _screenSize;

  @override
  void initState() {
    super.initState();

    // Initial background stars
    for (int i = 0; i < 80; i++) {
      _stars.add(Star.generate(_random));
    }

    // Bounce animation for Santas
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Periodic smile/punch
    Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      setState(() => _showSmile = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _showSmile = false);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;

    // Initial snowflakes
    for (int i = 0; i < 20; i++) {
      _snowflakes.add(Snowflake.generate(_random, _screenSize));
    }

    // Continuous snow
    _snowTimer ??= Timer.periodic(const Duration(milliseconds: 300), (_) {
        if (mounted) {
          setState(() {
            _snowflakes.add(Snowflake.generate(_random, _screenSize));
          });
        }
      });

    // Cleanup old burst stars
    Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final now = DateTime.now();
      setState(() {
        _stars.removeWhere(
          (star) =>
              star.isBurst && now.difference(star.birthTime).inSeconds > 4,
        );
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      final tapPos = details.localPosition;
      for (int i = 0; i < 15; i++) {
        _stars.add(Star.generateBurst(_random, _screenSize, tapPos));
      }
      for (int i = 0; i < 25; i++) {
        _snowflakes.add(Snowflake.generate(_random, _screenSize));
      }
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _snowTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTapDown: _onTapDown,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
            ),
          ),
          child: Stack(
            children: [
              // Background twinkling stars
              ..._stars.map(
                (star) => StarWidget(star: star, screenSize: _screenSize),
              ),

              // Snowflakes
              ..._snowflakes.map(
                (snow) => SnowflakeWidget(
                  snowflake: snow,
                  screenHeight: _screenSize.height,
                  onComplete: () {
                    if (mounted) setState(() => _snowflakes.remove(snow));
                  },
                ),
              ),

              // Santa at TOP CENTER
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (_, __) {
                      return Transform.translate(
                        offset: Offset(0, _bounceAnimation.value),
                        child: AnimatedScale(
                          scale: _showSmile ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.elasticOut,
                          child: Image.asset(
                            'assets/santa_star.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Main centered content (ONLY name and texts - no side Santas)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Merry Christmas,',
                      style: GoogleFonts.dancingScript(
                        fontSize: 42,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.yellow.withValues(alpha: .8),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Big glowing name only
                    Text(
                      'Tsion Nadew!',
                      style: GoogleFonts.dancingScript(
                        fontSize: 80,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.yellow, blurRadius: 30),
                          Shadow(
                            color: Colors.yellow.withValues(alpha: .8),
                            blurRadius: 60,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Wish message
                    Text(
                      'Wishing you a magical holiday\nfull of joy and wonder 🎄✨',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dancingScript(
                        fontSize: 34,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Santa at BOTTOM RIGHT
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (_, __) {
                      return Transform.translate(
                        offset: Offset(0, _bounceAnimation.value),
                        child: AnimatedScale(
                          scale: _showSmile ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.elasticOut,
                          child: Image.asset(
                            'assets/santa.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
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
