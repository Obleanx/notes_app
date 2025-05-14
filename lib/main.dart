import 'package:notes_app/app.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/SERVICES/dependency_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.init();

  runApp(MyApp());
}
