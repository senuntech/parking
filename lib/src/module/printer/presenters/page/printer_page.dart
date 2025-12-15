import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/src/module/printer/presenters/widget/empty_search_printer.dart';
import 'package:parking/src/module/printer/presenters/widget/item_printer.dart';
import 'package:parking/src/module/printer/presenters/widget/printer_connected.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

String deviceMacAddress = '';

class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  bool connected = false;
  List<BluetoothInfo> items = [];
  bool _progress = false;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
    if (statuses.values.every((status) => status.isGranted)) {
      onScanPressed();
    }
  }

  Future<void> printConnected() async {
    try {
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 1, text: 'Impressora Conectada'),
      );
      ShowSnakBar.show(context, message: 'Impressão Conectada', type: .success);
      setState(() {});
    } catch (e) {
      ShowSnakBar.show(context, message: 'Erro ao conectar', type: .error);
      deviceMacAddress = '';
      setState(() {});
    }
  }

  Widget get getBody {
    if (deviceMacAddress.isNotEmpty) {
      return PrinterConnected(
        onTap: () async {
          await PrintBluetoothThermal.disconnect;
          deviceMacAddress = '';
          setState(() {});
        },
      );
    }
    if (_progress && items.isEmpty) {
      return Padding(
        padding: .only(top: MediaQuery.of(context).size.height * .3),
        child: const CircularProgressIndicator.adaptive(),
      );
    }
    if (items.isEmpty) {
      return EmptySearchPrinter();
    }
    if (!_progress) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        physics: NeverScrollableScrollPhysics(),
        padding: .only(bottom: 100),
        itemBuilder: (context, index) {
          BluetoothInfo item = items.elementAt(index);
          return ItemPrinter(
            onTap: () async {
              deviceMacAddress = item.macAdress;
              setState(() {});
              await PrintBluetoothThermal.connect(
                macPrinterAddress: item.macAdress,
              );
              await printConnected();
            },
            title: item.name,
            subTitle: Platform.isAndroid ? item.macAdress : 'Impressora',
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

  Future<void> onScanPressed() async {
    setState(() {
      _progress = true;
      items = [];
    });
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    setState(() {
      _progress = false;
    });

    setState(() {
      items = listResult;
    });
  }

  ({Color? colors, Widget icon, String label}) get buttonState {
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
      floatingActionButton: _progress || deviceMacAddress.isNotEmpty
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
