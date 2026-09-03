import 'package:one_ds/core/extension/date_timer.dart';
import 'package:one_ds/core/extension/double_extension.dart';
import 'package:parking/core/enum/type_charge_enum.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/src/module/category/data/model/vehicle_period_model.dart';
import 'package:parking/src/module/ticket/data/model/order_ticket_model.dart';

Map<int, List<VehiclePeriodModel>> globalPeriodsCache = {};

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
  if (orderTicketModel.valueType == TypeChargeEnum.period.type) {
    List<VehiclePeriodModel> periods = globalPeriodsCache[orderTicketModel.typeVehicles] ?? [];
    if (periods.isEmpty) return 0.0;
    
    int minutes = getMinutes(orderTicketModel);
    var sortedPeriods = List<VehiclePeriodModel>.from(periods)
      ..sort((a, b) => (a.startMinute ?? 0).compareTo(b.startMinute ?? 0));
      
    var additionalPeriod = sortedPeriods.firstWhere((p) => p.isAdditional == true, orElse: () => VehiclePeriodModel());
    var fixedPeriods = sortedPeriods.where((p) => p.isAdditional != true).toList();
    
    double calculatedPrice = 0.0;
    bool foundFixed = false;
    
    for (var p in fixedPeriods) {
      int start = p.startMinute ?? 0;
      int end = p.endMinute ?? 999999;
      if (minutes >= start && minutes <= end) {
        calculatedPrice = p.price ?? 0.0;
        foundFixed = true;
        break;
      }
    }
    
    if (!foundFixed) {
       if (fixedPeriods.isNotEmpty) {
         var maxPeriod = fixedPeriods.last;
         calculatedPrice = maxPeriod.price ?? 0.0;
         int maxEnd = maxPeriod.endMinute ?? 0;
         if (minutes > maxEnd && additionalPeriod.price != null) {
           int extraMinutes = minutes - maxEnd;
           int addBlock = (additionalPeriod.endMinute ?? 60) - (additionalPeriod.startMinute ?? 0);
           if (addBlock <= 0) addBlock = 60; 
           int fractions = (extraMinutes / addBlock).ceil();
           calculatedPrice += (fractions * additionalPeriod.price!);
         }
       } else if (additionalPeriod.price != null) {
         int addBlock = (additionalPeriod.endMinute ?? 60) - (additionalPeriod.startMinute ?? 0);
         if (addBlock <= 0) addBlock = 60; 
         int fractions = (minutes / addBlock).ceil();
         calculatedPrice = fractions * additionalPeriod.price!;
       }
    }
    
    return calculatedPrice.roundUp;
  }

  double value = price / 60;
  int minutes = getMinutes(orderTicketModel);

  return (value * minutes).roundUp;
}
