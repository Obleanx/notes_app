import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:notes_app/DATA/models/notes_.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NotesLocalDataSource {
  Future<List<Note>> getNotes();
  Future<Note> getNoteById(String id);
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
}

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  // Storage key
  static const String _notesStorageKey = 'notes_data';

  // In-memory cache
  List<Note> _notes = [];
  bool _isInitialized = false;

  // Singleton pattern
  static final NotesLocalDataSourceImpl _instance =
      NotesLocalDataSourceImpl._internal();

  factory NotesLocalDataSourceImpl() {
    return _instance;
  }

  NotesLocalDataSourceImpl._internal();

  // Initialize data - load from SharedPreferences or create sample data if none exists
  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? notesJson = prefs.getString(_notesStorageKey);

      if (notesJson != null && notesJson.isNotEmpty) {
        // Parse stored notes
        final List<dynamic> decoded = jsonDecode(notesJson);
        _notes = decoded.map((item) => Note.fromJson(item)).toList();
      } else {
        // If no stored data, initialize with sample notes
        _initializeSampleNotes();
        // Save the sample notes to storage
        await _saveToStorage();
      }

      _isInitialized = true;
    } catch (e) {
      // Fallback to sample notes if there's any error
      _initializeSampleNotes();
      _isInitialized = true;
    }
  }

  // Save current notes to persistent storage
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList =
          _notes.map((note) => note.toJson()).toList();
      await prefs.setString(_notesStorageKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error saving notes: $e');
    }
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
    await _ensureInitialized();

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
    await _ensureInitialized();

    final note = _notes.firstWhere(
      (note) => note.id == id,
      orElse: () => throw Exception('Note not found'),
    );
    return note;
  }

  @override
  Future<void> addNote(Note note) async {
    await _ensureInitialized();

    // Generate ID if not provided
    final noteWithId =
        note.id.isEmpty ? note.copyWith(id: const Uuid().v4()) : note;

    _notes.add(noteWithId);

    // Save to persistent storage
    await _saveToStorage();
  }

  @override
  Future<void> updateNote(Note note) async {
    await _ensureInitialized();

    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      // Save to persistent storage
      await _saveToStorage();
    } else {
      throw Exception('Note not found');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    await _ensureInitialized();

    _notes.removeWhere((note) => note.id == id);

    // Save to persistent storage
    await _saveToStorage();
  }
}
