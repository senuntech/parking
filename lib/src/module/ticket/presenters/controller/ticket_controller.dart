import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parking/core/analytics/analytics_service.dart';
import 'package:parking/core/enum/payment_method_enum.dart';
import 'package:parking/core/enum/type_charge_enum.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/src/module/ticket/data/model/order_ticket_model.dart';
import 'package:parking/src/utils/vehicle_utils.dart';
import 'package:sqlbrite/sqlbrite.dart';

class TicketController extends ChangeNotifier {
  final BriteDatabase briteDb;
  List<OrderTicketModel> tickets = [];
  List<OrderTicketModel> resultSearch = [];

  TicketController({required this.briteDb});

  Future<void> addTicket(OrderTicketModel orderTicketModel) async {
    if (tickets.any((element) => element.plate == orderTicketModel.plate)) {
      return;
    }
    orderTicketModel.code = Random().nextInt(100000).toString();

    await briteDb.insert('order_ticket', orderTicketModel.toMap());
    getTickets();
    notifyListeners();

    AnalyticsService.instance.logEntradaVeiculo(
      tipoVeiculo: VehicleEnum.values
          .firstWhere(
            (v) => v.id == orderTicketModel.typeVehicles,
            orElse: () => VehicleEnum.car,
          )
          .name,
      tipoCobranca: TypeChargeEnum.values
          .firstWhere(
            (t) => t.type == orderTicketModel.valueType,
            orElse: () => TypeChargeEnum.hour,
          )
          .name,
      temPlaca: orderTicketModel.plate != null &&
          orderTicketModel.plate!.trim().isNotEmpty,
      valorBase: orderTicketModel.price,
    );
  }

  Future<void> updateTicket(OrderTicketModel orderTicketModel) async {
    await briteDb.update(
      'order_ticket',
      orderTicketModel.toMap(),
      where: 'id = ?',
      whereArgs: [orderTicketModel.id],
    );
    notifyListeners();
  }

  Future<void> deleteTicket(int id) async {
    await briteDb.delete('order_ticket', where: 'id = ?', whereArgs: [id]);
    getTickets();
    notifyListeners();

    AnalyticsService.instance.logCancelamentoTicket(idTicket: id);
  }

  Future<List<OrderTicketModel>> getTickets() async {
    final List<Map<String, dynamic>> maps = await briteDb.query(
      'order_ticket',
      where: 'exit_at IS NULL',
    );
    tickets = maps.map((map) => OrderTicketModel.fromMap(map)).toList();
    tickets = tickets.reversed.toList();
    resultSearch = tickets;
    notifyListeners();
    return tickets;
  }

  Future<List<OrderTicketModel>> searchTicket(String query) async {
    resultSearch = tickets
        .where(
          (element) =>
              element.model!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    notifyListeners();
    return resultSearch;
  }

  Future<void> getTicketByCode(String code) async {
    final List<Map<String, dynamic>> maps = await briteDb.query(
      'order_ticket',
      where: 'code = ?',
      whereArgs: [code],
    );
    if (maps.isEmpty) {
      resultSearch = [];
      notifyListeners();
      return;
    }
    resultSearch = maps.map((map) => OrderTicketModel.fromMap(map)).toList();
    notifyListeners();
  }

  void reset() {
    resultSearch = tickets;
    notifyListeners();
  }

  Future<OrderTicketModel> exitTicket(int id, int paymentMethod) async {
    final OrderTicketModel orderTicketModel = tickets.firstWhere(
      (element) => element.id == id,
    );
    orderTicketModel.exitAt = DateTime.now();
    orderTicketModel.paymentMethod = paymentMethod;
    orderTicketModel.price = getTotalPrice(orderTicketModel);

    await briteDb.update(
      'order_ticket',
      orderTicketModel.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    await getTickets();

    final durationMinutes = orderTicketModel.exitAt != null &&
            orderTicketModel.createdAt != null
        ? orderTicketModel.exitAt!
            .difference(orderTicketModel.createdAt!)
            .inMinutes
        : 0;

    AnalyticsService.instance.logSaidaVeiculo(
      tipoVeiculo: VehicleEnum.values
          .firstWhere(
            (v) => v.id == orderTicketModel.typeVehicles,
            orElse: () => VehicleEnum.car,
          )
          .name,
      tipoCobranca: TypeChargeEnum.values
          .firstWhere(
            (t) => t.type == orderTicketModel.valueType,
            orElse: () => TypeChargeEnum.hour,
          )
          .name,
      tempoMinutos: durationMinutes,
      valorPago: orderTicketModel.price ?? 0.0,
      formaPagamento: PaymentMethodEnum.values
          .firstWhere(
            (p) => p.id == paymentMethod,
            orElse: () => PaymentMethodEnum.cash,
          )
          .name,
    );

    return orderTicketModel;
  }
}
