import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valitrack/components/ModalForms/store_form.dart';
import 'package:valitrack/components/drawer/main_drawer.dart';
import 'package:valitrack/components/list_store_item.dart';
import 'package:valitrack/components/mainAppbar/main_appbar.dart';
import 'package:valitrack/model/store.dart';
import 'package:valitrack/providers/store_list.dart';

class StoreScreen extends StatefulWidget {

  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  // Carrega os produtos da loja para mostrar a quantidade de produtos registrados, a quantidade de produtos para expirar e a quantidade de produtos expirados.
  late Future<void> _future;

  @override
  initState() {
    super.initState();

    //iniciar o future para carregar os produtos da loja, fora do build para evitar que ele seja chamado toda vez que o widget for reconstruido.
    _future = context.read<StoreList>().loadProducts();
  }

  void _showFormStore(
    BuildContext ctx,
    Function(Store) onSubmit, [
    Store? store,
  ]) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return StoreForm(
          // funcao para adicionar ou atualizar uma loja.
          onSubmit: onSubmit,
          store: store,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<StoreList>();

    /// O "Selector" serve para observar uma propriedade exclusiva do provider
    /// Diferente do "Provider.of(context)" ele não fica preso ao "notifyListeners()"
    /// Passa o propriedade que sera observada na prop. "selector"(no caso o numero de items na lista)
    /// Ele so vai renderizar quando esse "itemsCount" mudar de valor.
    return Scaffold(
      appBar: const MainAppbar(title: 'Lojas'),
      drawer: const MainDrawer(),
      body: FutureBuilder(
        future: _future,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Selector<StoreList, int>(
                selector: (_, storeList) => storeList.itemsCount,
                builder: (context, itemsCount, _) {
                  List<Store> stores = provider.items;
                  return stores.isEmpty
                      ? const Center(child: Text('Nunhuma Loja Cadastrada!'))
                      : ListView.builder(
                          itemCount: stores.length,
                          itemBuilder: (ctx, index) {
                            var store = stores[index];

                            return Selector<StoreList, Store>(
                              selector: (_, storeList) =>
                                  storeList.getById(store.id!)!,
                              builder: (context, store, _) =>
                                  ChangeNotifierProvider.value(
                                    value: store,
                                    child: ListStoreItem(
                                      key: ValueKey(store.id),
                                      showModalUpdate: () => _showFormStore(
                                        context,
                                        provider.updateStore,
                                        store,
                                      ),
                                    ),
                                  ),
                            );
                          },
                        );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showFormStore(context, provider.addStore), //colocar a funcao.
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
