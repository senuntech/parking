import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';

class PrinterConnected extends StatelessWidget {
  const PrinterConnected({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: .center,

        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .2),
          Icon(LucideIcons.printerCheck, size: 90, color: OneColors.dark1),
          OneSize.height16,
          OneText('Impressora Conectada', textAlign: .center),
          OneSize.height16,
          OneButton(onPressed: onTap, label: 'Desconectar'),
        ],
      ),
    );
  }
}
