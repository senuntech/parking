import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';

import 'package:parking/main.dart';
import 'package:parking/src/module/reports/presenters/controller/reports_controller.dart';
import 'package:parking/src/module/reports/presenters/view/view_reports.dart';
import 'package:parking/src/module/reports/presenters/widget/chart_widget.dart';
import 'package:parking/src/utils/get_date.dart';
import 'package:parking/src/utils/get_type_icon.dart';
import 'package:parking/src/utils/vehicle_utils.dart';
import 'package:provider/provider.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late ReportsController reportsController;
  DateTime first = DateTime.now();
  DateTime last = DateTime.now();

  @override
  void initState() {
    reportsController = context.read<ReportsController>();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  Future<void> init() async {
    await reportsController.init();
  }

  Future<void> onDelete(int id) async {
    ShowAlert.show(
      context,
      title: 'Deletar',
      labelYes: 'Sim',
      labelNo: 'Não',
      message: 'Deseja deletar este item?',
      onYes: () async {
        await reportsController.delete(id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'Relatórios',
        subtitle: '${first.formatedDate} à ${last.formatedDate}',
        context: context,
        actions: [
          OneMiniButton(
            icon: LucideIcons.calendarDays,
            onPressed: () {
              showDatePickerApp(
                context,
                reportsController,
                (first, last) {
                  this.first = first;
                  this.last = last;
                  setState(() {});
                },
                first,
                last,
              );
            },
          ),
          OneMiniButton(
            icon: LucideIcons.fileChartColumn,
            color: OneColors.success,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewReports(listDates: [first, last]),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ReportsController>(
        builder: (context, value, child) {
          if (value.isProgress) {
            return Center(child: CircularProgressIndicator());
          }

          return OneBody(
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: 16,
              children: [
                OneCard(title: "Últimos Meses", children: [ChartWidget()]),

                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: OneCard(
                        title: "Soma Total",
                        children: [
                          OneText(
                            UtilBrasilFields.obterReal(value.getTotal),
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.green,
                              fontWeight: .bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: OneCard(
                        title: DateTime.now().currentNameMonth,
                        children: [
                          OneText(
                            UtilBrasilFields.obterReal(value.getTotalMonth),
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.green,
                              fontWeight: .bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                OneCard(
                  title: "Registros",
                  children: value.listOrder.map((e) {
                    double total = getTotalPrice(e);
                    return OneListTile(
                      title: '${e.model} | ${e.plate}',
                      leading: Icon(icon(e.typeVehicles!)),
                      actions: [
                        OneMiniButton(
                          icon: LucideIcons.trash,
                          color: OneColors.error,
                          onPressed: () {
                            onDelete(e.id!);
                          },
                        ),
                      ],
                      children: [
                        OneText.caption(
                          '${e.createdAt?.formated} - ${UtilBrasilFields.obterReal(total)}',
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
                OneSize.height64,
              ],
            ),
          );
        },
      ),
    );
  }
}
