import 'package:flutter/material.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> listActions;

  const MainAppbar({
    super.key,
    required this.title,
    this.listActions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      actions: listActions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
