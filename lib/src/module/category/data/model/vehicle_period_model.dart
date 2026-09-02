class VehiclePeriodModel {
  int? id;
  int? vehicleId;
  int? startMinute;
  int? endMinute;
  double? price;
  bool? isAdditional;

  VehiclePeriodModel({
    this.id,
    this.vehicleId,
    this.startMinute,
    this.endMinute,
    this.price,
    this.isAdditional,
  });

  factory VehiclePeriodModel.fromJson(Map<String, dynamic> json) => VehiclePeriodModel(
    id: json['id'],
    vehicleId: json['vehicle_id'],
    startMinute: json['start_minute'],
    endMinute: json['end_minute'],
    price: json['price'],
    isAdditional: json['is_additional'] == 1,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'vehicle_id': vehicleId,
    'start_minute': startMinute,
    'end_minute': endMinute,
    'price': price,
    'is_additional': isAdditional == true ? 1 : 0,
  };

  VehiclePeriodModel copyWith({
    int? id,
    int? vehicleId,
    int? startMinute,
    int? endMinute,
    double? price,
    bool? isAdditional,
  }) {
    return VehiclePeriodModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      price: price ?? this.price,
      isAdditional: isAdditional ?? this.isAdditional,
    );
  }
}
