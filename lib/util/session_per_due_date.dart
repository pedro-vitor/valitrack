import 'dart:collection';

import '../model/product.dart';

Map<DateTime, List<Product>> createSessionPerDueDate(List<Product> products) {
  Map<DateTime, List<Product>> sessions = {};

  for (var product in products) {
    final productDueDateMonth = product.dueDate.month;
    final productDueDateYear = product.dueDate.year;

    final keyFromSessions = DateTime(productDueDateYear, productDueDateMonth);

    if (!sessions.containsKey(keyFromSessions)) {
      sessions[keyFromSessions] = [];
    }

    sessions[keyFromSessions]!.add(product);
  }

  sessions.forEach((key, productList) {
    productList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }); //orderna a lista de produtos em ordem cronologica

  final sessionsInOrder = sessions.entries.toList()
    ..sort(
      (a, b) => a.key.compareTo(b.key),
    ); //Orderna as chaves com as listas em ordem cronologica.

  return LinkedHashMap.fromEntries(sessionsInOrder);
}
