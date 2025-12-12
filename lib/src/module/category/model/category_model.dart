class CategoryModel {
  int? id;
  double? singlePrice;
  double? hourlyRate;
  double? dayPrice;
  int? numberOfVacancies;

  CategoryModel({
    this.id,
    this.singlePrice,
    this.hourlyRate,
    this.dayPrice,
    this.numberOfVacancies,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'],
    singlePrice: json['single_price'],
    hourlyRate: json['hourly_rate'],
    dayPrice: json['day_price'],
    numberOfVacancies: json['number_of_vacancies'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'single_price': singlePrice,
    'hourly_rate': hourlyRate,
    'day_price': dayPrice,
    'number_of_vacancies': numberOfVacancies,
  };

  CategoryModel copyWith({
    int? id,
    double? singlePrice,
    double? hourlyRate,
    double? dayPrice,
    int? numberOfVacancies,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      singlePrice: singlePrice ?? this.singlePrice,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      dayPrice: dayPrice ?? this.dayPrice,
      numberOfVacancies: numberOfVacancies ?? this.numberOfVacancies,
    );
  }
}
