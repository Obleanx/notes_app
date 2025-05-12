import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.black;
  static const Color accentColor = Color(0xFF4285F4);

  // Note card colors
  static const List<Color> noteColors = [
    Color(0xFFC2DCFD), // Light blue
    Color(0xFFFFD8F4), // Light pink
    Color(0xFFFBF6AA), // Light yellow
    Color(0xFFB0E9CA), // Light green
    Color(0xFFF1DBF5), // Light purple
    Color(0xFFD9E8FC), // Another light blue
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.white,
      colorScheme: ColorScheme.dark(
        primary: Colors.white,
        secondary: accentColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}
