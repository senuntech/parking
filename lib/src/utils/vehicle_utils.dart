import 'package:one_ds/core/extension/date_timer.dart';
import 'package:parking/core/enum/type_charge_enum.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/src/module/ticket/data/model/order_ticket_model.dart';

VehicleEnum getVehicle(int typeVehicle) {
  if (typeVehicle == VehicleEnum.car.id) {
    return VehicleEnum.car;
  }
  if (typeVehicle == VehicleEnum.motorcycle.id) {
    return VehicleEnum.motorcycle;
  }
  return VehicleEnum.truck;
}

String getDate(OrderTicketModel orderTicketModel) {
  if (orderTicketModel.exitAt != null) {
    return orderTicketModel.exitAt!.formated;
  }
  return orderTicketModel.createdAt!.formated;
}

int getDay(OrderTicketModel orderTicketModel) {
  DateTime exit = orderTicketModel.exitAt ?? DateTime.now();
  return exit.difference(orderTicketModel.createdAt!).inDays + 1;
}

int getMinutes(OrderTicketModel orderTicketModel) {
  DateTime exit = orderTicketModel.exitAt ?? DateTime.now();
  return exit.difference(orderTicketModel.createdAt!).inMinutes;
}

double getTotalPrice(OrderTicketModel orderTicketModel) {
  double price = orderTicketModel.price!;
  if (orderTicketModel.valueType == TypeChargeEnum.fix.type) {
    return price;
  }
  if (orderTicketModel.valueType == TypeChargeEnum.day.type) {
    return price * getDay(orderTicketModel);
  }
  double value = price / 60;
  int minutes = getMinutes(orderTicketModel);

  return (value * minutes).ceilToDouble();
}
