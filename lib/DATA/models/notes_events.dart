import 'package:equatable/equatable.dart';
import 'package:notes_app/DATA/models/notes_.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final Note note;

  const AddNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNote extends NotesEvent {
  final Note note;

  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NotesEvent {
  final String noteId;

  const DeleteNote(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class ToggleNotePin extends NotesEvent {
  final String noteId;

  const ToggleNotePin(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class SearchNotes extends NotesEvent {
  final String query;

  const SearchNotes(this.query);

  @override
  List<Object> get props => [query];
}

// New event for filtering by category
class FilterByCategory extends NotesEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object> get props => [category];
}

// New event for sorting notes
class SortNotes extends NotesEvent {
  final SortOption sortOption;

  const SortNotes(this.sortOption);

  @override
  List<Object> get props => [sortOption];
}

// Sort options enum
enum SortOption {
  dateCreatedNewest,
  dateCreatedOldest,
  alphabetical,
  reverseAlphabetical,
}
