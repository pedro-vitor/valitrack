import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valitrack/model/product.dart';
import 'package:valitrack/util/calcule_size_image.dart';

class ListProductItem extends StatelessWidget {
  final Product product;
  final void Function(String) deleteProduct;
  final bool hasDivider;
  final File? image;
  final void Function() showModalOptionsProduct;

  ListProductItem({
    super.key,
    required this.product,
    required this.deleteProduct,
    required this.hasDivider,
    required this.showModalOptionsProduct,
  }) : image = product.image != null ? File(product.image!) : null;

  Widget isExpired(DateTime dueDateProduct) {
    final currentDate = DateTime.now();

    if (currentDate.isAfter(dueDateProduct)) {
      return const Icon(Icons.warning_rounded, size: 20, color: Colors.red);
    }
    return const Text('');
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
            panEnabled: true, // Permite arrastar a imagem
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: CalculeSizeImage.getWidthImage(image),
                height: CalculeSizeImage.getHeightImage(image),
                child: product.image != null
                    ? Image.file(image, fit: BoxFit.cover)
                    : Image.asset(
                        'assets/image/no_image.png',
                        fit: BoxFit.cover,
                      ),
              ),
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
        InkWell(
          onLongPress: () => showModalOptionsProduct(),
          child: ListTile(
            leading: GestureDetector(
              onTap: () => showModalImage(context, image!),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: product.image != null
                    ? Image.file(image!, height: 60)
                    : Image.asset('assets/image/no_image.png', height: 60),
              ),
            ),
            title: Text(
              product.description,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                    const SizedBox(width: 5),
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
            ? const Divider(endIndent: 10, indent: 10)
            : const SizedBox.shrink(),
      ],
    );
  }
}
