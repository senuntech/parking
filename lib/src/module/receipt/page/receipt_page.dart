import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/src/module/receipt/widgets/receipt_widget.dart';
import 'package:parking/src/module/ticket/model/order_ticket_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  bool isExist = false;
  OrderTicketModel? orderTicketModel;
  final controller = WidgetsToImageController();

  Future<bool> shared() async {
    try {
      Uint8List? bytes = await controller.capture(
        options: const CaptureOptions(
          format: ImageFormat.png,
          pixelRatio: 3.0,
          quality: 95,
          waitForAnimations: true,
          delayMs: 100,
        ),
      );

      final params = ShareParams(
        files: [XFile.fromData(bytes!)],
        fileNameOverrides: ['comprovante.png'],
        excludedCupertinoActivities: [CupertinoActivityType.message],
      );

      await SharePlus.instance.share(params);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null) {
      orderTicketModel = args as OrderTicketModel;
      isExist = true;
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
            onPressed: shared,
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
          child: ListView(
            children: [
              WidgetsToImage(
                controller: controller,
                child: ReceiptWidget(
                  isExist: isExist,
                  orderTicketModel: orderTicketModel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
