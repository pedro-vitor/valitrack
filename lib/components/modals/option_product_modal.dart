import 'package:flutter/material.dart';
import 'package:valitrack/model/product.dart';

class OptionProductModal extends StatelessWidget {
  final Product product;
  final void Function(Product) onDelete;

  const OptionProductModal({
    super.key,
    required this.product,
    required this.onDelete,
  });

  void delete(BuildContext context, Product product) {
    onDelete(product);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Escolha uma ação',
        textAlign: TextAlign.center,
      ),
      content: const Text(
        'O que você deseja fazer com este item?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center, // Centraliza os botões
      actions: [
        // Ação 1: Editar
        TextButton.icon(
          icon: const Icon(Icons.edit, color: Colors.blue),
          label: const Text('Editar'),
          onPressed: () {
            Navigator.pop(context); // Fecha o modal
          },
        ),
        // Ação 3: Excluir
        TextButton.icon(
          icon: const Icon(Icons.delete, color: Colors.red),
          label: const Text('Excluir'),
          onPressed: () => delete(context, product),
        ),
      ],
    );
  }
}
