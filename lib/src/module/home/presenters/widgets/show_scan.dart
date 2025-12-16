import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:one_ds/one_ds.dart';

class ShowScan extends StatefulWidget {
  const ShowScan({super.key});

  @override
  State<ShowScan> createState() => _ShowScanState();
}

class _ShowScanState extends State<ShowScan> {
  bool showFlash = false;
  final MobileScannerController controller = MobileScannerController(
    autoZoom: true,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onClose(String value) async {
    await controller.stop();
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'Scan',
        subtitle: 'Leia o código de barras',
        context: context,
        isClose: true,
        actions: [
          OneMiniButton(
            icon: showFlash
                ? LucideIcons.flashlightOff
                : LucideIcons.flashlight,
            onPressed: () {
              setState(() {
                showFlash = !showFlash;
              });
              controller.toggleTorch();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (barcodes) {
              onClose(barcodes.barcodes.firstOrNull?.displayValue ?? '');
            },
          ),
          Lottie.asset(
            'assets/lottie/scanner.json',
            height: double.infinity,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
