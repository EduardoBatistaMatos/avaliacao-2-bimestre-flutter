import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/evento.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _db;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'eventos.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE eventos (
            id    INTEGER PRIMARY KEY AUTOINCREMENT,
            nome  TEXT NOT NULL,
            local TEXT NOT NULL,
            data  TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> inserir(Evento evento) async {
    final db = await database;
    return db.insert('eventos', evento.toMap());
  }

  Future<List<Evento>> listarTodos() async {
    final db = await database;
    final rows = await db.query('eventos', orderBy: 'id ASC');
    return rows.map(Evento.fromMap).toList();
  }

  Future<int> atualizar(Evento evento) async {
    final db = await database;
    return db.update(
      'eventos',
      evento.toMap(),
      where: 'id = ?',
      whereArgs: [evento.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await database;
    return db.delete('eventos', where: 'id = ?', whereArgs: [id]);
  }
}
