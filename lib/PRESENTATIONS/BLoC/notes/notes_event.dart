import 'package:equatable/equatable.dart';
import 'package:notes_app/DATA/models/notes_.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

// Event to load all notes
class LoadNotes extends NotesEvent {}

// Event to add a new note
class AddNote extends NotesEvent {
  final Note note;

  const AddNote(this.note);

  @override
  List<Object> get props => [note];
}

// Event to update an existing note
class UpdateNote extends NotesEvent {
  final Note note;

  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}

// Event to delete a note
class DeleteNote extends NotesEvent {
  final String noteId;

  const DeleteNote(this.noteId);

  @override
  List<Object> get props => [noteId];
}

// Event to toggle pin status
class ToggleNotePin extends NotesEvent {
  final String noteId;

  const ToggleNotePin(this.noteId);

  @override
  List<Object> get props => [noteId];
}

// Event to search notes
class SearchNotes extends NotesEvent {
  final String query;

  const SearchNotes(this.query);

  @override
  List<Object> get props => [query];
}
