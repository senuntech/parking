import 'package:flutter/material.dart';
import 'package:parking/core/analytics/analytics_service.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/src/module/category/data/model/category_model.dart';
import 'package:parking/src/module/category/data/model/vehicle_period_model.dart';
import 'package:parking/src/utils/vehicle_utils.dart';
import 'package:sqlbrite/sqlbrite.dart';

class CategoryController extends ChangeNotifier {
  final BriteDatabase briteDb;

  CategoryController({required this.briteDb});
  List<CategoryModel> categories = [];

  Future<void> addCategory(CategoryModel category) async {
    final map = category.toJson()..remove('periods');
    await briteDb.update(
      'vehicles',
      map,
      where: 'id=${category.id}',
    );
    
    await briteDb.delete('vehicle_periods', where: 'vehicle_id=${category.id}');
    if (category.periods != null) {
      for (var p in category.periods!) {
        final pMap = p.toJson()..remove('id')..['vehicle_id'] = category.id;
        await briteDb.insert('vehicle_periods', pMap);
      }
    }

    getCategories();
    notifyListeners();

    final vehicleName = VehicleEnum.values
        .firstWhere(
          (v) => v.id == category.id,
          orElse: () => VehicleEnum.car,
        )
        .name;

    AnalyticsService.instance.logCategoriaAtualizada(
      tipoVeiculo: vehicleName,
      tipoCobranca: '${category.typeOfBilling ?? 1}',
      valor: category.singlePrice ??
          category.hourlyRate ??
          category.dayPrice ??
          0.0,
    );
  }

  Future<void> getCategories() async {
    final res = await briteDb.query('vehicles');
    categories = res.map((e) => CategoryModel.fromJson(e)).toList();
    
    final resPeriods = await briteDb.query('vehicle_periods');
    globalPeriodsCache.clear();
    for (var p in resPeriods) {
      var period = VehiclePeriodModel.fromJson(p);
      if (period.vehicleId != null) {
        globalPeriodsCache.putIfAbsent(period.vehicleId!, () => []).add(period);
      }
    }
    
    for (var category in categories) {
      category.periods = globalPeriodsCache[category.id];
    }

    notifyListeners();
  }

  int length() {
    int total = categories.fold(
      0,
      (previousValue, element) => previousValue + element.numberOfVacancies!,
    );
    return total;
  }
}
