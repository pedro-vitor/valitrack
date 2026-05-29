import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valitrack/components/modals/option_product_modal.dart';
import 'package:valitrack/model/product.dart';

class ListProductItem extends StatelessWidget {
  final Product product;
  final void Function(String) deleteProduct;
  final bool hasDivider;

  const ListProductItem({
    super.key,
    required this.product,
    required this.deleteProduct,
    required this.hasDivider,
  });

  Widget isExpired(DateTime dueDateProduct) {
    final currentDate = DateTime.now();

    if (currentDate.isAfter(dueDateProduct)) {
      return const Icon(
        Icons.warning_rounded,
        size: 20,
        color: Colors.red,
      );
    }
    return const Text('');
  }

  void showModal(
      BuildContext context, Product product, Function(Product) onDelete) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite fechar ao clicar fora
      builder: (BuildContext context) {
        return OptionProductModal(
          product: product,
          onDelete: onDelete,
        );
      },
    );
  }

  void showModalImage(BuildContext context, File image) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite fechar ao clicar fora
      barrierColor: Colors.black54, // Cor de fundo ao redor do diálogo
      useSafeArea: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: product.image != null
                  ? Image.file(product.image!)
                  : Image.asset('assets/image/no_image.png'),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: ValueKey(product.id),
          background: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10),
                bottomStart: Radius.circular(10),
              ),
            ),
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 35,
            ),
          ),
          confirmDismiss: (_) async {
            return showDialog<bool>(
              context: context,
              builder: (ctx) {
                final navigator = Navigator.of(ctx);
                return AlertDialog(
                  title: const Text('Tem certeza?'),
                  content: const Text('Quer remover esse item da lista?'),
                  actions: [
                    TextButton(
                      onPressed: () => navigator.pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => navigator.pop(true),
                      child: Text(
                        'Remover',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: ListTile(
            leading: GestureDetector(
              onTap: () => showModalImage(context, product.image!),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                child: product.image != null
                    ? Image.file(
                        product.image!,
                        height: 60,
                      )
                    : Image.asset(
                        'assets/image/no_image.png',
                        height: 60,
                      ), 
              ),
            ),
            title: Text(
              product.description,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('dd/MM/yyy').format(product.dueDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 112, 112, 112),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    isExpired(product.dueDate),
                  ],
                ),
                Text(
                  product.codeBar,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(255, 134, 134, 134),
                  ),
                ),
              ],
            ),
            trailing: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 199, 199, 199),
              radius: 26,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.quantity.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        hasDivider
            ? const Divider(
                endIndent: 10,
                indent: 10,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
