import 'package:notes_app/DATA/models/notes_.dart';
import 'package:notes_app/REPOSITORY/notes_repository.dart';
import 'package:notes_app/DATA/data_sources/notes_local_data_source.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;

  NotesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Note>> getNotes() async {
    return await localDataSource.getNotes();
  }

  @override
  Future<Note> getNoteById(String id) async {
    return await localDataSource.getNoteById(id);
  }

  @override
  Future<void> addNote(Note note) async {
    await localDataSource.addNote(note);
  }

  @override
  Future<void> updateNote(Note note) async {
    await localDataSource.updateNote(note);
  }

  @override
  Future<void> deleteNote(String id) async {
    await localDataSource.deleteNote(id);
  }
}
