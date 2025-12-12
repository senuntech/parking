/* import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/src/module/printer/presenters/widget/empty_search_printer.dart';
import 'package:parking/src/module/printer/presenters/widget/item_printer.dart';
import 'package:parking/src/module/printer/presenters/widget/printer_connected.dart';
import 'package:permission_handler/permission_handler.dart';

BluetoothDevice? devicePrinter;

class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  late StreamSubscription<ConnectState> _connectStateSubscription;
  late StreamSubscription<List<BluetoothDevice>> _scanResultsSubscription;
  List<BluetoothDevice> _scanResults = [];

  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => initBluetoothPrintPlusListen(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _connectStateSubscription.cancel();
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    _scanResults.clear();
  }

  Future<void> initBluetoothPrintPlusListen() async {
    var status = await Permission.bluetoothConnect.request();
    if (status == .granted) {
      print('permitido');
    }

    _scanResultsSubscription = BluetoothPrintPlus.scanResults.listen((event) {
      if (mounted) {
        setState(() {
          print('********** DISPOSITIVOS: $event **********');
          _scanResults = event;
        });
      }
    });
    _isScanningSubscription = BluetoothPrintPlus.isScanning.listen((event) {
      print('********** isScanning: $event **********');
      if (mounted) {
        setState(() {});
      }
    });

    _connectStateSubscription = BluetoothPrintPlus.connectState.listen((event) {
      print('********** connectState change: $event **********');
      switch (event) {
        case ConnectState.connected:
          setState(() {
            if (devicePrinter == null) return;
          });
          break;
        case ConnectState.disconnected:
          break;
      }
    });
  }

  Widget get getBody {
    if (devicePrinter != null) {
      return PrinterConnected(
        onTap: () async {
          await BluetoothPrintPlus.disconnect();
          devicePrinter = null;
          setState(() {});
        },
      );
    }
    if (_scanResults.isEmpty) {
      return EmptySearchPrinter();
    }
    if (BluetoothPrintPlus.isBlueOn) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _scanResults.length,
        itemBuilder: (context, index) {
          BluetoothDevice item = _scanResults.elementAt(index);
          return ItemPrinter(
            onTap: () async {
              await BluetoothPrintPlus.connect(item);
              devicePrinter = item;
            },
            title: item.name,
            subTitle: Platform.isAndroid ? item.address : 'Impressora',
          );
        },
      );
    }
    return buildBlueOffWidget();
  }

  Widget buildBlueOffWidget() {
    return Center(
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .2),
          Icon(LucideIcons.bluetoothOff, size: 100),
          OneSize.height16,
          OneText("Bluetooth Desativado!", textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Future onScanPressed() async {
    try {
      if (BluetoothPrintPlus.isScanningNow) {
        await BluetoothPrintPlus.stopScan();
        return;
      }
      await BluetoothPrintPlus.startScan(timeout: Duration(seconds: 10));
    } catch (e) {
      print("onScanPressed error: $e");
    }
  }

  ({Color? colors, Widget icon, String label}) get buttonState {
    if (false) {
      return (
        colors: Colors.red,
        icon: SizedBox.square(
          dimension: 25,
          child: CircularProgressIndicator(color: Colors.white),
        ),
        label: 'Parar de Buscar',
      );
    }

    return (
      colors: null,
      icon: Icon(LucideIcons.search),
      label: 'Buscar Impressora',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'Impressoras',
        context: context,
        subtitle: 'Gerencie suas impressoras',
      ),
      body: OneBody(child: getBody),
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: devicePrinter != null
          ? null
          : FloatingActionButton.extended(
              onPressed: onScanPressed,
              label: OneText(buttonState.label),
              backgroundColor: buttonState.colors,
              icon: buttonState.icon,
            ),
    );
  }
}
 */
