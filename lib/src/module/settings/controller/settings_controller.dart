// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:parking/src/module/settings/model/settings_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

class SettingsController extends ChangeNotifier {
  SettingsModel settingsModel = SettingsModel();
  final BriteDatabase briteDb;
  SettingsController({required this.briteDb});

  void save() {}
}
