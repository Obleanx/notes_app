import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/CORE/themes/app_theme.dart';
import 'package:notes_app/SERVICES/dependency_container.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/theme/theme.dart';
import 'package:notes_app/PRESENTATIONS/screens/splash_screen.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_bloc.dart';
import 'package:notes_app/SERVICES/dependency_container.dart' as di;
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_event.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/filters/filter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize your dependency injection
  await initializeDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotesBloc>(
          create: (_) => di.sl<NotesBloc>()..add(LoadNotes()),
        ),
        BlocProvider<FilterBloc>(create: (_) => di.sl<FilterBloc>()),
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()..add(LoadTheme())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Notes App',
            debugShowCheckedModeBanner: false,
            themeMode: themeState.themeMode,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            home: const SplashScreen(),
            // Apply Montserrat font to the entire app because the suggested font is only available in paid version.
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  textTheme: GoogleFonts.montserratTextTheme(
                    Theme.of(context).textTheme,
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
