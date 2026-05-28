import 'package:flutter/material.dart';
import 'package:valitrack/components/drawer/components/option_drawer.dart';
import 'package:valitrack/util/app_routes.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo, {fulano}'),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          OptionDrawer(
            iconOption: Icons.store,
            title: 'Lojas',
            route: AppRoutes.home,
          ),
          const Divider(),
          OptionDrawer(
            iconOption: Icons.settings,
            title: 'Configurações',
            route: AppRoutes.settingsScreen,
          ),
          const Divider(),
          OptionDrawer(
            iconOption: Icons.phone,
            title: 'Contato',
            route: AppRoutes.home, // criar a pagina de contato.
          ),
          const Divider(),
        ],
      ),
    );
  }
}
