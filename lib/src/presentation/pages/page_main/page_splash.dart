import 'package:flutter/material.dart';

/// {@category Presentation}
class PageSplash extends StatelessWidget {
  const PageSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match native splash background
      body: Center(
        child: Image.asset(
          'assets/icons/app_icon_splash_1.png', // Replace with your actual image path
          width: 150,
          height: 150,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
