
import 'package:valitrack/enums/product_status.dart';

class Product {
  int? id;
  final String description;
  final String codeBar;
  final int quantity;
  final String? image;
  final DateTime dueDate;
  final int storeId;
  final DateTime createdAt;
// Dados para controle de retirarda do produto
  String status = ProductStatus.active.value;
  int? quantityRemoved;
  DateTime? removedAt;

  Product({
    required this.id,
    required this.description,
    required this.codeBar,
    required this.quantity,
    this.image,
    required this.dueDate,
    required this.storeId,
    required this.createdAt,
  });

  Product.noId({
    required this.description,
    required this.codeBar,
    required this.quantity,
    this.image,
    required this.dueDate,
    required this.storeId,
    required this.createdAt,
  });
}
