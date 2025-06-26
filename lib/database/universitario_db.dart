import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/universitario.dart';

class UniversitarioDb {
  static Database? _db;

  static Future<Database> _getDatabase() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'universitarios.db');

    await deleteDatabase(path);
    
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE universitarios (
            id INTEGER PRIMARY KEY,
            nome TEXT,
            email TEXT,
            senha TEXT
          )
        ''');
      },
    );

    return _db!;
  }

  static Future<void> resetarBanco() async {
    final path = join(await getDatabasesPath(), 'universitarios.db');
    await deleteDatabase(path);
    _db = null;
  }

  static Future<void> inserir(Universitario universitario) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'universitario',
        jsonEncode(universitario.toJson()),
      );
    } else {
      final db = await _getDatabase();
      await db.insert(
        'universitarios',
        universitario.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<Universitario?> buscar() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('universitario');
      if (json != null) {
        return Universitario.fromJson(jsonDecode(json));
      }
    } else {
      final db = await _getDatabase();
      final result = await db.query('universitarios', limit: 1);
      if (result.isNotEmpty) {
        return Universitario.fromMap(result.first);
      }
    }
    return null;
  }

  static Future<void> limpar() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('universitario');
    } else {
      final db = await _getDatabase();
      await db.delete('universitarios');
    }
  }
}
