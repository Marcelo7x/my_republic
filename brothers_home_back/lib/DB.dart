import 'package:postgres/postgres.dart';

class DB {
  static final DB _db = DB._internal();
  DB._internal();

  static DB get instance => _db;

  static PostgreSQLConnection? _database;

  Future<PostgreSQLConnection> get database async {
    if (_database == null) {
      print("iniciando db..");
      _database = PostgreSQLConnection("localhost", 5432, "brothers_home",
          username: "postgres", password: "kelum");

      await _database!.open();
      print("db conectado");
    }
    

    return _database!;
  }
}
