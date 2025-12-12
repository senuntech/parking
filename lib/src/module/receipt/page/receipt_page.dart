import 'package:flutter/material.dart';
import 'package:one_ds/core/ui/index.dart';
import 'package:one_ds/core/ui/organisms/one_app_bar.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/src/module/receipt/widgets/receipt_widget.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  bool isExist = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null) {
      isExist = args as bool;
    }
    return Scaffold(
      appBar: OneAppBar(
        title: 'Recibo',
        subtitle: 'Imprima ou Compartilhe',
        context: context,
        isClose: true,

        actions: [
          OneMiniButton(
            color: OneColors.success,
            icon: LucideIcons.share2,
            onPressed: () {},
          ),
          OneMiniButton(icon: LucideIcons.printer, onPressed: () {}),
        ],
      ),
      body: OneBody(
        child: Container(
          decoration: BoxDecoration(
            color: OneColors.background,
            border: .all(color: OneColors.dark1.withAlpha(50)),
          ),
          height: MediaQuery.of(context).size.height * .7,
          child: ListView(children: [ReceiptWidget(isExist: isExist)]),
        ),
      ),
    );
  }
}
