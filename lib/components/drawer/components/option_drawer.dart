import 'package:flutter/material.dart';

class OptionDrawer extends StatelessWidget {
  final IconData iconOption;
  final String title;
  final String route;
  const OptionDrawer({
    super.key,
    required this.iconOption,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconOption),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      onTap: () => Navigator.of(context).pushReplacementNamed(route),
    );
  }
}
