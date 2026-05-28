import 'package:flutter/material.dart';

class OptionSettings extends StatelessWidget {
  final IconData iconOption;
  final String titleOption;
  final Function()? ontap;
  const OptionSettings({
    super.key,
    required this.iconOption,
    required this.titleOption,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        leading: Icon(
          iconOption,
          size: 30,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        title: Text(
          titleOption,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_outlined,
          size: 18,
        ),
        onTap: ontap ?? () {},
      ),
    );
  }
}
