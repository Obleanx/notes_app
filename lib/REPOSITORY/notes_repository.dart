import 'package:notes_app/DATA/models/notes_.dart';

abstract class NotesRepository {
  Future<List<Note>> getNotes();
  Future<Note> getNoteById(String id);
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
}
