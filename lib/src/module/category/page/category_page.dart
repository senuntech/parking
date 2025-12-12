import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/src/module/category/page/category_add_view.dart';
import 'package:parking/src/module/category/widgets/item_category.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  void addCategory(VehicleEnum vehicle) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryAddView(vehicle: vehicle),
      ),
    );
    if (res == true) {
      ShowSnakBar.show(
        context,
        message: 'Cadastrado com sucesso',
        type: .success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'Preços',
        context: context,
        subtitle: 'Gerencie seus preços',
      ),
      body: OneBody(
        child: Column(
          crossAxisAlignment: .stretch,

          children: [
            OneCard(
              title: 'Tabela de Preços',
              children: [
                ItemCategory(
                  icon: LucideIcons.motorbike,
                  label: VehicleEnum.motorcycle.name,
                  onTap: () => addCategory(VehicleEnum.motorcycle),
                ),
                ItemCategory(
                  icon: LucideIcons.carFront,
                  label: VehicleEnum.car.name,
                  onTap: () => addCategory(VehicleEnum.car),
                ),
                ItemCategory(
                  icon: LucideIcons.truck,
                  label: VehicleEnum.truck.name,
                  onTap: () => addCategory(VehicleEnum.truck),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
