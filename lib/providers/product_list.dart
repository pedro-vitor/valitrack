import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valitrack/model/product.dart';
import 'package:valitrack/providers/store_list.dart';
import 'package:valitrack/util/due_date_calculator.dart';
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
              id: item['id'],
              description: item['description'] as String,
              codeBar: item['codeBar'] as String,
              quantity: item['quantity'] as int,
              image: item['image'] as String,
              dueDate: DateTime.parse(item['expireDate'] as String),
              storeId: item['store_id'] as int,
              createdAt: DateTime.parse(item['createdAt'] as String),
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

  void saveProductOnDb(Map<String, Object> formDatas, int storeId) {
    _addNewProductOnDB(formDatas);
    providerStore.incrementQuantityProduct(storeId);
    int diffMonth = dueDateCalculator(DateTime.parse(formDatas['expireDate'] as String));

    // "0" -> produto vence esse mês, "1" -> produto vence no próximo mês, "-1" -> produto já venceu.
    if(diffMonth >= 0 && diffMonth <= 1) {
      providerStore.incrementQuantityProductsToExpire(storeId);
    }
    notifyListeners();
  }

  void _addNewProductOnDB(Map<String, Object> formDatas) async {
    await ProductTable.insert(formDatas);
  }

  void updateProductOnDb(Map<String, Object> formDatas, int productId) async {
    await ProductTable.update(productId, formDatas);
    notifyListeners();
  }

  void deleteProductOnDb(int productId, DateTime dueDateProduct, int storeId) async {
    await ProductTable.delete(productId);
    _verifyIfProductToExpire(dueDateProduct, storeId);
    notifyListeners();
  }

  void _verifyIfProductToExpire(DateTime dueDate, int storeId) async {
    int diffMonth = dueDateCalculator(dueDate);
    if(diffMonth < 0) {
      //TODO: chamar decrementar os produtos já vencidos (quantityExpiredProducts)
    }

    if(diffMonth >= 0 && diffMonth <= 1) {
      providerStore.decrementQuantityProductsToExpire(storeId);
    }
    providerStore.decrementQuantityProduct(storeId);
    notifyListeners();
  }
}
