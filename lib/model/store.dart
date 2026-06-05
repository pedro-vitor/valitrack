import 'package:flutter/material.dart';

class Store with ChangeNotifier {
  int? id;
  String name;
  int quantityRegisteredProducts;
  int quantityProductsToExpire;
  int quantityExpiredProducts;
  DateTime createdAt = DateTime.now();

  Store({
    this.id,
    required this.name,
    required this.quantityRegisteredProducts,
    required this.quantityProductsToExpire,
    required this.quantityExpiredProducts,
  });

  Store.withCreatedAt({
    this.id,
    required this.name,
    required this.quantityRegisteredProducts,
    required this.quantityProductsToExpire,
    required this.quantityExpiredProducts,
    required this.createdAt,
  });

  void incrementRegisteredProducts() {
    quantityRegisteredProducts = quantityRegisteredProducts + 1;
    notifyListeners();
  }

  void decrementRegisteredProducts() {
    quantityRegisteredProducts = quantityRegisteredProducts - 1;
    notifyListeners();
  }

  void incrementProductsToExpire() {
    quantityProductsToExpire = quantityProductsToExpire + 1;
    notifyListeners();
  }

  void decrementProductsToExpire() {
    quantityProductsToExpire = quantityProductsToExpire - 1;
    notifyListeners();
  }
}
