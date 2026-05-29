import 'package:valitrack/model/store.dart';
import 'package:valitrack/util/db_util.dart';
import 'package:valitrack/util/names_tables_db.dart';

class StoreTable {
  static Future<void> insert(Map<String, Object> data) async {
    await DbUtil.insert(NamesTablesDb.store.value, data);
  }

  static Future<List<Map<String, dynamic>>> getAllStores() async {
    return await DbUtil.getData(NamesTablesDb.store.value);
  }

  static Future<List<Map<String, dynamic>>> getStoreById(int id) async {
    final db = await DbUtil.dataBase();

    return db.query(
      NamesTablesDb.store.value,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> update(int id, Map<String, Object> data) async {
    final db = await DbUtil.dataBase();

    await db.update(
      NamesTablesDb.store.value,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> delete(int id) async {
    final db = await DbUtil.dataBase();

    await db.delete(
      NamesTablesDb.store.value,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> incrementRegisteredProduct(Store store) async {
    final db = await DbUtil.dataBase();

    await db.rawUpdate(
      '''
      UPDATE ${NamesTablesDb.store.value}
      SET quantityRegisteredProducts = quantityRegisteredProducts + 1
      WHERE id = ?
      ''',
      [store.id],
    );
  }
}
