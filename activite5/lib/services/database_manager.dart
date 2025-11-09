// lib/services/database_manager.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/redacteur.dart';

class DatabaseManager {
  // singleton
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  Database? _db;

  // méthode publique pour initialiser explicitement si besoin
  Future<void> init() async {
    if (_db != null) return;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'redacteurs.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE redacteurs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            prenom TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = _db!;
    final res = await db.query('redacteurs', orderBy: 'id DESC');
    return res.map((m) => Redacteur.fromMap(m)).toList();
  }

  Future<int> insertRedacteur(Redacteur r) async {
    final db = _db!;
    return await db.insert('redacteurs', r.toMap());
  }

  Future<int> updateRedacteur(Redacteur r) async {
    final db = _db!;
    return await db.update(
      'redacteurs',
      r.toMap(),
      where: 'id = ?',
      whereArgs: [r.id],
    );
  }

  Future<int> deleteRedacteur(int id) async {
    final db = _db!;
    return await db.delete('redacteurs', where: 'id = ?', whereArgs: [id]);
  }
}
