import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/DATA/models/notes_.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;

  const NoteCard({
    Key? key,
    required this.note,
    required this.color,
    required this.onTap,
    required this.onTogglePin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format date to display
    final formattedDate = DateFormat('MMM d, yyyy').format(note.modifiedAt);

    // Get first few lines of content
    final contentPreview = _getContentPreview(note.content);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and pin
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: onTogglePin,
                  child: Icon(
                    note.isPinned ? Icons.push_pin : Icons.push_pin,
                    size: 16,
                    color: note.isPinned ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Date
            Text(
              formattedDate,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 8),

            // Content preview
            Expanded(
              child: Text(
                contentPreview,
                style: const TextStyle(fontSize: 14, height: 1.5),
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getContentPreview(String content) {
    // Show only first 8 lines
    final lines = content.split('\n').take(8).toList();
    return lines.join('\n');
  }
}
