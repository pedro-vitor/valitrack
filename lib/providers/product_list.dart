import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valitrack/model/product.dart';
import 'package:valitrack/providers/store_list.dart';
import 'package:valitrack/util/product_table/product_table.dart';
import 'package:valitrack/util/session_per_due_date.dart';

class ProductList with ChangeNotifier {
  final BuildContext context;
  final StoreList providerStore;

  ProductList({required this.context})
    : providerStore = context.read<StoreList>();

  /// ^^^^^^^^^^^^
  /// O contexto nao pode ser usado no inicialização, então coloco a atribuição
  /// do 'providerStore' no corpo do contrutor para que depois de receber o context
  /// inicializar o 'providerStore';

  Future<List<Product>> _getProductByStore(int storeId) async {
    return await ProductTable.getProductByStoreId(storeId).then(
      (list) => list
          .map(
            (item) => Product(
              id: item['id'].toString(),
              description: item['description'] as String,
              codeBar: item['codeBar'] as String,
              quantity: item['quantity'] as int,
              image: File(item['image'] as String),
              dueDate: DateTime.parse(item['expireDate'] as String),
              storeId: item['store_id'] as int,
            ),
          )
          .toList(),
    );
  }

  Future<Map<DateTime, List<Product>>> getSessionsPerDueDate(
    int storeId,
  ) async {
    final products = await _getProductByStore(storeId);
    return createSessionPerDueDate(products);
  }

  void saveProductOnDb(Map<String, Object> formDatas) {
    _addNewProductOnDB(formDatas);
    notifyListeners();
  }

  void _addNewProductOnDB(Map<String, Object> formDatas) async {
    await ProductTable.insert(formDatas);
  }
}
