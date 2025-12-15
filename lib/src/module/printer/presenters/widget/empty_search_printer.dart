import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';

class EmptySearchPrinter extends StatelessWidget {
  const EmptySearchPrinter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * .2),
        Icon(LucideIcons.searchX, size: 100, color: Colors.grey.shade400),
        OneText.heading3('Impressora não Encontrada.'),
        OneSize.height16,
        OneText.caption(
          'Por favor, verifique se a conexão Bluetooth está ativada \nno seu dispositivo para que possamos localizar a impressora.',
          color: Colors.grey,
          textAlign: .center,
        ),
        OneSize.height16,
        if (Platform.isAndroid) ...[
          OneText(
            '🚨 Caso não encontre a impressora, tente pareá-la nas configurações de Bluetooth do seu dispositivo.',
            textAlign: .center,
            style: TextStyle(color: Colors.grey),
          ),
          OneButton(
            onPressed: () async {
              await AppSettings.openAppSettings(type: .bluetooth);
            },
            label: 'Configurações de Bluetooth',
          ),
        ],
        OneSize.height16,
      ],
    );
  }
}
