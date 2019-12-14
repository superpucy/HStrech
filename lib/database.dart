import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }



  initDB() async {

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    var db = await openDatabase(path);
    db.execute("CREATE TABLE IF NOT EXISTS log (date text PRIMARY KEY)");
    return db;
  }




}