import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart' show LucideIcons;

enum VehicleEnum {
  motorcycle(id: 1, name: 'Moto', icon: LucideIcons.motorbike),
  car(id: 2, name: 'Carro', icon: LucideIcons.car),
  truck(id: 3, name: 'Pesado', icon: LucideIcons.truck);

  const VehicleEnum({required this.id, required this.name, required this.icon});

  final int id;
  final String name;
  final IconData icon;
}
