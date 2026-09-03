import 'package:parking/src/module/category/data/model/vehicle_period_model.dart';

class CategoryModel {
  int? id;
  double? singlePrice;
  double? hourlyRate;
  double? dayPrice;
  int? numberOfVacancies;
  List<VehiclePeriodModel>? periods;
  int? typeOfBilling;

  CategoryModel({
    this.id,
    this.singlePrice,
    this.hourlyRate,
    this.dayPrice,
    this.numberOfVacancies,
    this.periods,
    this.typeOfBilling,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'],
    singlePrice: json['single_price'],
    hourlyRate: json['hourly_rate'],
    dayPrice: json['day_price'],
    numberOfVacancies: json['number_of_vacancies'],
    periods: json['periods'] != null
        ? List<VehiclePeriodModel>.from(
            json['periods'].map((x) => VehiclePeriodModel.fromJson(x)))
        : null,
    typeOfBilling: json['type_of_billing'] ?? 1,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'single_price': singlePrice,
    'hourly_rate': hourlyRate,
    'day_price': dayPrice,
    'number_of_vacancies': numberOfVacancies,
    'periods': periods?.map((x) => x.toJson()).toList(),
    'type_of_billing': typeOfBilling,
  };

  CategoryModel copyWith({
    int? id,
    double? singlePrice,
    double? hourlyRate,
    double? dayPrice,
    int? numberOfVacancies,
    List<VehiclePeriodModel>? periods,
    int? typeOfBilling,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      singlePrice: singlePrice ?? this.singlePrice,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      dayPrice: dayPrice ?? this.dayPrice,
      numberOfVacancies: numberOfVacancies ?? this.numberOfVacancies,
      periods: periods ?? this.periods,
      typeOfBilling: typeOfBilling ?? this.typeOfBilling,
    );
  }
}
