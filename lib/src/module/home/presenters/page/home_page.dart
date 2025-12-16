import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_ds/core/ui/index.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/payment_method_enum.dart';
import 'package:parking/core/enum/type_charge_enum.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/core/utils/launch.dart';
import 'package:parking/main.dart';
import 'package:parking/src/module/category/presenters/controller/category_controller.dart';
import 'package:parking/src/module/home/presenters/widgets/empty_page.dart';
import 'package:parking/src/module/home/presenters/widgets/input.dart';
import 'package:parking/src/module/ticket/presenters/controller/ticket_controller.dart';
import 'package:parking/src/module/ticket/data/model/order_ticket_model.dart';
import 'package:parking/src/widgets/vehicle_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final keyScafold = GlobalKey<ScaffoldState>();
  bool showButton = false;
  FocusNode focusNode = FocusNode();

  Widget get drawer {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: OneColors.background),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/icon/icon.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
          ),
          OneSize.height16,
          Column(
            spacing: OneSizeConstants.size16,
            children: [
              OneListTile(
                title: 'Planos Premium',
                leading: Icon(LucideIcons.crown),
                onTap: () {
                  Navigator.popAndPushNamed(context, Routes.plans);
                },
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
                onTap: () {
                  Navigator.popAndPushNamed(context, Routes.reports);
                },
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
                "https://senuntech.com.br/politicas/gestor_estacionamentos.html",
              );
              Navigator.pop(context);
            },
          ),
        ),
        if (Platform.isIOS)
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

  void showAction(OrderTicketModel orderTicketModel) {
    OneBottomSheet.show(
      context: context,
      title: orderTicketModel.name!,
      content: [
        Padding(
          padding: .symmetric(horizontal: 16.0),
          child: OneListTile(
            title: 'Retirar Veículo',
            leading: Icon(LucideIcons.carTaxiFront),

            children: [OneText('Da saída no veículo')],
            onTap: () {
              Navigator.pop(context);
              onExit(orderTicketModel.id!, orderTicketModel.model!);
            },
          ),
        ),
        Padding(
          padding: .symmetric(horizontal: 16.0),
          child: OneListTile(
            title: 'Editar',
            leading: Icon(LucideIcons.pen),

            children: [OneText('Editar veículo')],
            onTap: () {
              Navigator.popAndPushNamed(
                context,
                Routes.ticket,
                arguments: orderTicketModel,
              );
            },
          ),
        ),
        Padding(
          padding: .symmetric(horizontal: 16.0),
          child: OneListTile(
            title: 'Deletar',
            leading: Icon(LucideIcons.trash),
            onTap: () {
              Navigator.pop(context);
              onDelete(orderTicketModel.id!);
            },
            children: [OneText('Deletar veículo')],
          ),
        ),
        Padding(
          padding: .symmetric(horizontal: 16.0),
          child: OneListTile(
            title: 'Segunda Via',
            leading: Icon(LucideIcons.send),

            children: [OneText('Imprimir ou Compartilhar segunda via')],
            onTap: () {
              Navigator.popAndPushNamed(
                context,
                Routes.receipt,
                arguments: orderTicketModel,
              );
            },
          ),
        ),
      ],
    );
  }

  void onDelete(int id) {
    ShowAlert.show(
      context,
      title: 'Deletar',
      message: 'Deseja deletar o veículo?',
      labelYes: 'Sim',
      labelNo: 'Não',
      onYes: () {
        context.read<TicketController>().deleteTicket(id);
        ShowSnakBar.show(
          context,
          message: 'Veículo deletado com sucesso',
          type: .success,
        );
      },
    );
  }

  void onExit(int id, String name) {
    ShowAlert.show(
      context,
      title: 'Retirar $name',
      message: 'Deseja retirar o veículo?',
      labelYes: 'Sim',
      labelNo: 'Não',
      onYes: () {
        onPayment(id, name);
      },
    );
  }

  VehicleEnum vehicleEnum(int type) {
    switch (type) {
      case 1:
        return VehicleEnum.motorcycle;
      case 2:
        return VehicleEnum.car;

      default:
        return VehicleEnum.truck;
    }
  }

  TypeChargeEnum typeChargeEnum(int type) {
    switch (type) {
      case 1:
        return TypeChargeEnum.fix;
      case 2:
        return TypeChargeEnum.hour;

      default:
        return TypeChargeEnum.day;
    }
  }

  void initFocusNode() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showButton = true;
        setState(() {});
      } else {
        showButton = false;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initFocusNode();
  }

  // forma de pagamento
  void onPayment(int id, String name) {
    int typeCharge = 1;

    OneBottomSheet.show(
      context: context,
      title: 'Forma de pagamento',

      content: [
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                CheckboxListTile(
                  value: PaymentMethodEnum.pix.id == typeCharge,
                  onChanged: (value) {
                    setState(() {
                      typeCharge = PaymentMethodEnum.pix.id;
                    });
                  },
                  title: OneText('Pix'),
                ),
                CheckboxListTile(
                  value: PaymentMethodEnum.cash.id == typeCharge,
                  onChanged: (value) {
                    setState(() {
                      typeCharge = PaymentMethodEnum.cash.id;
                    });
                  },
                  title: OneText('Dinheiro'),
                ),

                CheckboxListTile(
                  value: PaymentMethodEnum.card.id == typeCharge,
                  onChanged: (value) {
                    setState(() {
                      typeCharge = PaymentMethodEnum.card.id;
                    });
                  },
                  title: OneText('Cartão'),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: .centerRight,
                    child: SizedBox(
                      height: 50,
                      child: OneButton(
                        label: 'Confirmar',
                        style: OneButtonStyle.outlined,
                        onPressed: () async {
                          final order = await context
                              .read<TicketController>()
                              .exitTicket(id, typeCharge);
                          Navigator.popAndPushNamed(
                            context,
                            Routes.receipt,
                            arguments: order,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyScafold,
      appBar: OneAppBar(
        title: 'Home',
        context: context,
        subtitle: 'Lista de carros no pátio',
        onPressedMenu: () {
          keyScafold.currentState?.openDrawer();
        },
        actions: [
          OneMiniButton(
            icon: LucideIcons.calculator,
            onPressed: () {
              Navigator.pushNamed(context, Routes.cashRegister);
            },
          ),
        ],
      ),
      drawer: drawer,
      body: OneBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: OneCard(
                    padding: EdgeInsets.all(3),
                    children: [Input(focusNode: focusNode)],
                  ),
                ),
                OneCard(
                  children: [
                    Consumer2<TicketController, CategoryController>(
                      builder:
                          (
                            context,
                            ticketController,
                            categoryController,
                            child,
                          ) {
                            return OneText(
                              '${ticketController.tickets.length}/${categoryController.length()}',
                              style: TextStyle(fontWeight: .bold),
                            );
                          },
                    ),
                  ],
                ),
              ],
            ),
            Consumer<TicketController>(
              builder: (context, ticketController, child) {
                if (ticketController.resultSearch.isEmpty) {
                  return EmptyPage();
                }
                return OneCard(
                  title: 'Pátio',
                  children: ticketController.resultSearch.map((ticket) {
                    return VehicleWidget(
                      type: vehicleEnum(ticket.typeVehicles!),
                      dateTime: ticket.createdAt!,
                      onTap: () => showAction(ticket),
                      plate: ticket.plate!,
                      model: ticket.model!,
                      typeCharge: typeChargeEnum(ticket.valueType!),
                    );
                  }).toList(),
                );
              },
            ),
            OneSize.height128,
          ],
        ),
      ),
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: showButton
          ? null
          : FloatingActionButton.large(
              onPressed: () {
                Navigator.pushNamed(context, Routes.ticket);
              },
              child: Icon(LucideIcons.plus),
            ),
    );
  }
}
