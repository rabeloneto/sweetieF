import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'sweetie.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE lojas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            localizacao TEXT,
            imagem TEXT,
            telefone TEXT,
            latitude REAL,
            longitude REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE produtos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            lojaId INTEGER,
            nome TEXT,
            preco REAL,
            descricao TEXT,
            imagens TEXT,
            FOREIGN KEY (lojaId) REFERENCES lojas(id)
          )
        ''');
      },
    );
  }
}
