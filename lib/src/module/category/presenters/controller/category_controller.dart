import 'package:flutter/material.dart';
import 'package:parking/src/module/category/data/model/category_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

class CategoryController extends ChangeNotifier {
  final BriteDatabase briteDb;

  CategoryController({required this.briteDb});
  List<CategoryModel> categories = [];

  Future<void> addCategory(CategoryModel category) async {
    await briteDb.update(
      'vehicles',
      category.toJson(),
      where: 'id=${category.id}',
    );
    getCategories();
    notifyListeners();
  }

  Future<void> getCategories() async {
    final res = await briteDb.query('vehicles');
    categories = res.map((e) => CategoryModel.fromJson(e)).toList();
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
