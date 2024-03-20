import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DatabaseManager {
  Database? db;
  String tableName = 'hhh';

  DatabaseManager() {
    createDatabase();
  }

  Future<void> createDatabase() async {
    tableName = tableName.replaceAll('-', '_');

    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'shule.db');
    db = await openDatabase(path, version: 1, onCreate: (db, version) => createTable(db, version));
  }

  Future<void> createTable(Database db, int version) async {
    await db.execute('CREATE TABLE $tableName (id INTEGER PRIMARY KEY, id_weekday INTEGER, lesson_id INTEGER, FOREIGN KEY (id_weekday) REFERENCES id_weekday(name), FOREIGN KEY (lesson_id) REFERENCES lessons(lessons_id))');
    await db.execute('INSERT INTO $tableName (id, lesson_id) VALUES (1, 1)');
  }

  Future<List<Map<String, dynamic>>> loadDatabase() async {
    if (db == null) {
      await createDatabase();
    }
    var res = await db!.query("sqlite_master", where: "type = ? AND name = ?", whereArgs: ['table', tableName]);
    if (res.isNotEmpty) {
      final data = await db!.query(tableName);
      print('Данные из таблицы: $data');
      return data;
    } else {
      print('Таблица не существует');
      return [];
    }
  }
}