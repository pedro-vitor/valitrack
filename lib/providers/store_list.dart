import 'package:flutter/material.dart';
import 'package:valitrack/model/store.dart';
import 'package:valitrack/util/enum/quantity_operation.dart';
import 'package:valitrack/util/store_table/store_table.dart';

class StoreList with ChangeNotifier {
  Map<int, Store> _items = {};

  int get itemsCount => _items.length;

  // devolver uma lista apenas dos valores.
  List<Store> get items => _items.values.toList();

  Store? getById(int id) {
    if(_items.containsKey(id)) {
      return _items[id]!;
    }
    return null;
  }

  // carregar lojas
  Future<void> loadProducts() async {
    _items = {};
    final datasList = await StoreTable.getAllStores();
    _items = {
      for (var item in datasList)
        item['id']: Store.withCreatedAt(
          id: item['id'],
          name: item['name'],
          quantityRegisteredProducts: item['quantityRegisteredProducts'] ?? 0,
          quantityProductsToExpire: item['quantityProductsToExpire'] ?? 0,
          quantityExpiredProducts: item['quantityExpiredProducts'] ?? 0,
          createdAt: DateTime.parse(item['createdAt']),
        ),
    };
    notifyListeners();
  }

  // Adicionar uma nova loja a lista.
  void addStore(Store store) {
    if (store.id != null) {
      _items.putIfAbsent(store.id!, () => store);
    }
    StoreTable.insert({
      'name': store.name,
      'quantityRegisteredProducts': store.quantityRegisteredProducts,
      'quantityProductsToExpire': store.quantityProductsToExpire,
      'quantityExpiredProducts': store.quantityExpiredProducts,
      'createdAt': store.createdAt.toIso8601String(),
    }).then((_) => loadProducts());
    notifyListeners();
  }

  void updateStore(Store store) {
    if (!_items.containsKey(store.id!)) return;

    _items.update(store.id!, (_) => store);

    StoreTable.update(store.id!, {
      'name': store.name,
    }).then((_) => loadProducts());
    notifyListeners();
  }

  // deletar uma loja.
  void delete(int id) {
    _items.remove(id);
    StoreTable.delete(id);
    notifyListeners();
  }

// incrementa e decrementa a quantidade de produtos registrados, e atualiza o banco de dados com a nova quantidade.
  void incrementQuantityProduct(int storeId) {
    if (!_items.containsKey(storeId)) return;
    _items[storeId]?.incrementRegisteredProducts();
    StoreTable.changeQuantityRegisteredProducts(_items[storeId]!.id!, QuantityOperation.increment);
    notifyListeners();
  }

  void decrementQuantityProduct(int storeId) {
    if (!_items.containsKey(storeId)) return;
    _items[storeId]?.decrementRegisteredProducts();
    StoreTable.changeQuantityRegisteredProducts(_items[storeId]!.id!, QuantityOperation.decrement);
    notifyListeners();
  }

// incrementa e decrementa a quantidade de produtos para vencer, e atualiza o banco de dados com a nova quantidade.
  void incrementQuantityProductsToExpire(int storeId) {
    if (!_items.containsKey(storeId)) return;
    _items[storeId]?.incrementProductsToExpire();
    StoreTable.changeQuantityProductsToExpire(_items[storeId]!.id!, QuantityOperation.increment);
    notifyListeners();
  }

  void decrementQuantityProductsToExpire(int storeId) {
    if (!_items.containsKey(storeId)) return;
    _items[storeId]?.decrementProductsToExpire();
    StoreTable.changeQuantityProductsToExpire(_items[storeId]!.id!, QuantityOperation.decrement);
    notifyListeners();
  }
}
