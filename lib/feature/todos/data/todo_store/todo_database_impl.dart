import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/feature/todos/domain/todo_store/todo_database.dart';

import '../../domain/entity/todo.dart';

class TodoDatabaseImpl extends TodoDatabase {
  static final TodoDatabase instance = TodoDatabaseImpl._();
  static Database? _db;

  TodoDatabaseImpl._();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'todos.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE todos(
            id INTEGER PRIMARY KEY,
            title TEXT,
            completed INTEGER,
            is_synced INTEGER
          )
        ''');
      },
    );
  }

  @override
  Future<void> insert(Todo todo) async {
    final db = await database;
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Todo>> getAll() async {
    final db = await database;
    final res = await db.query('todos', orderBy: 'id DESC');
    return res.map(Todo.fromMap).toList();
  }

  @override
  Future<void> update(Todo todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Todo>> unsynced() async {
    final db = await database;
    final res = await db.query('todos', where: 'is_synced = 0');
    return res.map(Todo.fromMap).toList();
  }
}
