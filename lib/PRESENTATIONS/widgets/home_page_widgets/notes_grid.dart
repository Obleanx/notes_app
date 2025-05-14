import 'package:flutter/material.dart';
import 'package:notes_app/DATA/models/notes_.dart';
import 'package:notes_app/CORE/themes/app_theme.dart';
import 'package:notes_app/PRESENTATIONS/widgets/note_card.dart';
import 'package:notes_app/PRESENTATIONS/screens/notes_details_screen.dart';

class NotesGrid extends StatelessWidget {
  final List<Note> notes;

  const NotesGrid({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
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
          final colorIndex = index % AppTheme.noteColors.length;

          return NoteCard(
            note: note,
            color: AppTheme.noteColors[colorIndex],
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
