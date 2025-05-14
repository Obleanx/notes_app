import 'package:flutter/material.dart';
import 'package:notes_app/DATA/models/notes_.dart';
import 'package:notes_app/CORE/themes/app_theme.dart';
import 'package:notes_app/PRESENTATIONS/widgets/note_card.dart';
import 'package:notes_app/PRESENTATIONS/screens/notes_details_screen.dart';

class NotesGrid extends StatelessWidget {
  final List<Note> notes;

  const NotesGrid({super.key, required this.notes});

  @override
  // Updated NoteGrid widget to use theme-aware colors
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeColors = AppTheme.getNoteColors(isDarkMode);

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 80.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final note = notes[index];
          // You can use either approach:
          // 1. Keep using the original noteColors list (which will always be light mode colors)
          // final colorIndex = index % AppTheme.noteColors.length;
          // final color = AppTheme.noteColors[colorIndex];

          // 2. Use the theme-aware colors that change with light/dark mode
          final colorIndex = index % themeColors.length;
          final color = themeColors[colorIndex];

          return NoteCard(
            note: note,
            color: color,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => NewNotesPage(note: note, isNewNote: false),
                ),
              );
            },
            onTogglePin: () {
              // You'll need to pass the bloc or a callback here
              // or handle this differently
            },
          );
        }, childCount: notes.length),
      ),
    );
  }
}
