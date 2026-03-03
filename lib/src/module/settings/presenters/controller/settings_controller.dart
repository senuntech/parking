// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:parking/src/module/settings/data/model/settings_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

class SettingsController extends ChangeNotifier {
  SettingsModel settingsModel = SettingsModel();
  final BriteDatabase briteDb;
  SettingsController({required this.briteDb});
  int typePix = 0;

  void setPix(int type) {
    typePix = type;
    notifyListeners();
  }

  Future<void> save() async {
    settingsModel = settingsModel.copyWith(type_pix: typePix);
    if (settingsModel.id == null) {
      await briteDb.insert('settings', settingsModel.toMap());
      return;
    }

    await briteDb.update(
      'settings',
      settingsModel.toMap(),
      where: 'id=${settingsModel.id}',
    );
  }

  Future<void> get() async {
    final res = await briteDb.query('settings');
    if (res.isNotEmpty) {
      settingsModel = SettingsModel.fromMap(res.first);
      typePix = settingsModel.type_pix ?? 0;
    }
  }
}
