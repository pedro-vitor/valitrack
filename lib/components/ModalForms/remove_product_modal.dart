import 'package:flutter/material.dart';
import 'package:valitrack/model/product.dart';

class RemoveProductModal extends StatefulWidget {
  final void Function(Product, int) onRemoveProduct;
  final Product product;
  const RemoveProductModal({
    super.key,
    required this.onRemoveProduct,
    required this.product,
  });

  @override
  State<RemoveProductModal> createState() => _RemoveProductModalState();
}

class _RemoveProductModalState extends State<RemoveProductModal> {
  final TextEditingController _quantityController = TextEditingController();
  String? _textError;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Deseja recolher este produto?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade a recolher',
                  border: OutlineInputBorder(),
                  errorText: _textError,
                ),
                onChanged: (_) {
                  if (_textError != null) setState(() => _textError = null);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // caso der erro na conversão, o valor de 'quantityRemoved' será -1, e a função irá retornar sem executar a lógica de recolhimento.
                      final quantityRemoved =
                          int.tryParse(_quantityController.text) ?? -1;
                      if (quantityRemoved < 0) {
                        setState(() => _textError = 'Informe um valor válido.');
                        return;
                      }
                      if(quantityRemoved > widget.product.quantity) {
                        setState(() => _textError = "Quantidade máxima para retirada é ${widget.product.quantity}");
                        return;
                      }
                      widget.onRemoveProduct(widget.product, quantityRemoved);
                      Navigator.pop(context);
                      // Lógica para recolher o produto
                    },
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                    label: const Text('Recolher'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Lógica para cancelar a ação
                    },
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
