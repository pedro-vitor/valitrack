import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valitrack/components/list_product_item.dart';
import 'package:valitrack/components/mainAppbar/main_appbar.dart';
import 'package:valitrack/model/store.dart';
import 'package:valitrack/providers/product_list.dart';
import 'package:valitrack/util/app_routes.dart';
import '../model/product.dart';

class ShortDatedProduct extends StatefulWidget {
  const ShortDatedProduct({super.key});

  @override
  State<ShortDatedProduct> createState() => _ShortDatedProductState();
}

class _ShortDatedProductState extends State<ShortDatedProduct> {
  late Future<Map<DateTime, List<Product>>> _futureProducts;
  late Store store;
  late ProductList provider;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      store = ModalRoute.of(context)!.settings.arguments as Store;

      provider = Provider.of<ProductList>(context, listen: false);

      _futureProducts = provider.getSessionsPerDueDate(store.id!);

      _initialized = true;
    }
  }

  void refreshProducts() {
    setState(() {
      _futureProducts = provider.getSessionsPerDueDate(store.id!);
    });
  }

  Color _colorsIndication(DateTime dueDate) {
    final currentDate = DateTime.now();

    // Calcula a diferença total de meses
    // Ex: (2026 * 12 + 1) - (2025 * 12 + 12) = 1 mês de diferença
    final diffMonth =
        (dueDate.year - currentDate.year) * 12 +
        (dueDate.month - currentDate.month);

    if (diffMonth < 0) {
      return Colors.black87;
    } else if (diffMonth == 0) {
      return const Color.fromARGB(255, 212, 83, 70);
    } else if (diffMonth == 1) {
      return const Color.fromARGB(255, 234, 141, 75);
    } else {
      return const Color.fromARGB(255, 87, 166, 130);
    }
  }

  Future<bool> confirmDeleteProduct(Product product) async {
    return await showDialog(
      context: context,
      barrierDismissible: true, // Permite fechar ao clicar fora
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Confirmação de exclusão',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Tem certeza que deseja excluir este item?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center, // Centraliza os botões
        actions: [
          // Ação 1: Confirmar exclusão
          TextButton.icon(
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Excluir'),
            onPressed: () {
              Navigator.pop(ctx, true); // Retorna true para confirmar exclusão
            },
          ),
          // Ação 2: Cancelar
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.grey),
            label: const Text('Cancelar'),
            onPressed: () {
              Navigator.pop(ctx, false); // Retorna false para cancelar
            },
          ),
        ],
      ),
    ).then(
      (value) => value ?? false,
    ); // Retorna false se o diálogo for fechado sem escolha
  }


  void showModalOptionsProduct(BuildContext context, Product product) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite fechar ao clicar fora
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Escolha uma ação', textAlign: TextAlign.center),
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
            onPressed: () async {
              Navigator.pop(ctx);
              await Navigator.pushNamed(
                ctx,
                AppRoutes.productForm,
                arguments: [product.storeId, product],
              );
              refreshProducts();
            },
          ),
          // Ação 3: Excluir
          TextButton.icon(
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Excluir'),
            onPressed: () async {
              bool confirmed = await confirmDeleteProduct(product);
              if (!confirmed) return;
              provider.deleteProductOnDb(product.id!, product.storeId);
              refreshProducts();
              if(context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> itemList(
      List<Product> listProducts,
    ) {
      List<Widget> itemsList = [];
      for (int i = 0; i < listProducts.length; i++) {
        itemsList.add(
          ChangeNotifierProvider.value(
            value: provider,
            child: ListProductItem(
              product: listProducts[i],
              hasDivider: i != listProducts.length - 1,
              showModalOptionsProduct: () =>
                  showModalOptionsProduct(context, listProducts[i]),
            ),
          ),
        );
      }
      return itemsList;
    }

    return FutureBuilder(
      future: _futureProducts,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final Map<DateTime, List<Product>> sessionsProducts =
            snapshot.data ?? {};
        final getKeys = sessionsProducts.keys.toList();

        return Scaffold(
          appBar: MainAppbar(
            title: store.name,
            listActions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.barcode_reader),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: sessionsProducts.isEmpty
                    ? Image.asset('assets/image/back_no_product.png')
                    : Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: ListView.builder(
                          itemCount: sessionsProducts.length,
                          itemBuilder: (ctx, index) {
                            final key = getKeys[index];

                            return Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    spreadRadius: 1, //Como a sombra se espalha
                                    blurRadius: 5, //desfoque da sombra
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                      ),
                                      color: _colorsIndication(
                                        DateTime(key.year, key.month),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                            top: 2,
                                            bottom: 2,
                                          ),
                                          child: Text(
                                            // O ".padLeft(0, '0')" garante que na minha string tera dois caracteres, preenchidos com '0' a esquerda.
                                            "${key.month.toString().padLeft(2, '0')} / ${key.year}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...itemList(
                                    (sessionsProducts[key] as List<Product>)
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
               await Navigator.of(
                context,
              ).pushNamed(AppRoutes.productForm, arguments: [store.id]);
              refreshProducts();
            },
            child: Icon(
              Icons.barcode_reader,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        );
      }),
    );
  }
}
