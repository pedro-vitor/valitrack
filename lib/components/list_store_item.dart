import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:valitrack/model/store.dart';
import 'package:valitrack/providers/store_list.dart';
import 'package:valitrack/util/app_routes.dart';

class ListStoreItem extends StatelessWidget {
  final void Function() showModalUpdate;
  const ListStoreItem({super.key, required this.showModalUpdate});

  @override
  Widget build(BuildContext context) {
    /// Pegando o valor que foi repassado na lista de lojas pelo "ChangeNotifyLiteners.value"
    /// Com o "context.watch<Store>()".
    /// Esse ".watch()" faz com que o widget reaja a mudança no provider(notifyLiteners()).
    final store = context.watch<Store>();
    final storeList = context.read<StoreList>();

    void selectedStore(BuildContext context, Store store) {
      Navigator.of(
        context,
      ).pushNamed(AppRoutes.productScreen, arguments: store);
    }

    void deleteStore(BuildContext context, int id) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Tem certeza que deseja excluir essa loja?'),
          content: const Text(
            'Todos os Produtos cadastrados nessa loja serão excluídos!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                storeList.delete(id);
                Navigator.of(ctx).pop();
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    void optionsStore(BuildContext context, Store store) {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Editar Loja'),
                  onTap: () {
                    Navigator.of(context).pop();
                    showModalUpdate();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Excluir Loja',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Chamar a função de exclusão da loja
                    deleteStore(context, store.id!);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 1, //Como a sombra se espalha
            blurRadius: 5, //desfoque da sombra
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        // colocar essas funcoes de deletar e atualizar para um modal.
        onLongPress: () => optionsStore(context, store),

        onTap: () => selectedStore(context, store),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: SvgPicture.asset(
                'assets/image/store-front.svg',
                fit: BoxFit.cover,
                height: 30,
              ),
            ),
            title: Text(
              store.name,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${store.quantityRegisteredProducts} produtos totais',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.warning_rounded,
                  size: 59,
                  color: Theme.of(context).colorScheme.error,
                ),
                Positioned(
                  top: 20,
                  child: Container(
                    width: 10,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  child: Text(
                    '${store.quantityExpiredProducts}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
