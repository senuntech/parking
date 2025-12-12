import 'dart:io';

import 'package:flutter/material.dart';
import 'package:one_ds/core/ui/index.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/utils/launch.dart';
import 'package:parking/main.dart';
import 'package:parking/src/module/home/widgets/input.dart';
import 'package:parking/src/widgets/vehicle_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final keyScafold = GlobalKey<ScaffoldState>();
  Widget get drawer {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: OneColors.background),
            child: Center(child: OneSelectImage()),
          ),
          OneSize.height16,
          Column(
            spacing: OneSizeConstants.size16,
            children: [
              OneListTile(
                title: 'Planos Premium',
                leading: Icon(LucideIcons.crown),
                onTap: () {},
                showDivider: false,
              ),
              OneListTile(
                title: 'Impressoras',
                leading: Icon(LucideIcons.printer),
                onTap: () {
                  Navigator.popAndPushNamed(context, Routes.printer);
                },
                showDivider: false,
              ),
              OneListTile(
                title: 'Preços',
                leading: Icon(LucideIcons.banknote),
                onTap: () {
                  Navigator.popAndPushNamed(context, Routes.category);
                },
                showDivider: false,
              ),

              OneListTile(
                title: 'Relatórios',
                leading: Icon(LucideIcons.chartColumnBig),
                onTap: () {},
                showDivider: false,
              ),
              OneListTile(
                title: 'Dúvidas ou Sugestões',
                leading: Icon(LucideIcons.mail),
                onTap: () {
                  LaunchApp.email();
                  Navigator.pop(context);
                },
                showDivider: false,
              ),
              OneListTile(
                title: 'Configurações',
                leading: Icon(LucideIcons.settings),
                onTap: () {
                  Navigator.popAndPushNamed(context, Routes.settings);
                },
                showDivider: false,
              ),
              if (Platform.isIOS)
                OneListTile(
                  title: 'Termos',
                  leading: Icon(LucideIcons.book),
                  onTap: () {
                    Navigator.pop(context);
                    showTerms();
                  },
                  showDivider: false,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void showTerms() {
    OneBottomSheet.show(
      context: context,
      title: 'Termos',
      content: [
        Padding(
          padding: .symmetric(horizontal: 16.0),
          child: OneListTile(
            title: 'Politica',
            leading: Icon(LucideIcons.bookA),

            children: [OneText('Politica de privacidade')],
            onTap: () {
              LaunchApp.site(
                "https://senuntech.com.br/politicas/gestor_transportes.html",
              );
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: .symmetric(horizontal: 16.0),
          child: OneListTile(
            title: 'EULA',
            leading: Icon(LucideIcons.book),

            children: [OneText('Termos de uso (EULA)')],
            onTap: () {
              LaunchApp.site(
                "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/",
              );
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  void showAction() {
    OneBottomSheet.show(
      context: context,
      title: 'Opções',
      content: [
        Padding(
          padding: .symmetric(horizontal: 16.0),
          child: OneListTile(
            title: 'Retirar Veículo',
            leading: Icon(LucideIcons.carTaxiFront),

            children: [OneText('Da saída no veículo')],
            onTap: () {
              Navigator.popAndPushNamed(
                context,
                Routes.receipt,
                arguments: true,
              );
            },
          ),
        ),
        Padding(
          padding: .symmetric(horizontal: 16.0),
          child: OneListTile(
            title: 'Segunda Via',
            leading: Icon(LucideIcons.send),

            children: [OneText('Imprimir ou Compartilhar segunda via')],
            onTap: () {
              Navigator.popAndPushNamed(context, Routes.receipt);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyScafold,
      drawer: drawer,
      appBar: OneAppBar(
        title: 'Home',
        context: context,
        subtitle: 'Lista de carros no pátio',
        onPressedMenu: () {
          keyScafold.currentState?.openDrawer();
        },
        actions: [
          OneMiniButton(icon: LucideIcons.chartColumnBig, onPressed: () {}),
        ],
      ),
      body: OneBody(
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: 16,
          children: [
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: OneCard(
                    padding: EdgeInsets.all(3),
                    children: [Input()],
                  ),
                ),
                OneCard(
                  children: [
                    OneText('10/30', style: TextStyle(fontWeight: .bold)),
                  ],
                ),
              ],
            ),
            OneCard(
              title: 'Pátio',
              children: [
                for (int i = 0; i <= 100; i++)
                  VehicleWidget(
                    type: (i % 2 == 0) ? .car : .motorcycle,
                    dateTime: DateTime(2025, 12, 11, 12),
                    onTap: showAction,
                  ),
              ],
            ),
            OneSize.height128,
          ],
        ),
      ),
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.pushNamed(context, Routes.ticket);
        },
        child: Icon(LucideIcons.plus),
      ),
    );
  }
}
