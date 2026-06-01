import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:valitrack/components/form_components/input_image_with_preview.dart';
import 'package:valitrack/components/mainAppbar/main_appbar.dart';
import 'package:valitrack/providers/product_list.dart';
import 'package:valitrack/screens/barcode_reader_screen.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formData = <String, Object>{};
  final _formKey = GlobalKey<FormState>();
  final dateMax = DateTime.now().year + 2;
  bool _isLoading = false;
  DateTime? _selectedDate;

  void _selectImage(File selectedImage) {
    setState(() {
      _formData['image'] = selectedImage.path;
    });
  }

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
        _formData['expireDate'] = selectedDueDate.toIso8601String();
        _selectedDate = selectedDueDate;
      });
    });
  }

  void showBarcodeScanner() async {
    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeReaderScreen()),
    );
    if (barcode != null) {
      setState(() => _formData['codeBar'] = barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String storeId =
        ModalRoute.of(context)?.settings.arguments.toString() ?? '';
    final provider = Provider.of<ProductList>(context, listen: false);

    void submitForm() {
      // chamar as validações.
      final isValidate = _formKey.currentState?.validate() ?? false;
      if (!isValidate) {
        return;
      }
      _formKey.currentState?.save();
      _formData['store_id'] = storeId;
      _formData['createdAt'] = DateTime.now().toIso8601String();

      setState(() {
        _isLoading = true;
      });

      try {
        // provider.saveProduct(_formData);
        provider.saveProductOnDb(_formData, int.parse(storeId));
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Ocorreu um error'),
            content: const Text('Ocoreu um erro para salvar o produto.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }

    return Scaffold(
      appBar: MainAppbar(
        title: 'Cadastrar Produto',
        listActions: [
          IconButton(onPressed: submitForm, icon: const Icon(Icons.save)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: InputImageWithPreview(
                        onSelectedImage: _selectImage,
                      ),
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                      validator: (descriptionInput) {
                        final description = descriptionInput ?? '';
                        if (description.trim().isEmpty) {
                          return 'Descrição obrigatória';
                        }

                        if (description.trim().length < 5) {
                          return 'Descrição precisar no mínimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['quantity']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      inputFormatters: <TextInputFormatter>[
                        // só permite que seja digitados números inteiros.
                        // digitos de 0-9.
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textInputAction: TextInputAction.next,
                      onSaved: (quantity) =>
                          _formData['quantity'] = quantity ?? '',
                      validator: (quantityInput) {
                        final quantity = quantityInput ?? '';
                        final quantityNumber = int.parse(quantity.trim());
                        if (quantity.trim().isEmpty) {
                          return 'Quantidade é obrigatório';
                        }

                        if (quantityNumber <= 0) {
                          return 'Quantidade inválida.';
                        }
                        return null;
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              _formData['codeBar']?.toString() ??
                                  'Leia o Código de Barras',
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: showBarcodeScanner,
                              child: const Text('Ler codigo'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Data Selecionada: ${_selectedDate == null ? '' : DateFormat('dd/MM/yy').format(_selectedDate as DateTime)}',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _showDatePicker(),
                            child: const Text('Selecione a Data'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
