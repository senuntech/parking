import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/src/module/reports/presenters/controller/reports_controller.dart';
import 'package:provider/provider.dart';

class VendaPorMes {
  String mes;
  double vendas;
  DateTime? date;

  VendaPorMes({required this.mes, required this.vendas, this.date});
}

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  List<charts.Series<VendaPorMes, String>> _createSampleData(
    List<VendaPorMes> list,
  ) {
    final currentMonth = DateTime.now().month;

    return [
      charts.Series<VendaPorMes, String>(
        id: 'Vendas',
        colorFn: (element, _) {
          if (element.date!.month == currentMonth) {
            return charts.MaterialPalette.green.shadeDefault;
          }
          return charts.MaterialPalette.blue.shadeDefault;
        },
        domainFn: (VendaPorMes vendas, _) => vendas.mes,
        measureFn: (VendaPorMes vendas, _) => vendas.vendas,
        data: list,

        labelAccessorFn: (VendaPorMes vendas, _) =>
            UtilBrasilFields.obterReal(vendas.vendas),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 180,
      child: Consumer<ReportsController>(
        builder: (context, value, _) {
          return charts.BarChart(
            _createSampleData(value.listChart),
            defaultRenderer: charts.BarRendererConfig(
              barRendererDecorator: charts.BarLabelDecorator<String>(),
              maxBarWidthPx: 60,
            ),
            primaryMeasureAxis: const charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelAnchor: charts.TickLabelAnchor.before,
              ),
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                desiredTickCount: 5,
              ),
            ),
          );
        },
      ),
    );
  }
}
