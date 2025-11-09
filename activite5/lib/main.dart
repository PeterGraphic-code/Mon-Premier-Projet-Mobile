import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'screens/redacteur_interface.dart';
import 'services/database_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation pour Linux/Desktop
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await DatabaseManager.instance.init();
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Rédacteurs',
      theme: ThemeData(primarySwatch: Colors.pink, useMaterial3: true),
      home: const RedacteurInterface(),
    );
  }
}
