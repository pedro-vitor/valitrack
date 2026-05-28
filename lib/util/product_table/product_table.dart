import 'package:valitrack/util/db_util.dart';
import 'package:valitrack/util/names_tables_db.dart';

class ProductTable {
  static Future<void> insert(Map<String, Object> data) async {
    await DbUtil.insert(NamesTablesDb.product.value, data);
  }

  static Future<List<Map<String, dynamic>>> getProductByStoreId(
    int storeId,
  ) async {
    final db = await DbUtil.dataBase();
    return db.query(
      NamesTablesDb.product.value,
      where: 'store_id = ?',
      whereArgs: [storeId],
    );
  }

  static Future<void> update(int id, Map<String, Object> data) async {
    final db = await DbUtil.dataBase();

    await db.update(
      NamesTablesDb.product.value,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> delete(int id) async {
    final db = await DbUtil.dataBase();

    await db.delete(
      NamesTablesDb.product.value,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
