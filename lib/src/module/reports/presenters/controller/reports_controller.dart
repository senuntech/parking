import 'package:flutter/material.dart';
import 'package:parking/core/extension/date_timer.dart';
import 'package:parking/src/module/reports/presenters/widget/chart_widget.dart';
import 'package:parking/src/module/ticket/model/order_ticket_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

class ReportsController extends ChangeNotifier {
  final BriteDatabase briteDb;
  ReportsController({required this.briteDb});
  bool isProgress = false;
  DateTime first = DateTime.now();
  DateTime last = DateTime.now();

  List<OrderTicketModel> listOrder = [];
  List<OrderTicketModel> listOrderMonth = [];
  List<VendaPorMes> listChart = [];

  Future<void> getOrderByMonth() async {
    final current = DateTime.now();
    listOrderMonth = await _filterOrderByDate(
      current.firstDay,
      current.lastDay,
    );
  }

  Future<void> init() async {
    await Future.wait([
      getOrderByDate(DateTime.now(), DateTime.now()),
      getOrderByMonth(),
      getChartData(),
    ]);
  }

  Future<void> getChartData() async {
    final last = DateTime.now().date;
    final first = DateTime(last.year, last.month - 4, last.day).date;

    final result = await _filterOrderByDate(first, last);

    final Map<int, VendaPorMes> groupedSales = {};

    for (var element in result) {
      final monthKey = element.createdAt!.month;
      final saleValue = element.price ?? 0;

      if (groupedSales.containsKey(monthKey)) {
        groupedSales[monthKey]!.vendas += saleValue;
      } else {
        groupedSales[monthKey] = VendaPorMes(
          mes: element.createdAt!.currentNameMonthABBR,
          vendas: saleValue,
          date: element.createdAt,
        );
      }
    }

    List<VendaPorMes> list = groupedSales.values.toList();

    list.sort((a, b) => a.date!.compareTo(b.date!));
    listChart = list;
    notifyListeners();
  }

  Future<void> getOrderByDate(DateTime first, DateTime last) async {
    isProgress = true;
    notifyListeners();
    listOrder = await _filterOrderByDate(first, last);
    isProgress = false;
    notifyListeners();
  }

  double get getTotal {
    return listOrder.fold(0, (previousValue, element) {
      double price = element.price ?? 0;
      return previousValue + price;
    });
  }

  double get getTotalMonth {
    return listOrderMonth.fold(0, (previousValue, element) {
      double price = element.price ?? 0;
      return previousValue + price;
    });
  }

  Future<List<OrderTicketModel>> _filterOrderByDate(
    DateTime first,
    DateTime last,
  ) async {
    final start = first.date.millisecondsSinceEpoch;
    final end = last.date
        .add(Duration(hours: 23, minutes: 59, seconds: 59, milliseconds: 999))
        .millisecondsSinceEpoch;

    final List<Map<String, dynamic>> result = await briteDb.query(
      'order_ticket',
      where: 'created_at BETWEEN ? AND ? AND exit_at IS NOT NULL',
      whereArgs: [start, end],
      orderBy: 'created_at DESC',
    );

    return result.map((e) => OrderTicketModel.fromMap(e)).toList();
  }

  Future<void> delete(int id) async {
    await briteDb.delete('order_ticket', where: 'id=$id');
    await init();
    notifyListeners();
  }

  double getTotalByType(int id) {
    return listOrder.where((element) => element.paymentMethod == id).fold(0, (
      previousValue,
      element,
    ) {
      double price = element.price ?? 0;
      return previousValue + price;
    });
  }

  Future<void> returnVehicle(OrderTicketModel orderTicketModel) async {
    orderTicketModel.exitAt = null;
    await briteDb.update(
      'order_ticket',
      orderTicketModel.toMap(),
      where: 'id = ?',
      whereArgs: [orderTicketModel.id],
    );

    notifyListeners();
  }
}
