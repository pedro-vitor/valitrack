import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({
    super.key,
    required this.onSubmit,
  });

  final void Function(String, String, int, DateTime) onSubmit;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final dateMax = DateTime.now().year + 2;
  final descriptionProduct = TextEditingController();
  final codeBarProduct = TextEditingController();
  final quantity = TextEditingController();
  DateTime? dueDateProduct;

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(dateMax),
    ).then((selectedDueDate) {
      if (selectedDueDate == null) {
        return;
      }
      setState(() {
        dueDateProduct = selectedDueDate;
      });
    });
  }

  void _submitForm() {
    if (descriptionProduct.text.isEmpty ||
        codeBarProduct.text.isEmpty ||
        dueDateProduct == null) {
      return;
    }
    widget.onSubmit(
      descriptionProduct.text,
      codeBarProduct.text,
      int.parse(quantity.text),
      dueDateProduct!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          left: 10,
          top: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onSubmitted: (_) {},
                controller: descriptionProduct,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Descrição do Produto',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 125, 125, 125),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                onSubmitted: (_) {},
                controller: codeBarProduct,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Código de Barras',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 125, 125, 125),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
              ),
              TextField(
                onSubmitted: (_) {},
                controller: quantity,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Quantidade',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 125, 125, 125),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data Selecionada: ${dueDateProduct == null ? '' : DateFormat('dd/MM/yy').format(dueDateProduct!)}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showDatePicker(),
                    child: const Text('Selecione a Data'),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => _submitForm(),
                    style: const ButtonStyle(
                      elevation: WidgetStatePropertyAll(2),
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
