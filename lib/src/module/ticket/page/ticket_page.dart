import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_ds/core/index.dart';
import 'package:one_ds/one_ds.dart'
    show
        CpfInputFormatter,
        LucideIcons,
        OneText,
        TelefoneInputFormatter,
        PlacaVeiculoInputFormatter;
import 'package:parking/core/enum/type_charge_enum.dart';

import 'package:parking/core/utils/validator.dart';
import 'package:parking/main.dart';
import 'package:parking/src/module/category/controller/category_controller.dart';
import 'package:parking/src/module/category/model/category_model.dart';
import 'package:parking/src/module/ticket/controller/ticket_controller.dart';
import 'package:parking/src/module/ticket/model/order_ticket_model.dart';
import 'package:provider/provider.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  int valueType = 1;
  int typeVehicles = 2;
  final formKey = GlobalKey<FormState>();
  late TicketController ticketController;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final securityController = TextEditingController();
  final modelController = TextEditingController();
  final plateController = TextEditingController();
  OrderTicketModel orderTicketModel = OrderTicketModel();
  final ScrollController scrollController = ScrollController();

  bool showButton = false;
  CategoryModel? categoryModel;

  void setValue(int? value) {
    setState(() {
      valueType = value ?? 0;
      orderTicketModel.valueType = valueType;
    });
    if (valueType == TypeChargeEnum.fix.type) {
      orderTicketModel.price = categoryModel!.singlePrice!;
    }
    if (valueType == TypeChargeEnum.hour.type) {
      orderTicketModel.price = categoryModel!.hourlyRate!;
    }
    if (valueType == TypeChargeEnum.day.type) {
      orderTicketModel.price = categoryModel!.dayPrice!;
    }
  }

  void setTypeCar(int? value) {
    setState(() {
      typeVehicles = value ?? 0;
      orderTicketModel.typeVehicles = typeVehicles;
    });
    categoryModel = context.read<CategoryController>().categories.firstWhere(
      (element) => element.id == valueType,
    );
    setValue(valueType);
  }

  void onSave() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    if (orderTicketModel.id != null) {
      ticketController.updateTicket(orderTicketModel);
      Navigator.popAndPushNamed(
        context,
        Routes.receipt,
        arguments: orderTicketModel,
      );
      return;
    }
    orderTicketModel = OrderTicketModel(
      valueType: valueType,
      name: nameController.text,
      phone: phoneController.text,
      document: securityController.text,
      model: modelController.text,
      plate: plateController.text,
      typeVehicles: typeVehicles,
      createdAt: DateTime.now(),
      price: orderTicketModel.price,
    );
    ticketController.addTicket(orderTicketModel);
    Navigator.popAndPushNamed(
      context,
      Routes.receipt,
      arguments: orderTicketModel,
    );
  }

  @override
  void initState() {
    super.initState();
    ticketController = context.read<TicketController>();
    categoryModel = context.read<CategoryController>().categories.firstWhere(
      (element) => element.id == typeVehicles,
    );
    orderTicketModel.price = categoryModel!.singlePrice;

    scrollController.addListener(() {
      final noFinal =
          scrollController.position.pixels >=
          scrollController.position.maxScrollExtent;
      if (noFinal && !showButton) {
        setState(() => showButton = true);
      } else if (!noFinal && showButton) {
        setState(() => showButton = false);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => onInit());
  }

  void onInit() {
    final order =
        ModalRoute.of(context)?.settings.arguments as OrderTicketModel?;

    if (order != null) {
      setState(() {
        nameController.text = order.name!;
        phoneController.text = order.phone!;
        securityController.text = order.document!;
        modelController.text = order.model!;
        plateController.text = order.plate!;
        typeVehicles = order.typeVehicles!;
        valueType = order.valueType!;
        orderTicketModel = order;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    securityController.dispose();
    modelController.dispose();
    plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'Entrada',
        context: context,
        subtitle: 'Adicionar veiculo',
      ),
      body: OneBody(
        scrollController: scrollController,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              OneCard(
                title: 'Condutor',
                children: [
                  OneInput(
                    label: 'Responsável',
                    icon: LucideIcons.user,
                    hintText: 'Ex: Paulo',
                    validator: validatorRequired,
                    onSaved: (value) {
                      orderTicketModel.name = value;
                    },
                    controller: nameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚâêîôûÂÊÎÔÛãõÃÕ\s]*$'),
                      ),
                      UpperCaseTextFormatter(),
                    ],
                  ),
                  OneInput(
                    label: 'WhatsApp',
                    icon: LucideIcons.phone,
                    hintText: 'Ex: 11999999999',
                    validator: validatorRequired,
                    onSaved: (value) {
                      orderTicketModel.phone = value;
                    },
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                  ),
                  OneInput(
                    label: 'Segurança',
                    icon: LucideIcons.shieldCheck,
                    hintText: 'CPF do Responsável',
                    validator: validatorRequired,
                    onSaved: (value) {
                      orderTicketModel.document = value;
                    },
                    controller: securityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                  ),
                ],
              ),

              OneCard(
                title: 'Tipo De Veículo',
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: OneSelect(
                          onChanged: setTypeCar,
                          value: 1,
                          label: 'Moto',
                          type: .background,
                          selected: typeVehicles,
                        ),
                      ),
                      Expanded(
                        child: OneSelect(
                          onChanged: setTypeCar,
                          value: 2,
                          label: 'Carro',
                          type: .background,
                          selected: typeVehicles,
                        ),
                      ),
                      Expanded(
                        child: OneSelect(
                          onChanged: setTypeCar,
                          value: 3,
                          label: 'Pesado',
                          type: .background,
                          selected: typeVehicles,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              OneCard(
                title: 'Veículo',
                children: [
                  OneInput(
                    label: 'Modelo',
                    icon: LucideIcons.carFront,
                    hintText: 'Ex: Gol',
                    validator: validatorRequired,
                    onSaved: (value) {
                      orderTicketModel.model = value;
                    },
                    controller: modelController,
                    inputFormatters: [UpperCaseTextFormatter()],
                  ),
                  OneInput(
                    label: 'Placa',
                    icon: LucideIcons.navigation,
                    hintText: 'Ex: XXXX-XXX',
                    validator: validatorRequired,
                    onSaved: (value) {
                      orderTicketModel.plate = value;
                    },
                    controller: plateController,
                    keyboardType: TextInputType.name,
                    inputFormatters: [PlacaVeiculoInputFormatter()],
                  ),
                ],
              ),
              OneCard(
                title: 'Tipo De Cobrança',
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: OneSelect(
                          onChanged: setValue,
                          value: 1,
                          label: 'Fixo',
                          type: .background,
                          selected: valueType,
                        ),
                      ),
                      Expanded(
                        child: OneSelect(
                          onChanged: setValue,
                          value: 2,
                          label: 'Hora',
                          type: .background,
                          selected: valueType,
                        ),
                      ),
                      Expanded(
                        child: OneSelect(
                          onChanged: setValue,
                          value: 3,
                          label: 'Dia',
                          type: .background,
                          selected: valueType,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              OneSize.height128,
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: showButton
          ? FloatingActionButton.extended(
              icon: Icon(LucideIcons.save),
              onPressed: onSave,
              label: OneText('Adicionar Veículo'),
            )
          : null,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formatted = newValue.text
        .split(' ')
        .map((word) {
          if (word.isNotEmpty) {
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          }
          return '';
        })
        .join(' ');

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
