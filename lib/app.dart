import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/theme_cubit.dart';
import 'package:notes_app/PRESENTATIONS/screens/home_screen.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_bloc.dart';
import 'package:notes_app/SERVICES/dependency_container.dart' as di;
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_event.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/filters/filter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotesBloc>(
          create: (_) => di.sl<NotesBloc>()..add(LoadNotes()),
        ),
        BlocProvider<FilterBloc>(create: (_) => di.sl<FilterBloc>()),
        BlocProvider(create: (_) => ThemeCubit()), // New Theme Cubit
      ],
      child: MaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light, // Default theme mode
        home: const HomePage(),
      ),
    );
  }
}
