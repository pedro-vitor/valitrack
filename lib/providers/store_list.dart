import 'package:flutter/material.dart';
import 'package:valitrack/model/store.dart';
import 'package:valitrack/util/store_table/store_table.dart';

class StoreList with ChangeNotifier {
  Map<int, Store> _items = {};

  int get itemsCount => _items.length;

// devolver uma lista apenas dos valores.
  List<Store> get items => _items.values.toList();

  // carregar lojas
  Future<void> loadProducts() async {
    final datasList = await StoreTable.getAllStores();
    _items = {
      for (var item in datasList)
        item['id']: Store(
          id: item['id'],
          name: item['name'],
          quantityRegisteredProducts: item['quantityRegisteredProducts'] ?? 0,
          quantityProductsToExpire: item['quantityProductsToExpire'] ?? 0,
          quantityExpiredProducts: item['quantityExpiredProducts'] ?? 0,
        )
    };
    notifyListeners();
  }

// Adicionar uma nova loja a lista.
  void addStore(Store store) {
    _items.putIfAbsent(store.id, () => store);
    StoreTable.insert({
      'name': store.name,
      'quantityRegisteredProducts': store.quantityRegisteredProducts,
      'quantityProductsToExpire': store.quantityProductsToExpire,
      'quantityExpiredProducts': store.quantityExpiredProducts,
    });
    notifyListeners();
  }

// deletar uma loja.
  void delete(int id) {
    _items.remove(id);
    StoreTable.delete(id);
    notifyListeners();
  }

  void incrementQuantityProduct(int storeId) {
    if (!_items.containsKey(storeId)) return;
    _items[storeId]?.incrementRegisteredProducts();
    StoreTable.incrementRegisteredProduct(storeId);
    notifyListeners();
  }
}
