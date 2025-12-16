class OrderTicketModel {
  int? id;
  String? name;
  String? phone;
  String? document;
  int? typeVehicles;
  String? model;
  String? plate;
  int? valueType;
  DateTime? createdAt;
  DateTime? exitAt;
  String? code;
  double? price;
  int? paymentMethod;

  OrderTicketModel({
    this.id,
    this.name,
    this.phone,
    this.document,
    this.typeVehicles,
    this.model,
    this.plate,
    this.valueType,
    this.createdAt,
    this.exitAt,
    this.code,
    this.price,
    this.paymentMethod,
  });

  factory OrderTicketModel.fromMap(Map<String, dynamic> map) {
    return OrderTicketModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      document: map['document'],
      typeVehicles: map['type_vehicles'],
      model: map['model'],
      plate: map['plate'],
      valueType: map['value_type'],
      createdAt: map['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
          : null,
      exitAt: map['exit_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['exit_at'] as int)
          : null,
      code: map['code'],
      price: map['price'],
      paymentMethod: map['payment_method'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'document': document,
      'type_vehicles': typeVehicles,
      'model': model,
      'plate': plate,
      'value_type': valueType,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'exit_at': exitAt?.millisecondsSinceEpoch,
      'code': code,
      'price': price,
      'payment_method': paymentMethod,
    };
  }

  OrderTicketModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? d,
    int? typeVehicles,
    String? model,
    String? plate,
    int? valueType,
    DateTime? createdAt,
    DateTime? exitAt,
    String? document,
    String? code,
    double? price,
    int? paymentMethod,
  }) {
    return OrderTicketModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      document: document ?? this.document,
      typeVehicles: typeVehicles ?? this.typeVehicles,
      model: model ?? this.model,
      plate: plate ?? this.plate,
      valueType: valueType ?? this.valueType,
      createdAt: createdAt ?? this.createdAt,
      exitAt: exitAt ?? this.exitAt,
      code: code ?? this.code,
      price: price ?? this.price,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
