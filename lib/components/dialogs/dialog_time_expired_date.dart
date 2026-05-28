import 'package:flutter/material.dart';
import 'package:valitrack/enums/options_time_expired_date.dart';

class DialogTimeExpiredDate extends StatefulWidget {
  const DialogTimeExpiredDate({super.key});

  @override
  State<DialogTimeExpiredDate> createState() => _DialogTimeExpiredDateState();
}

class _DialogTimeExpiredDateState extends State<DialogTimeExpiredDate> {
  OptionsTimeExpiredDate? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tempo para Data Crítica'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            title: const Text(
              '1 mês',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            value: OptionsTimeExpiredDate.oneMonth,
            groupValue: _selectedValue,
            onChanged: (value) => setState(() => _selectedValue = value!),
          ),
          RadioListTile(
            title: const Text(
              '2 mêses',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            value: OptionsTimeExpiredDate.twoMonth,
            groupValue: _selectedValue,
            onChanged: (value) => setState(() => _selectedValue = value!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selectedValue),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
