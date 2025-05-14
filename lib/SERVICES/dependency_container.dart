import 'package:get_it/get_it.dart';
import 'package:notes_app/REPOSITORY/notes_repository.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/theme/theme.dart';
import 'package:notes_app/REPOSITORY/notes_repository_impl.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/notes_bloc.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/filters/filter_bloc.dart';
import 'package:notes_app/DATA/data_sources/notes_local_data_source.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // BLoC / Cubit
  sl.registerFactory(() => NotesBloc(notesRepository: sl()));

  sl.registerFactory(() => FilterBloc());

  // Repositories
  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<NotesLocalDataSource>(
    () => NotesLocalDataSourceImpl(),
  );
}

final di = GetIt.instance;

Future<void> initializeDependencies() async {
  // Register the ThemeBloc as a singleton
  di.registerLazySingleton<ThemeBloc>(() => ThemeBloc()..add(LoadTheme()));

  // Register other dependencies as needed
  // ...
}
