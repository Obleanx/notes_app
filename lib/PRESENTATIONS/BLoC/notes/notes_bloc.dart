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

    // Load notes automatically when the bloc is created
    add(LoadNotes());
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
      final List<Note> notes = await notesRepository.getNotes();
      emit(NotesLoaded(notes: notes, filteredNotes: notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  // Add a new note
  void _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    try {
      // First, update local state immediately for instant UI feedback
      if (state is NotesLoaded) {
        final currentState = state as NotesLoaded;

        // Create a temporary list with the new note
        final List<Note> updatedNotes = List.from(currentState.notes)
          ..add(event.note);

        // Sort the updated notes
        updatedNotes.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.modifiedAt.compareTo(a.modifiedAt);
        });

        // Update UI immediately
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

      // Then persist to storage
      await notesRepository.addNote(event.note);

      // Refresh from storage to ensure consistency
      final updatedNotes = await notesRepository.getNotes();

      if (state is NotesLoaded) {
        final currentState = state as NotesLoaded;
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
      // If there was an error, reload notes to ensure consistent state
      add(LoadNotes());
    }
  }

  // Update an existing note
  void _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    if (state is NotesLoaded) {
      final currentState = state as NotesLoaded;
      try {
        // Update UI immediately for better UX
        final updatedLocalNotes =
            currentState.notes.map((note) {
              if (note.id == event.note.id) {
                return event.note;
              }
              return note;
            }).toList();

        emit(
          currentState.copyWith(
            notes: updatedLocalNotes,
            filteredNotes: _getFilteredNotes(
              allNotes: updatedLocalNotes,
              searchQuery: currentState.searchQuery,
              selectedDate: currentState.selectedDate,
              selectedCategory: currentState.selectedCategory,
            ),
          ),
        );

        // Then persist to storage
        await notesRepository.updateNote(event.note);

        // Refresh from storage to ensure consistency
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
        // If there was an error, reload notes to ensure consistent state
        add(LoadNotes());
      }
    }
  }

  // Delete a note
  void _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    if (state is NotesLoaded) {
      final currentState = state as NotesLoaded;
      try {
        // Update UI immediately for better UX
        final updatedLocalNotes =
            currentState.notes
                .where((note) => note.id != event.noteId)
                .toList();

        emit(
          currentState.copyWith(
            notes: updatedLocalNotes,
            filteredNotes: _getFilteredNotes(
              allNotes: updatedLocalNotes,
              searchQuery: currentState.searchQuery,
              selectedDate: currentState.selectedDate,
              selectedCategory: currentState.selectedCategory,
            ),
          ),
        );

        // Then persist to storage
        await notesRepository.deleteNote(event.noteId);

        // Refresh from storage to ensure consistency
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
        // If there was an error, reload notes to ensure consistent state
        add(LoadNotes());
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

          // Update local state immediately
          final updatedLocalNotes = List<Note>.from(currentState.notes);
          updatedLocalNotes[noteIndex] = updatedNote;

          // Sort notes with pinned ones first
          updatedLocalNotes.sort((a, b) {
            if (a.isPinned && !b.isPinned) return -1;
            if (!a.isPinned && b.isPinned) return 1;
            return b.modifiedAt.compareTo(a.modifiedAt);
          });

          emit(
            currentState.copyWith(
              notes: updatedLocalNotes,
              filteredNotes: _getFilteredNotes(
                allNotes: updatedLocalNotes,
                searchQuery: currentState.searchQuery,
                selectedDate: currentState.selectedDate,
                selectedCategory: currentState.selectedCategory,
              ),
            ),
          );

          // Update in persistence
          await notesRepository.updateNote(updatedNote);

          // Refresh from storage to ensure consistency
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
        // If there was an error, reload notes to ensure consistent state
        add(LoadNotes());
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
