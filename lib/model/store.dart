import 'package:flutter/material.dart';

class Store with ChangeNotifier {
  final int id;
  String name;
  int quantityRegisteredProducts;
  int quantityProductsToExpire;
  int quantityExpiredProducts;

  Store({
    required this.id,
    required this.name,
    required this.quantityRegisteredProducts,
    required this.quantityProductsToExpire,
    required this.quantityExpiredProducts,
  });

  void incrementRegisteredProducts() {
    quantityRegisteredProducts = quantityRegisteredProducts + 1;
    notifyListeners();
  }
  /**
   * ": id = const Uuid().v4()"
   * é executado antes do construtor, atribuindo o UUID ao Id.
  */

  /// Cria dois gets para devolver o quanto:
  ///  1- de produtos cadastrados.
  ///  2- de produtos proximo ao vencimento (este mês + próx. mês).
}
