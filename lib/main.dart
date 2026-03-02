import 'package:flasher/app.dart';
import 'package:flasher/repository/repositories.dart';
import 'package:flutter/material.dart';

void main() {
  // Initialize repository
  final repositories = Repositories.init();

  runApp(
    RepositoriesProvider(repositories: repositories, child: const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: const Color(0xFF0D5C63)),
      home: const FlasherApp(),
    );
  }
}
