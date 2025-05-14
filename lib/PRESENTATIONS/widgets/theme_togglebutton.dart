import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/theme/theme.dart';

class ThemeToggleButton extends StatelessWidget {
  final double size;

  const ThemeToggleButton({Key? key, this.size = 24.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDarkMode = state.themeMode == ThemeMode.dark;
        return IconButton(
          icon: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            size: size,
          ),
          onPressed: () {
            context.read<ThemeBloc>().add(ToggleTheme());
          },
          tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        );
      },
    );
  }
}
