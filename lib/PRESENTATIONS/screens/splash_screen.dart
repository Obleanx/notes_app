import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/PRESENTATIONS/screens/home_screen.dart';
// ignore_for_file: deprecated_member_use

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _showShimmer = true;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Create scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );

    // Create opacity animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _animationController.forward();

    // Navigate to home screen after delay
    Timer(const Duration(milliseconds: 4200), () {
      setState(() {
        _showShimmer = false;
      });

      // Add slight delay before navigation
      Timer(const Duration(milliseconds: 1600), () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomePage(),
            transitionDuration: const Duration(milliseconds: 830),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using gradient background from FF2E4C to 1E2A78
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF2E4C), // Top color
              Color(0xFF1E2A78), // Bottom color
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2000),
                opacity: _showShimmer ? 1.0 : 0.0,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with shimmer effect
                        _buildShimmerLogo(),

                        const SizedBox(height: 36),

                        // App name with shimmer effect
                        _buildShimmerText(),

                        const SizedBox(height: 12),

                        // Tagline
                        Text(
                          'Capture your thoughts beautifully',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,

                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLogo() {
    // Bolder shimmer colors that blend with the background gradient
    return Shimmer.fromColors(
      baseColor: const Color(0xFFB82A48), // Darker red that blends with FF2E4C
      highlightColor: const Color(
        0xFF64A0FF,
      ), // Bright blue that complements 1E2A78
      period: const Duration(milliseconds: 3800),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.edit_note_rounded,
            size: 60,
            color: Color(0xFF1E2A78), // Using the bottom gradient color
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerText() {
    // Bolder shimmer colors that blend with the background gradient
    return Shimmer.fromColors(
      baseColor: const Color(0xFFB82A48), // Darker red that blends with FF2E4C
      highlightColor: const Color(
        0xFF64A0FF,
      ), // Bright blue that complements 1E2A78
      period: const Duration(milliseconds: 3800),
      child: Text(
        'My Notes',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 42,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: const Offset(0, 2),
              blurRadius: 4.0,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
