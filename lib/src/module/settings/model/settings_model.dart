// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SettingsModel {
  int? id;
  String? image_path;
  String? name;
  String? document;
  String? phone;
  int? type_pix;
  bool? show_pix;
  String? my_pix;
  int? number_of_vacancies;
  double? hourly_rate;
  double? day_price;
  double? single_price;
  String? text_receipt;
  SettingsModel({
    this.id,
    this.image_path,
    this.name,
    this.document,
    this.phone,
    this.type_pix,
    this.show_pix = false,
    this.my_pix,
    this.number_of_vacancies,
    this.hourly_rate,
    this.day_price,
    this.single_price,
    this.text_receipt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image_path': image_path,
      'name': name,
      'document': document,
      'phone': phone,
      'type_pix': type_pix,
      'show_pix': show_pix! ? 1 : 0,
      'my_pix': my_pix,
      'number_of_vacancies': number_of_vacancies,
      'hourly_rate': hourly_rate,
      'day_price': day_price,
      'single_price': single_price,
      'text_receipt': text_receipt,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      id: map['id'] != null ? map['id'] as int : null,
      image_path: map['image_path'] != null
          ? map['image_path'] as String
          : null,
      name: map['name'] != null ? map['name'] as String : null,
      document: map['document'] != null ? map['document'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      type_pix: map['type_pix'] != null ? map['type_pix'] as int : null,
      show_pix: map['show_pix'] != null ? map['show_pix'] == 1 : null,
      my_pix: map['my_pix'] != null ? map['my_pix'] as String : null,
      number_of_vacancies: map['number_of_vacancies'] != null
          ? map['number_of_vacancies'] as int
          : null,
      hourly_rate: map['hourly_rate'] != null
          ? map['hourly_rate'] as double
          : null,
      day_price: map['day_price'] != null ? map['day_price'] as double : null,
      single_price: map['single_price'] != null
          ? map['single_price'] as double
          : null,
      text_receipt: map['text_receipt'] != null
          ? map['text_receipt'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsModel.fromJson(String source) =>
      SettingsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  SettingsModel copyWith({
    int? id,
    String? image_path,
    String? name,
    String? document,
    String? phone,
    int? type_pix,
    bool? show_pix,
    String? my_pix,
    int? number_of_vacancies,
    double? hourly_rate,
    double? day_price,
    double? single_price,
    String? text_receipt,
  }) {
    return SettingsModel(
      id: id ?? this.id,
      image_path: image_path ?? this.image_path,
      name: name ?? this.name,
      document: document ?? this.document,
      phone: phone ?? this.phone,
      type_pix: type_pix ?? this.type_pix,
      show_pix: show_pix ?? this.show_pix,
      my_pix: my_pix ?? this.my_pix,
      number_of_vacancies: number_of_vacancies ?? this.number_of_vacancies,
      hourly_rate: hourly_rate ?? this.hourly_rate,
      day_price: day_price ?? this.day_price,
      single_price: single_price ?? this.single_price,
      text_receipt: text_receipt ?? this.text_receipt,
    );
  }
}
