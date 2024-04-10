import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Future<Database> _initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "shule.db");

    var db = await openDatabase(path);
    return db;
  }

  Future<List<Map<String, dynamic>>> loadData() async {
    var db = await _initDb();
    var result = await db.query('ИСИП23_11_2');
    return result;
  }
}
