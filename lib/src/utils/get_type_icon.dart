import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/vehicle_enum.dart';

IconData icon(int type) {
  if (type == VehicleEnum.car.id) {
    return LucideIcons.car;
  } else if (type == VehicleEnum.motorcycle.id) {
    return LucideIcons.motorbike;
  } else {
    return LucideIcons.truck;
  }
}
