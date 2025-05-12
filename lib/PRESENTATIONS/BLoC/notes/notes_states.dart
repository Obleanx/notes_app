import 'package:equatable/equatable.dart';
import 'package:notes_app/DATA/models/notes_.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;
  final List<Note> filteredNotes; // Notes after search or category filtering
  final String searchQuery;
  final DateTime? selectedDate;
  final String selectedCategory;

  const NotesLoaded({
    required this.notes,
    required this.filteredNotes,
    this.searchQuery = '',
    this.selectedDate,
    this.selectedCategory = 'All',
  });

  @override
  List<Object> get props => [
    notes,
    filteredNotes,
    searchQuery,
    selectedCategory,
    if (selectedDate != null) selectedDate as Object,
  ];

  NotesLoaded copyWith({
    List<Note>? notes,
    List<Note>? filteredNotes,
    String? searchQuery,
    DateTime? selectedDate,
    String? selectedCategory,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object> get props => [message];
}
