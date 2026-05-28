import 'dart:math';

import 'package:flutter/material.dart';
import 'package:valitrack/model/store.dart';

class StoreForm extends StatelessWidget {
  final void Function(Store) addStore;

  const StoreForm({super.key, required this.addStore});

  @override
  Widget build(BuildContext context) {
    final nameStore = TextEditingController();

    Store createNewStore(String nameStore) {
      return Store(
        id: Random().nextInt(10),
        name: nameStore,
        quantityRegisteredProducts: 0,
        quantityProductsToExpire: 0,
        quantityExpiredProducts: 0,
      );
    }

    submitForm() {
      final name = nameStore.text;

      if (name.isEmpty) return;

      final Store newStore = createNewStore(name);

      addStore(newStore);
      Navigator.pop(context);
    }

    return Card(
      elevation: 10,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              onSubmitted: (_) => submitForm(),
              controller: nameStore,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                labelText: 'Nome da Loja',
                labelStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 125, 125, 125),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => submitForm(),
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
    );
  }
}
