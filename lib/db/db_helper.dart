import 'package:notes_app/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? db;
  static int version = 1;
  static String tableName = "tasks";

  static Future<void> initDb() async {
    if (db != null) {
      return;
    }
    try {
      String path = await getDatabasesPath() + 'tasks.db';
      db = await openDatabase(
        path,
        version: version,
        onCreate: (db, version) {
          print("Creating a new one");
          return db.execute(
            "CREATE TABLE $tableName ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "title STRING , note TEXT , date STRING, "
            "startTime STRING , endTime STRING,"
            "remind INTEFER , repeat String,"
            "color Integer,"
            "isCompleted INTEGER )",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(TaskModel? task) async {
    print('insert Fuction called');
    return await db?.insert(tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await db!.query(tableName);
  }

  static delete(TaskModel taskModel) async {
    return await db!
        .delete(tableName, where: "id=?", whereArgs: [taskModel.id]);
  }

  static update(int id) async {
    return await db!.rawUpdate('''
    UPDATE tasks 
    SET isCompleted = ?
    WHERE id=?
 ''', [1, id]);
  }
}
