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

  // Text style with Avenir font
  static TextStyle _avenirTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: 'Avenir',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
      ),
      fontFamily: 'Avenir', // Default font for the theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: _avenirTextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800, // Avenir Heavy
          color: Colors.black,
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        displayLarge: _avenirTextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800, // Avenir Heavy
          color: Colors.black,
        ),
        displayMedium: _avenirTextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800, // Avenir Heavy
          color: Colors.black,
        ),
        displaySmall: _avenirTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800, // Avenir Heavy
          color: Colors.black,
        ),
        headlineMedium: _avenirTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700, // Avenir Bold
          color: Colors.black,
        ),
        bodyLarge: _avenirTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400, // Avenir Regular
          color: Colors.black,
        ),
        bodyMedium: _avenirTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400, // Avenir Regular
          color: Colors.black,
        ),
        labelLarge: _avenirTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500, // Avenir Medium
          color: Colors.black,
        ),
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
      fontFamily: 'Avenir', // Default font for the theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: _avenirTextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800, // Avenir Heavy
          color: Colors.white,
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: TextTheme(
        displayLarge: _avenirTextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800, // Avenir Heavy
          color: Colors.white,
        ),
        displayMedium: _avenirTextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800, // Avenir Heavy
          color: Colors.white,
        ),
        displaySmall: _avenirTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800, // Avenir Heavy
          color: Colors.white,
        ),
        headlineMedium: _avenirTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700, // Avenir Bold
          color: Colors.white,
        ),
        bodyLarge: _avenirTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400, // Avenir Regular
          color: Colors.white,
        ),
        bodyMedium: _avenirTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400, // Avenir Regular
          color: Colors.white,
        ),
        labelLarge: _avenirTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500, // Avenir Medium
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}
