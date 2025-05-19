import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/PRESENTATIONS/widgets/dragable_fab.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_bloc.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_event.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_states.dart';
import 'package:notes_app/PRESENTATIONS/screens/notes_details_screen.dart';
import 'package:notes_app/PRESENTATIONS/widgets/home_page_widgets/date_list.dart';
import 'package:notes_app/PRESENTATIONS/widgets/home_page_widgets/notes_grid.dart';
import 'package:notes_app/PRESENTATIONS/widgets/home_page_widgets/search_bar.dart';
import 'package:notes_app/PRESENTATIONS/widgets/home_page_widgets/date_header.dart';
import 'package:notes_app/PRESENTATIONS/widgets/home_page_widgets/categories_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    final now = DateTime.now();
    final dates = List.generate(
      14,
      (index) => DateTime(now.year, now.month, now.day - 7 + index),
    );

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomScrollView(
                slivers: [
                  // Date and more options
                  const SliverToBoxAdapter(child: DateHeader()),

                  // Search bar
                  SliverToBoxAdapter(
                    child: HomeScreenSearchBar(
                      controller: _searchController,
                      onChanged: (value) => _onSearchChanged(),
                    ),
                  ),

                  // Date scrolling list
                  SliverToBoxAdapter(child: DateList(dates: dates)),

                  // Add space between date list and categories
                  const SliverToBoxAdapter(child: SizedBox(height: 22.0)),

                  // Categories list
                  SliverToBoxAdapter(
                    child: CategoriesList(categories: _categories),
                  ),

                  // Notes grid
                  BlocBuilder<NotesBloc, NotesState>(
                    builder: (context, state) {
                      if (state is NotesInitial || state is NotesLoading) {
                        return const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is NotesLoaded) {
                        return NotesGrid(notes: state.filteredNotes);
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

          // Add DraggableFab here as part of the Stack this is where that grey screen issue came from
          DraggableFab(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewNotesPage(isNewNote: true),
                  ),
                );
              },
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
