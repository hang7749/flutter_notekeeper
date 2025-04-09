import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../modal/notes.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:universal_io/io.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {

    if (kIsWeb) {
      // Initialize the Web Database
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Initialize the FFI database for desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Get the database path
    String path;
    if (kIsWeb) {
      path = 'notes.db'; // No file system on web
    } else {
      var databasesPath = await getDatabasesPath();
      path = join(databasesPath, 'notes.db');
    }
  
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        color TEXT NOT NULL,
        dateTime TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertNote(Notes note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Notes>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) => Notes.fromMap(maps[i]));
  }

  Future<int> updateNote(Notes note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Future<void> deleteAllNotes() async {
  //   final db = await database;
  //   await db.delete('notes');
  // }

  // Future<void> deleteNoteById(int id) async {
  //   final db = await database;
  //   await db.delete(
  //     'notes',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

}