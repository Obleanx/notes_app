import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
// lib/core/theme/theme_bloc.dart

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class LoadTheme extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

// States
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String THEME_KEY = 'app_theme';

  ThemeBloc() : super(const ThemeState(ThemeMode.light)) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(THEME_KEY) ?? false;
      emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
    } catch (_) {
      emit(const ThemeState(ThemeMode.light));
    }
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final currentTheme = state.themeMode;
    final newTheme =
        currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(THEME_KEY, newTheme == ThemeMode.dark);
    } catch (_) {
      // Handle error if needed
    }

    emit(ThemeState(newTheme));
  }
}
