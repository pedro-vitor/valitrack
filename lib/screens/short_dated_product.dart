import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valitrack/components/list_product_item.dart';
import 'package:valitrack/components/mainAppbar/main_appbar.dart';
import 'package:valitrack/model/store.dart';
import 'package:valitrack/providers/product_list.dart';
import 'package:valitrack/util/app_routes.dart';
import '../model/product.dart';

class ShortDatedProduct extends StatelessWidget {
  const ShortDatedProduct({super.key});

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

  @override
  Widget build(BuildContext context) {
    final Store store = ModalRoute.of(context)?.settings.arguments as Store;

    final provider = Provider.of<ProductList>(context);
    // final products = await provider.getProductByStore(store.id);

    // final Map<DateTime, List<Product>> sessionsProducts =
    //     createSessionPerDueDate(products);

    // final getKeys = sessionsProducts.keys.toList();

    List<Widget> itemList(List<Product> listProducts) {
      List<Widget> itemsList = [];
      for (int i = 0; i < listProducts.length; i++) {
        itemsList.add(
          ChangeNotifierProvider.value(
            value: provider,
            child: ListProductItem(
              product: listProducts[i],
              deleteProduct: (_) {},
              hasDivider: i != listProducts.length - 1,
            ),
          ),
        );
      }
      return itemsList;
    }

    return FutureBuilder(
      future: provider.getSessionsPerDueDate(store.id),
      builder: ((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
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
                                    (sessionsProducts[key] as List<Product>),
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
            onPressed: () {
              // showFormProduct(context, addNewProduct);
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.productForm, arguments: store.id);
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
