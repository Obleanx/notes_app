import 'package:flutter/material.dart';
// lib/core/theme/app_theme.dart

class AppTheme {
  // Light mode colors
  static const Color lightPrimaryColor = Colors.white;
  static const Color lightScaffoldColor = Colors.white;
  static const Color lightTextColor = Colors.black87;
  static const Color lightIconColor = Colors.black54;

  // Dark mode colors
  static const Color darkPrimaryColor = Color(0xFF303030);
  static const Color darkScaffoldColor = Color(0xFF121212);
  static const Color darkTextColor = Colors.white;
  static const Color darkIconColor = Colors.white70;

  static const Color accentColor = Color(0xFF4285F4);

  // Light mode note card colors
  static const List<Color> lightNoteColors = [
    Color(0xFFC2DCFD), // Light blue
    Color(0xFFFFD8F4), // Light pink
    Color(0xFFFBF6AA), // Light yellow
    Color(0xFFB0E9CA), // Light green
    Color(0xFFF1DBF5), // Light purple
    Color(0xFFD9E8FC), // Another light blue
  ];

  // Dark mode note card colors (slightly darker versions)
  static const List<Color> darkNoteColors = [
    Color(0xFF2C5D9E), // Dark blue
    Color(0xFF8C4A75), // Dark pink
    Color(0xFF7A7849), // Dark yellow
    Color(0xFF3E7A59), // Dark green
    Color(0xFF6B4D75), // Dark purple
    Color(0xFF3D5A8A), // Another dark blue
  ];

  // Get note colors based on theme mode
  static List<Color> getNoteColors(bool isDarkMode) {
    return isDarkMode ? darkNoteColors : lightNoteColors;
  }

  // Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimaryColor,
      scaffoldBackgroundColor: lightScaffoldColor,
      colorScheme: ColorScheme.light(
        primary: accentColor,
        secondary: accentColor,
      ),
      iconTheme: IconThemeData(color: lightIconColor),
      appBarTheme: AppBarTheme(
        backgroundColor: lightPrimaryColor,
        foregroundColor: lightTextColor,
        elevation: 0,
        iconTheme: IconThemeData(color: lightIconColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightPrimaryColor,
        selectedItemColor: accentColor,
        unselectedItemColor: lightIconColor,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: lightTextColor),
        bodyMedium: TextStyle(color: lightTextColor),
        titleLarge: TextStyle(color: lightTextColor),
        titleMedium: TextStyle(color: lightTextColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: lightPrimaryColor,
        shadowColor: Colors.black12,
        elevation: 2,
      ),
    );
  }

  // Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      scaffoldBackgroundColor: darkScaffoldColor,
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
      ),
      iconTheme: IconThemeData(color: darkIconColor),
      appBarTheme: AppBarTheme(
        backgroundColor: darkPrimaryColor,
        foregroundColor: darkTextColor,
        elevation: 0,
        iconTheme: IconThemeData(color: darkIconColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkPrimaryColor,
        selectedItemColor: accentColor,
        unselectedItemColor: darkIconColor,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: darkTextColor),
        bodyMedium: TextStyle(color: darkTextColor),
        titleLarge: TextStyle(color: darkTextColor),
        titleMedium: TextStyle(color: darkTextColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: darkPrimaryColor,
        shadowColor: Colors.black54,
        elevation: 2,
      ),
    );
  }
}
