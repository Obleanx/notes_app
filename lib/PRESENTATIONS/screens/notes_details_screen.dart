import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/DATA/models/notes_.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_bloc.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_event.dart';
import 'package:notes_app/PRESENTATIONS/screens/category_bottom_sheet.dart';

class NewNotesPage extends StatefulWidget {
  final Note? note;
  final bool isNewNote;

  const NewNotesPage({Key? key, this.note, required this.isNewNote})
    : super(key: key);

  @override
  State<NewNotesPage> createState() => _NewNotesPageState();
}

class _NewNotesPageState extends State<NewNotesPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _category;
  late bool _isPinned;
  final List<String> _categories = [
    'All',
    'Important',
    'Lecture Notes',
    'To-do Lists',
    'Shopping',
    "Sunday school",
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _category = widget.note?.category ?? 'All';
    _isPinned = widget.note?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CategoryBottomSheet(
            categories: _categories,
            selectedCategory: _category,
            onCategorySelected: (category) {
              setState(() {
                _category = category;
              });
            },
            onSave: _saveNote,
            onDelete: widget.isNewNote ? null : _deleteNote,
            onAddCategory: (newCategory) {
              if (newCategory.isNotEmpty &&
                  !_categories.contains(newCategory)) {
                setState(() {
                  _categories.add(newCategory);
                  _category = newCategory;
                });
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate =
        widget.isNewNote
            ? 'New note'
            : 'Edited ${DateFormat('MMM d, yyyy').format(now)}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Export icon
          IconButton(
            icon: const Icon(Icons.folder_outlined, color: Colors.black),
            onPressed: () {
              // Export functionality will be implemented here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export as PDF feature coming soon'),
                ),
              );
            },
          ),
          // Pin button
          IconButton(
            icon: Icon(
              _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: _isPinned ? Colors.black : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPinned = !_isPinned;
              });
            },
          ),
          // Share button - replaced Save text with icon
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.black),
            onPressed: () {
              // Share functionality will be implemented here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Text(
              formattedDate,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),

            const SizedBox(height: 16),

            // Title
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),

            // Content
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 16, height: 1.5),
                decoration: const InputDecoration(
                  hintText: 'Start typing...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        mini: true,
        child: const Icon(Icons.category, size: 20),
        onPressed: _showCategoryBottomSheet,
      ),
    );
  }

  void _saveNote() {
    if (_titleController.text.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    final now = DateTime.now();

    if (widget.isNewNote) {
      // Create new note
      final newNote = Note(
        id: const Uuid().v4(),
        title: _titleController.text,
        content: _contentController.text,
        createdAt: now,
        modifiedAt: now,
        isPinned: _isPinned,
        category: _category,
      );

      context.read<NotesBloc>().add(AddNote(newNote));
    } else {
      // Update existing note
      final updatedNote = widget.note!.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        modifiedAt: now,
        isPinned: _isPinned,
        category: _category,
      );

      context.read<NotesBloc>().add(UpdateNote(updatedNote));
    }

    Navigator.pop(context);
  }

  void _deleteNote() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Note'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  if (widget.note != null) {
                    context.read<NotesBloc>().add(DeleteNote(widget.note!.id));
                  }
                  Navigator.pop(context); // Return to notes list
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
