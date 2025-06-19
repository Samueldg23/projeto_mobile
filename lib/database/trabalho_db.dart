import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/trabalho.dart';

class TrabalhoDb {
  static Database? _db;

  static Future<Database> _getDatabase() async {
  if (_db != null) return _db!;

  final path = join(await getDatabasesPath(), 'trabalhos.db');

  await deleteDatabase(path);

  _db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE trabalhos (
          id INTEGER PRIMARY KEY,
          titulo TEXT,
          descricao TEXT,
          dataEntrega TEXT,
          disciplina TEXT,
          status INTEGER,
          universitarioId INTEGER
        )
      ''');
    },
  );

  return _db!;
}

  static Future<void> inserir(TrabalhoAcademico trabalho) async {
    final db = await _getDatabase();
    await db.insert('trabalhos', trabalho.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<TrabalhoAcademico>> listarPorUniversitario(int universitarioId) async {
    final db = await _getDatabase();
    final maps = await db.query(
      'trabalhos',
      where: 'universitarioId = ?',
      whereArgs: [universitarioId],
    );
    return List.generate(
      maps.length,
      (i) => TrabalhoAcademico.fromMap(maps[i]),
    );
  }

  static Future<void> limpar() async {
    final db = await _getDatabase();
    await db.delete('trabalhos');
  }
}
