import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:notes_app/DATA/models/notes_.dart';

abstract class NotesLocalDataSource {
  Future<List<Note>> getNotes();
  Future<Note> getNoteById(String id);
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
}

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  // In-memory storage for demo purposes
  // In a real app, you would use a database like SQLite, Hive, etc.
  List<Note> _notes = [];

  // Singleton pattern
  static final NotesLocalDataSourceImpl _instance =
      NotesLocalDataSourceImpl._internal();

  factory NotesLocalDataSourceImpl() {
    return _instance;
  }

  NotesLocalDataSourceImpl._internal() {
    // Initialize with some sample notes
    _initializeSampleNotes();
  }

  void _initializeSampleNotes() {
    final now = DateTime.now();
    _notes = [
      Note(
        id: const Uuid().v4(),
        title: 'Homework',
        content:
            '1. Milk\n2. Eggs\n3. Bread\n4. Butter\n5. Cheese\n6. Apples\n7. Bananas\n8. Chicken',
        createdAt: now.subtract(const Duration(days: 2)),
        modifiedAt: now.subtract(const Duration(days: 2)),
        isPinned: true,
        category: 'Shopping',
      ),
      Note(
        id: const Uuid().v4(),
        title: 'Afternoon Classes',
        content:
            '- Discuss project timeline\n- Review team performance\n- Assign new tasks\n- Plan for next sprint\n- Address client feedback\n- Update documentation\n- Set up next meeting',
        createdAt: now.subtract(const Duration(days: 1)),
        modifiedAt: now.subtract(const Duration(days: 1)),
        isPinned: false,
        category: 'Important',
      ),
      Note(
        id: const Uuid().v4(),
        title: 'In the late evening',
        content:
            '1. The Alchemist\n2. Atomic Habits\n3. Sapiens\n4. The Psychology of Money\n5. Deep Work\n6. Thinking, Fast and Slow\n7. The Four Agreements\n8. Man\'s Search for Meaning',
        createdAt: now.subtract(const Duration(hours: 12)),
        modifiedAt: now.subtract(const Duration(hours: 12)),
        isPinned: false,
        category: 'To-do Lists',
      ),
      Note(
        id: const Uuid().v4(),
        title: 'To-Do List',
        content:
            '1. Mobile note-taking app\n2. Personal finance tracker\n3. Habit tracker\n4. Social media scheduler\n5. Recipe manager\n6. Workout tracker\n7. Language learning app\n8. Book summary app',
        createdAt: now.subtract(const Duration(hours: 6)),
        modifiedAt: now.subtract(const Duration(hours: 6)),
        isPinned: true,
        category: 'Lecture Notes',
      ),
      Note(
        id: const Uuid().v4(),
        title: 'Campus Tour Notes',
        content:
            'Main Building - Historical architecture, houses admin offices\n'
            'Science Complex - New labs on 3rd floor, robotics demo was impressive\n'
            'Student Union - Food court open until 11pm, study spaces available 24/7\n'
            'Library - 5 floors, quiet study area on top floor, group rooms need reservation\n'
            'Recreation Center - Free for students, pool hours 6am-10pm\n'
            'Dormitories - Maple Hall newest with private bathrooms\n'
            'Remember to follow up about scholarship deadlines at financial aid office',
        createdAt: now.subtract(const Duration(days: 3)),
        modifiedAt: now.subtract(const Duration(days: 3)),
        isPinned: false,
        category: 'Important',
      ),

      Note(
        id: const Uuid().v4(),
        title: 'Roller Coaster Day',
        content:
            'Cedar Point Trip Planning:\n'
            '- Fast passes worth it! Saved hours of waiting\n'
            '- Top Thrill Dragster: 120mph, 17-second ride but AMAZING\n'
            '- Millennium Force: Best overall experience, smooth ride\n'
            '- Maverick: Most intense, multiple launches\n'
            '- Steel Vengeance: Longest wait (90 min) but best wooden coaster\n'
            '- Pack sunscreen and water bottle next time\n'
            '- Food expensive in park, eat breakfast before arriving',
        createdAt: now.subtract(const Duration(days: 5)),
        modifiedAt: now.subtract(const Duration(days: 4, hours: 12)),
        isPinned: true,
        category: 'To-do Lists',
      ),
    ];
  }

  @override
  Future<List<Note>> getNotes() async {
    // Sort by pinned first, then by modified date
    _notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.modifiedAt.compareTo(a.modifiedAt);
    });
    return _notes;
  }

  @override
  Future<Note> getNoteById(String id) async {
    final note = _notes.firstWhere(
      (note) => note.id == id,
      orElse: () => throw Exception('Note not found'),
    );
    return note;
  }

  @override
  Future<void> addNote(Note note) async {
    // Generate ID if not provided
    final noteWithId =
        note.id.isEmpty ? note.copyWith(id: const Uuid().v4()) : note;

    _notes.add(noteWithId);
  }

  @override
  Future<void> updateNote(Note note) async {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
    } else {
      throw Exception('Note not found');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
  }
}
