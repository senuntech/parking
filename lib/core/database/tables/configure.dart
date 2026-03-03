import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/src/module/category/data/model/category_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

Future<void> populateInitialData(final Database db) async {
  final model = CategoryModel(
    id: VehicleEnum.car.id,
    singlePrice: 0.0,
    hourlyRate: 0.0,
    dayPrice: 0.0,
    numberOfVacancies: 1,
  );

  await db.insert('vehicles', model.toJson());
  await db.insert(
    'vehicles',
    model.copyWith(id: VehicleEnum.motorcycle.id).toJson(),
  );
  await db.insert(
    'vehicles',
    model.copyWith(id: VehicleEnum.truck.id).toJson(),
  );
}
