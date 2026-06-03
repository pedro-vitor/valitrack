import 'package:flutter/material.dart';
import 'package:valitrack/model/store.dart';

class StoreForm extends StatefulWidget {
  final void Function(Store) onSubmit;
  final Store? store;

  const StoreForm({super.key, required this.onSubmit, this.store});

  @override
  State<StoreForm> createState() => _StoreFormState();
}

class _StoreFormState extends State<StoreForm> {
  final nameStore = TextEditingController();

  @override
  initState() {
    super.initState();

    if (widget.store != null) {
      nameStore.text = widget.store!.name;
    }

    nameStore.selection = TextSelection.fromPosition(
      TextPosition(offset: nameStore.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    Store mountStore(String nameStore, [int? storeId]) {
      return Store(
        id: storeId,
        name: nameStore,
        quantityRegisteredProducts: 0,
        quantityProductsToExpire: 0,
        quantityExpiredProducts: 0,
      );
    }

    submitForm() {
      if (widget.store != null && nameStore.text == widget.store!.name) {
        Navigator.pop(context);
        return;
      }

      final name = nameStore.text.trim();

      if (name.isEmpty) return;

      final Store newStore = widget.store == null
          ? mountStore(name)
          : mountStore(name, widget.store!.id!);

      widget.onSubmit(newStore);
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
              textCapitalization: TextCapitalization.sentences,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => submitForm(),
                  style: const ButtonStyle(
                    elevation: WidgetStatePropertyAll(2),
                  ),
                  child: Text(
                    widget.store == null ? 'Cadastrar' : 'Atualizar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
