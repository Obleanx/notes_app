import 'notes_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/DATA/models/notes_.dart';
import 'package:notes_app/REPOSITORY/notes_repository.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_states.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository notesRepository;

  NotesBloc({required this.notesRepository}) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<ToggleNotePin>(_onToggleNotePin);
    on<SearchNotes>(_onSearchNotes);
  }

  // Function to filter notes based on search, date, and category
  List<Note> _getFilteredNotes({
    required List<Note> allNotes,
    String searchQuery = '',
    DateTime? selectedDate,
    String selectedCategory = 'All',
  }) {
    return allNotes.where((note) {
      // Filter by search query
      final matchesSearch =
          searchQuery.isEmpty ||
          note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(searchQuery.toLowerCase());

      // Filter by selected date
      final matchesDate =
          selectedDate == null ||
          (note.createdAt.year == selectedDate.year &&
              note.createdAt.month == selectedDate.month &&
              note.createdAt.day == selectedDate.day);

      // Filter by category
      final matchesCategory =
          selectedCategory == 'All' ||
          note.category.toLowerCase() == selectedCategory.toLowerCase();

      return matchesSearch && matchesDate && matchesCategory;
    }).toList();
  }

  // Load all notes
  void _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      // Initial data for example purposes
      final List<Note> notes = await notesRepository.getNotes();
      emit(NotesLoaded(notes: notes, filteredNotes: notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  // Add a new note
  void _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    if (state is NotesLoaded) {
      final currentState = state as NotesLoaded;
      try {
        await notesRepository.addNote(event.note);

        final updatedNotes = await notesRepository.getNotes();

        emit(
          currentState.copyWith(
            notes: updatedNotes,
            filteredNotes: _getFilteredNotes(
              allNotes: updatedNotes,
              searchQuery: currentState.searchQuery,
              selectedDate: currentState.selectedDate,
              selectedCategory: currentState.selectedCategory,
            ),
          ),
        );
      } catch (e) {
        emit(NotesError(e.toString()));
      }
    }
  }

  // Update an existing note
  void _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    if (state is NotesLoaded) {
      final currentState = state as NotesLoaded;
      try {
        await notesRepository.updateNote(event.note);

        final updatedNotes = await notesRepository.getNotes();

        emit(
          currentState.copyWith(
            notes: updatedNotes,
            filteredNotes: _getFilteredNotes(
              allNotes: updatedNotes,
              searchQuery: currentState.searchQuery,
              selectedDate: currentState.selectedDate,
              selectedCategory: currentState.selectedCategory,
            ),
          ),
        );
      } catch (e) {
        emit(NotesError(e.toString()));
      }
    }
  }

  // Delete a note
  void _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    if (state is NotesLoaded) {
      final currentState = state as NotesLoaded;
      try {
        await notesRepository.deleteNote(event.noteId);

        final updatedNotes = await notesRepository.getNotes();

        emit(
          currentState.copyWith(
            notes: updatedNotes,
            filteredNotes: _getFilteredNotes(
              allNotes: updatedNotes,
              searchQuery: currentState.searchQuery,
              selectedDate: currentState.selectedDate,
              selectedCategory: currentState.selectedCategory,
            ),
          ),
        );
      } catch (e) {
        emit(NotesError(e.toString()));
      }
    }
  }

  // Toggle pin status
  void _onToggleNotePin(ToggleNotePin event, Emitter<NotesState> emit) async {
    if (state is NotesLoaded) {
      final currentState = state as NotesLoaded;
      try {
        // Find the note
        final noteIndex = currentState.notes.indexWhere(
          (note) => note.id == event.noteId,
        );
        if (noteIndex != -1) {
          final note = currentState.notes[noteIndex];
          final updatedNote = note.copyWith(isPinned: !note.isPinned);

          await notesRepository.updateNote(updatedNote);

          final updatedNotes = await notesRepository.getNotes();

          emit(
            currentState.copyWith(
              notes: updatedNotes,
              filteredNotes: _getFilteredNotes(
                allNotes: updatedNotes,
                searchQuery: currentState.searchQuery,
                selectedDate: currentState.selectedDate,
                selectedCategory: currentState.selectedCategory,
              ),
            ),
          );
        }
      } catch (e) {
        emit(NotesError(e.toString()));
      }
    }
  }

  // Search notes
  void _onSearchNotes(SearchNotes event, Emitter<NotesState> emit) {
    if (state is NotesLoaded) {
      final currentState = state as NotesLoaded;

      final filteredNotes = _getFilteredNotes(
        allNotes: currentState.notes,
        searchQuery: event.query,
        selectedDate: currentState.selectedDate,
        selectedCategory: currentState.selectedCategory,
      );

      emit(
        currentState.copyWith(
          searchQuery: event.query,
          filteredNotes: filteredNotes,
        ),
      );
    }
  }
}
