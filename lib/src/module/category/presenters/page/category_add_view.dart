import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_ds/core/ui/organisms/one_app_bar.dart';
import 'package:one_ds/core/ui/organisms/one_body.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/core/utils/validator.dart';
import 'package:parking/src/module/category/presenters/controller/category_controller.dart';
import 'package:parking/src/module/category/data/model/category_model.dart';
import 'package:parking/src/module/category/data/model/vehicle_period_model.dart';
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
  List<VehiclePeriodModel> periods = [];

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
    categoryModel.periods = periods;
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
    setState(() {
      periods = List.from(categoryModel.periods ?? []);
    });
  }

  void _showAddPeriodDialog() {
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    bool isAdditional = false;

    OneBottomSheet.show(
      context: context,
      title: "Adicionar Período",
      content: [
        StatefulBuilder(
          builder: (context, setStateDialog) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              spacing: OneSizeConstants.size16,
              children: [
                OneListTileSelect(
                  title: 'É hora adicional?',
                  subtitle: 'Selecione para adicionar hora adicional',
                  selected: isAdditional,
                  onChanged: (v) => setStateDialog(() => isAdditional = v),
                ),
                if (!isAdditional) ...[
                  OneInput(
                    controller: startCtrl,
                    keyboardType: TextInputType.number,
                    hintText: 'Ex: 0',
                    label: 'Minuto Inicial',
                  ),
                  OneInput(
                    controller: endCtrl,
                    keyboardType: TextInputType.number,
                    hintText: 'Ex: 30',
                    label: 'Minuto Final',
                  ),
                ],
                OneInput(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  hintText: 'Ex: R\$ 10,00',
                  label: 'Preço (R\$)',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true),
                  ],
                ),

                Row(
                  spacing: OneSizeConstants.size16,
                  children: [
                    Expanded(
                      child: OneButton(
                        label: 'Cancelar',
                        style: OneButtonStyle.gost,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: OneButton(
                        label: 'Adicionar',
                        onPressed: () {
                          final priceStr = priceCtrl.text.isEmpty
                              ? '0'
                              : priceCtrl.text;
                          final price =
                              UtilBrasilFields.converterMoedaParaDouble(
                                priceStr,
                              );
                          setState(() {
                            periods.add(
                              VehiclePeriodModel(
                                startMinute: isAdditional
                                    ? null
                                    : int.tryParse(startCtrl.text),
                                endMinute: isAdditional
                                    ? null
                                    : int.tryParse(endCtrl.text),
                                price: price,
                                isAdditional: isAdditional,
                              ),
                            );
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
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
          child: Column(
            spacing: 16,
            crossAxisAlignment: .stretch,
            children: [
              OneCard(
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
                        dayPrice: UtilBrasilFields.converterMoedaParaDouble(
                          value,
                        ),
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

              OneCard(
                title: 'Tabela de Períodos',
                children: [
                  if (periods.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Nenhum período configurado'),
                    ),
                  ...periods.map(
                    (p) => OneListTile(
                      title: (p.isAdditional == true
                          ? 'Hora Adicional'
                          : 'De ${p.startMinute} a ${p.endMinute} min'),
                      children: [
                        OneText.caption(
                          'R\$ ${UtilBrasilFields.obterReal(p.price ?? 0)}',
                        ),
                      ],
                      actions: [
                        OneMiniButton(
                          icon: LucideIcons.trash2,
                          color: OneColors.error,
                          onPressed: () {
                            setState(() {
                              periods.remove(p);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Período'),
                    onPressed: _showAddPeriodDialog,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onSave,
        icon: Icon(LucideIcons.save),
        label: Text('Salvar'),
      ),
    );
  }
}
