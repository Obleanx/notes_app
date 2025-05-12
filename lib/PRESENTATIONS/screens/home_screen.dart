import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/DATA/models/notes_.dart';
import 'package:notes_app/CORE/themes/app_theme.dart';
import 'package:notes_app/PRESENTATIONS/widgets/date_chip.dart';
import 'package:notes_app/PRESENTATIONS/widgets/note_card.dart';
import 'package:notes_app/PRESENTATIONS/widgets/dragable_fab.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_bloc.dart';
import 'package:notes_app/PRESENTATIONS/widgets/category_chip.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_event.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_states.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/filters/filter_bloc.dart';
import 'package:notes_app/PRESENTATIONS/screens/notes_details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'All',
    'Important',
    'Lecture Notes',
    'To-do Lists',
    'Shopping',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<NotesBloc>().add(SearchNotes(_searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            slivers: [
              // Date and more options
              SliverToBoxAdapter(child: _buildDateHeader()),

              // Search bar
              SliverToBoxAdapter(child: _buildSearchBar()),

              // Date scrolling list
              SliverToBoxAdapter(child: _buildDateList()),

              // Categories list
              SliverToBoxAdapter(child: _buildCategoriesList()),

              // Notes grid
              BlocBuilder<NotesBloc, NotesState>(
                builder: (context, state) {
                  if (state is NotesInitial || state is NotesLoading) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is NotesLoaded) {
                    return _buildNotesGrid(state.filteredNotes);
                  } else if (state is NotesError) {
                    return SliverFillRemaining(
                      child: Center(child: Text('Error: ${state.message}')),
                    );
                  }
                  return const SliverFillRemaining(
                    child: Center(child: Text('Something went wrong')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: DraggableFab(
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to create note page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailPage(isNewNote: true),
              ),
            );
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('d');
    final DateFormat monthFormatter = DateFormat('MMMM');

    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: '${formatter.format(now)}${_getDaySuffix(now.day)} ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: monthFormatter.format(now),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show more options menu
              _showMoreOptions(context);
            },
          ),
        ],
      ),
    );
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }

    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text('Sort notes'),
                onTap: () {
                  Navigator.pop(context);
                  // Add sorting logic here
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete all notes'),
                onTap: () {
                  Navigator.pop(context);
                  // Add delete all notes logic here
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for notes',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDateList() {
    final now = DateTime.now();
    final List<DateTime> dates = List.generate(
      14,
      (index) => DateTime(now.year, now.month, now.day - 7 + index),
    );

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, filterState) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected =
                  filterState.selectedDate != null &&
                  filterState.selectedDate!.year == date.year &&
                  filterState.selectedDate!.month == date.month &&
                  filterState.selectedDate!.day == date.day;

              return DateChip(
                date: date,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    context.read<FilterBloc>().add(ClearSelectedDate());
                  } else {
                    context.read<FilterBloc>().add(SelectDate(date));
                  }

                  // Also update the notes
                  if (context.read<NotesBloc>().state is NotesLoaded) {
                    final notesState =
                        context.read<NotesBloc>().state as NotesLoaded;
                    final filteredNotes =
                        isSelected
                            ? notesState.notes
                            : notesState.notes.where((note) {
                              return note.createdAt.year == date.year &&
                                  note.createdAt.month == date.month &&
                                  note.createdAt.day == date.day;
                            }).toList();

                    context.read<NotesBloc>().emit(
                      notesState.copyWith(
                        filteredNotes: filteredNotes,
                        selectedDate: isSelected ? null : date,
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, filterState) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = filterState.selectedCategory == category;

              return CategoryChip(
                title: category,
                isSelected: isSelected,
                onTap: () {
                  context.read<FilterBloc>().add(SelectCategory(category));

                  // Also update the notes
                  if (context.read<NotesBloc>().state is NotesLoaded) {
                    final notesState =
                        context.read<NotesBloc>().state as NotesLoaded;
                    final filteredNotes =
                        category == 'All'
                            ? notesState.notes
                            : notesState.notes
                                .where((note) => note.category == category)
                                .toList();

                    context.read<NotesBloc>().emit(
                      notesState.copyWith(
                        filteredNotes: filteredNotes,
                        selectedCategory: category,
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotesGrid(List<Note> notes) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        bottom: 80.0,
      ), // Add bottom padding for FAB
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final note = notes[index];
          final colorIndex = index % AppTheme.noteColors.length;

          return NoteCard(
            note: note,
            color: AppTheme.noteColors[colorIndex],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => NoteDetailPage(note: note, isNewNote: false),
                ),
              );
            },
            onTogglePin: () {
              context.read<NotesBloc>().add(ToggleNotePin(note.id));
            },
          );
        }, childCount: notes.length),
      ),
    );
  }
}
