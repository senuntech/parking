import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:one_ds/core/index.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/payment_method_enum.dart';
import 'package:parking/core/extension/date_timer.dart';
import 'package:parking/main.dart';
import 'package:parking/src/module/reports/presenters/controller/reports_controller.dart';
import 'package:parking/src/module/ticket/controller/ticket_controller.dart';
import 'package:parking/src/module/ticket/model/order_ticket_model.dart';
import 'package:parking/src/utils/get_date.dart';
import 'package:parking/src/utils/get_type_icon.dart';
import 'package:provider/provider.dart';

class CashRegisterPage extends StatefulWidget {
  const CashRegisterPage({super.key});

  @override
  State<CashRegisterPage> createState() => _CashRegisterPageState();
}

class _CashRegisterPageState extends State<CashRegisterPage> {
  DateTime first = DateTime.now();
  DateTime last = DateTime.now();
  late ReportsController reportsController;
  late TicketController ticketController;

  /* Future<void> showDatePicker() async {
    OneBottomSheet.show(
      context: context,
      title: 'Selecionar Data',
      content: [
        CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            calendarType: CalendarDatePicker2Type.range,
            selectedDayHighlightColor: OneColors.primary,
          ),
          value: [first, last],
          onValueChanged: (dates) {
            first = dates.first;
            last = dates.last;
            setState(() {});
          },
        ),
        OneDivider(),
        Align(
          alignment: .centerRight,
          child: Padding(
            padding: .all(8.0),
            child: OneButton(
              onPressed: () async {
                Navigator.pop(context);
                await reportsController.getOrderByDate(first, last);
              },
              label: 'Selecionar',
              style: OneButtonStyle.primary,
            ),
          ),
        ),
      ],
    );
  } */

  @override
  void initState() {
    reportsController = context.read<ReportsController>();
    ticketController = context.read<TicketController>();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  Future<void> init() async {
    await reportsController.init();
  }

  Future<void> returnVehicle(OrderTicketModel orderTicketModel) async {
    ShowAlert.show(
      context,
      title: 'Retornar veículo',
      message: 'Deseja devolver o veículo?',
      labelYes: 'Sim',
      labelNo: 'Não',
      onYes: () async {
        await reportsController.returnVehicle(orderTicketModel);
        await ticketController.getTickets();
        await init();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'Caixa',
        subtitle: '${first.formatedDate} à ${last.formatedDate}',
        context: context,
        actions: [
          OneMiniButton(
            icon: LucideIcons.calendarDays,
            onPressed: () => showDatePickerApp(
              context,
              reportsController,
              (first, last) {
                this.first = first;
                this.last = last;
                setState(() {});
              },
              first,
              last,
            ),
          ),
          OneMiniButton(
            icon: LucideIcons.printer,
            color: OneColors.success,
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ReportsController>(
        builder: (context, value, child) {
          return OneBody(
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: 16,
              children: [
                OneCard(
                  title: 'Total',
                  children: [
                    OneText.heading2(
                      UtilBrasilFields.obterReal(reportsController.getTotal),
                    ),
                  ],
                ),
                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: OneCard(
                        title: 'Pix',
                        children: [
                          OneText(
                            UtilBrasilFields.obterReal(
                              value.getTotalByType(PaymentMethodEnum.pix.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: OneCard(
                        title: 'Dinheiro',
                        children: [
                          OneText(
                            UtilBrasilFields.obterReal(
                              value.getTotalByType(PaymentMethodEnum.cash.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: OneCard(
                        title: 'Cartão',
                        children: [
                          OneText(
                            UtilBrasilFields.obterReal(
                              value.getTotalByType(PaymentMethodEnum.card.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                OneCard(
                  title: "Histórico",
                  children: value.listOrder.map((e) {
                    return OneListTile(
                      title: '${e.model} | ${e.plate}',
                      leading: Icon(icon(e.typeVehicles!)),
                      actions: [
                        OneMiniButton(
                          icon: LucideIcons.undo,
                          color: OneColors.warning,
                          onPressed: () {
                            returnVehicle(e);
                          },
                        ),
                      ],
                      children: [
                        OneText.caption(
                          '${e.createdAt?.formated} - ${UtilBrasilFields.obterReal(e.price ?? 0)}',
                        ),
                      ],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.receipt,
                          arguments: e,
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
