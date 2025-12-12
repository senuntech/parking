import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_ds/core/ui/organisms/one_app_bar.dart';
import 'package:one_ds/core/ui/organisms/one_body.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/core/utils/validator.dart';
import 'package:parking/src/module/category/controller/category_controller.dart';
import 'package:parking/src/module/category/model/category_model.dart';
import 'package:provider/provider.dart';

class CategoryAddView extends StatefulWidget {
  const CategoryAddView({super.key, required this.vehicle});
  final VehicleEnum vehicle;

  @override
  State<CategoryAddView> createState() => _CategoryAddViewState();
}

class _CategoryAddViewState extends State<CategoryAddView> {
  final formKey = GlobalKey<FormState>();
  late CategoryController categoryController;
  CategoryModel categoryModel = CategoryModel();
  final singlePriceController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final dayPriceController = TextEditingController();
  final numberOfVacanciesController = TextEditingController();

  @override
  void initState() {
    categoryController = context.read<CategoryController>();
    WidgetsBinding.instance.addPostFrameCallback((_) => onInit());
    super.initState();
  }

  void onSave() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    categoryController
      ..addCategory(categoryModel)
      ..getCategories();
    Navigator.pop(context, true);
  }

  void onInit() {
    categoryModel = categoryController.categories.firstWhere(
      (element) => element.id == widget.vehicle.id,
    );
    singlePriceController.text = UtilBrasilFields.obterReal(
      categoryModel.singlePrice ?? 0,
    );
    hourlyRateController.text = UtilBrasilFields.obterReal(
      categoryModel.hourlyRate ?? 0,
    );
    dayPriceController.text = UtilBrasilFields.obterReal(
      categoryModel.dayPrice ?? 0,
    );
    numberOfVacanciesController.text =
        categoryModel.numberOfVacancies?.toString() ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: widget.vehicle.name,
        context: context,
        subtitle: 'Gerencie seus preços',
      ),
      body: OneBody(
        child: Form(
          key: formKey,
          child: OneCard(
            title: 'Informações do Estacionamento',
            children: [
              OneInput(
                hintText: 'Ex: R\$ 10,00',
                icon: LucideIcons.banknoteArrowDown,
                label: 'Valor Fixo',
                keyboardType: TextInputType.number,
                controller: singlePriceController,
                validator: validatorRequired,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(moeda: true),
                ],
                onSaved: (value) {
                  categoryModel = categoryModel.copyWith(
                    singlePrice: UtilBrasilFields.converterMoedaParaDouble(
                      value ?? '0',
                    ),
                  );
                },
              ),
              OneInput(
                hintText: 'Ex: R\$ 10,00',
                icon: LucideIcons.dollarSign,
                label: 'Valor Por Hora',
                keyboardType: TextInputType.number,
                controller: hourlyRateController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(moeda: true),
                ],
                onSaved: (value) {
                  if (value!.isEmpty) {
                    return;
                  }
                  categoryModel = categoryModel.copyWith(
                    hourlyRate: UtilBrasilFields.converterMoedaParaDouble(
                      value,
                    ),
                  );
                },
              ),
              OneInput(
                hintText: 'Ex: R\$ 10,00',
                icon: LucideIcons.banknote,
                label: 'Valor Por Dia',
                keyboardType: TextInputType.number,
                controller: dayPriceController,
                onSaved: (value) {
                  if (value!.isEmpty) {
                    return;
                  }
                  categoryModel = categoryModel.copyWith(
                    dayPrice: UtilBrasilFields.converterMoedaParaDouble(value),
                  );
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(moeda: true),
                ],
              ),

              OneInput(
                hintText: 'Ex: 10',
                icon: LucideIcons.octagonMinus,
                label: 'Quantidade De Vagas',
                keyboardType: TextInputType.number,
                controller: numberOfVacanciesController,
                validator: validatorRequired,
                onSaved: (value) {
                  if (value!.isEmpty) {
                    return;
                  }
                  categoryModel = categoryModel.copyWith(
                    numberOfVacancies: int.parse(value),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onSave,
        icon: Icon(LucideIcons.save),
        label: OneText('Salvar'),
      ),
    );
  }
}
