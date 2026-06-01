import 'package:uuid/uuid.dart';

class Product {
  final String id;
  final String description;
  final String codeBar;
  final int quantity;
  final String? image;
  final DateTime dueDate;
  final int storeId;

  Product({
    required this.id,
    required this.description,
    required this.codeBar,
    required this.quantity,
    this.image,
    required this.dueDate,
    required this.storeId,
  });

  Product.noId({
    required this.description,
    required this.codeBar,
    required this.quantity,
    this.image,
    required this.dueDate,
    required this.storeId,
  }) : id = const Uuid().v4();
}
