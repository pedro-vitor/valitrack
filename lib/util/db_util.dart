import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'names_tables_db.dart';

class DbUtil {
  static const String _nameDb = 'valitrack.db';

  // Abrindo criando o banco de dados
  static Future<sql.Database> dataBase() async {
    // pega o path da base de dados
    final dbPath = await sql.getDatabasesPath();

    // retorna a conexão com o banco
    return sql.openDatabase(
      // passando o caminho do db e no final o nome do banco
      path.join(dbPath, _nameDb),
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE ${NamesTablesDb.store.value} (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(30) NOT NULL, quantityRegisteredProducts INT NOT NULL, quantityProductsToExpire INT NOT NULL, quantityExpiredProducts INT NOT NULL, createdAt TEXT NOT NULL);',
        );

        await db.execute(
          'CREATE TABLE ${NamesTablesDb.product.value} ( id INTEGER PRIMARY KEY AUTOINCREMENT, store_id INTEGER NOT NULL, description VARCHAR(100) NOT NULL, codeBar VARCHAR(13) NOT NULL, quantity INT NOT NULL, image VARCHAR(200) NOT NULL, expireDate TEXT NOT NULL, createdAt TEXT NOT NULL, status TEXT NOT NULL DEFAULT \'ACTIVE\', quantityRemoved INT, removedAt TEXT, FOREIGN KEY (store_id) REFERENCES store(id) ON DELETE CASCADE );',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.dataBase();

    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.dataBase();

    return db.query(table);
  }
}
