import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/theme/theme.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/theme_cubit.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('d');
    final DateFormat monthFormatter = DateFormat('MMMM');

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: '${formatter.format(now)}${_getDaySuffix(now.day)} ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: monthFormatter.format(now),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
    );
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // Bottom sheet with theme toggle

  // Example implementation in the bottom sheet
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.sort),
                  title: const Text('Sort notes'),
                  onTap: () {
                    Navigator.pop(context);
                    // Add sorting logic here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Delete all notes'),
                  onTap: () {
                    Navigator.pop(context);
                    // Add delete all notes logic here
                  },
                ),
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    final isDarkMode = state.themeMode == ThemeMode.dark;
                    return ListTile(
                      leading: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      ),
                      title: Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),
                      onTap: () {
                        context.read<ThemeBloc>().add(ToggleTheme());
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}
