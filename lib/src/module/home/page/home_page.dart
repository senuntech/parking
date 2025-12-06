import 'package:flutter/material.dart';
import 'package:one_ds/core/ui/index.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/src/widgets/vehicle_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'Home',
        context: context,
        subtitle: 'Lista de carros no pátio',
        onPressedMenu: () {},
      ),
      body: OneBody(
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: 16,
          children: [
            OneCard(
              children: [
                OneInput(
                  hintText: 'Buscar veículo',
                  label: 'Buscar',
                  icon: LucideIcons.search,
                  onChanged: (value) {},
                  suffixIcon: Padding(
                    padding: const .all(2.0),
                    child: OneMiniButton(
                      icon: LucideIcons.qrCode,
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            OneCard(
              title: 'Pátio',
              children: [
                for (int i = 0; i <= 100; i++)
                  VehicleWidget(type: .car, dateTime: DateTime.now()),
              ],
            ),
            OneSize.height64,
          ],
        ),
      ),
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(LucideIcons.plus),
        onPressed: () {},
        label: OneText('Adicionar'),
      ),
    );
  }
}
