enum VehicleEnum {
  motorcycle(id: 1, name: 'Moto'),
  car(id: 2, name: 'Carro'),
  truck(id: 3, name: 'Pesado');

  const VehicleEnum({required this.id, required this.name});

  final int id;
  final String name;
}
