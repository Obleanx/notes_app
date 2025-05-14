import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const themeKey = 'theme_mode'; // Fixed the syntax error here

  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(themeKey) ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newTheme =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await prefs.setBool(themeKey, newTheme == ThemeMode.dark);
    emit(newTheme);
  }
}
