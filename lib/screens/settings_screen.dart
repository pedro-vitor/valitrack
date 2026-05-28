import 'package:flutter/material.dart';
import 'package:valitrack/components/dialogs/dialog_time_expired_date.dart';
import 'package:valitrack/components/drawer/main_drawer.dart';
import 'package:valitrack/components/mainAppbar/main_appbar.dart';
import 'package:valitrack/components/settings_widget/option_settings.dart';
import '../enums/options_time_expired_date.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> selectTimeExpiredDate(
    BuildContext context,
    DialogTimeExpiredDate content,
  ) async {
    OptionsTimeExpiredDate? time = await showDialog<OptionsTimeExpiredDate>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return content;
      },
    );
    print(time ?? 'nao veio nada !!!!!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppbar(title: 'Configurações'),
      drawer: const MainDrawer(),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 10,
        ),
        child: Column(
          children: [
            // Ao clicar aparecer o DIALOG com as opções de um ou dois messes.
            OptionSettings(
              iconOption: Icons.date_range_outlined,
              titleOption: 'Tempo Data Crítica',
              ontap: () => selectTimeExpiredDate(
                context,
                const DialogTimeExpiredDate(),
              ),
            ),
            // Ao clicar aparecer o DIALOG com as opções da Frequencia de Notificação.
            const OptionSettings(
              iconOption: Icons.edit_notifications_outlined,
              titleOption: 'Frequencia de Notificação',
            ),
          ],
        ),
      ),
    );
  }
}
