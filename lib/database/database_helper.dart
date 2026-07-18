import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/task.dart';


class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;


  DatabaseHelper._init();


  Future<Database> get database async {

    if (_database != null) return _database!;

    _database = await _initDB('tasks.db');

    return _database!;
  }



  Future<Database> _initDB(String filePath) async {
  final dbPath = await getDatabasesPath();

  final path = join(dbPath, filePath);

  return await openDatabase(
    path,
    version: 2,
    onCreate: _createDB,

    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
          '''
          ALTER TABLE tasks
          ADD COLUMN isCompleted INTEGER NOT NULL DEFAULT 0
          ''',
        );
      }
    },
  );
}



    Future<void> _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      deadline TEXT NOT NULL,
      isCompleted INTEGER NOT NULL DEFAULT 0
    )
  ''');
}


  // Menambahkan task baru
  Future<int> insertTask(Task task) async {

    final db = await instance.database;

    return await db.insert(
      'tasks',
      task.toMap(),
    );

  }



  // Mengambil semua task
  Future<List<Task>> getTasks() async {

    final db = await instance.database;

    final result = await db.query(
      'tasks',
      orderBy: 'id DESC',
    );


    return result.map((json) {

      return Task.fromMap(json);

    }).toList();

  }



  // Mengubah task
  Future<int> updateTask(Task task) async {

    final db = await instance.database;

    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );

  }



  // Menghapus task
  Future<int> deleteTask(int id) async {

    final db = await instance.database;

    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

  }


}