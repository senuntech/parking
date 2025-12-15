import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_ds/core/index.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/type_pix_enum.dart';
import 'package:parking/core/utils/validator.dart';
import 'package:parking/src/module/settings/controller/settings_controller.dart';
import 'package:parking/src/module/settings/widget/select_pix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? image;
  final ScrollController scrollController = ScrollController();
  final GlobalKey keyScrollPix = GlobalKey();
  bool showPix = false;
  bool showButton = false;
  late SettingsController settingsController;
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  final myPixController = TextEditingController();
  TextInputType typeBoard = TextInputType.emailAddress;

  void getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (image != null) {
      final path = await saveImageInternally(File(image.path));
      settingsController.settingsModel.image_path = path;
      setState(() {
        this.image = File(image.path);
      });
    }
  }

  Future<String> saveImageInternally(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final newPath = '${dir.path}/logo.png';
    final newFile = await image.copy(newPath);
    return newFile.path;
  }

  @override
  void initState() {
    super.initState();
    settingsController = context.read<SettingsController>();
    showPix = settingsController.settingsModel.show_pix ?? false;
    if (settingsController.settingsModel.image_path != null) {
      image = File(settingsController.settingsModel.image_path!);
    }

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
  }

  void onSave() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    settingsController.settingsModel.show_pix = showPix;
    await settingsController.save();
    Navigator.pop(context);
  }

  List<TextInputFormatter>? get formatted {
    List<TextInputFormatter> list = [FilteringTextInputFormatter.digitsOnly];

    int? currentType = settingsController.settingsModel.type_pix;

    if (currentType == TypePixEnum.email.type) {
      list.clear();
    }
    if (currentType == TypePixEnum.cpf.type) {
      list.add(CpfInputFormatter());
    }
    if (currentType == TypePixEnum.cnpj.type) {
      list.add(CnpjInputFormatter());
    }
    if (currentType == TypePixEnum.telefone.type) {
      list.add(TelefoneInputFormatter());
    }

    return list;
  }

  void onChanged(int? value) async {
    if (value != settingsController.settingsModel.type_pix) {
      formKey.currentState?.reset();
      myPixController.clear();

      settingsController.settingsModel.type_pix = null;
      focusNode.unfocus();
    }

    setState(() {
      settingsController.settingsModel.type_pix = value;
      typeBoard = getTypeKeyBoard;
    });
    await Future.delayed(Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  TextInputType get getTypeKeyBoard {
    int? currentType = settingsController.settingsModel.type_pix;
    switch (currentType) {
      case 1:
        return TextInputType.emailAddress;
      default:
        return TextInputType.number;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'Configurações',
        subtitle: 'Configurações do estabelecimento',
        context: context,
        actions: [
          OneMiniButton(icon: LucideIcons.databaseBackup, onPressed: () {}),
        ],
      ),
      body: OneBody(
        scrollController: scrollController,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: OneSizeConstants.size16,
            children: [
              OneCard(
                title: 'Adicione Logo',
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      OneSelectImage(image: image),
                      Column(
                        spacing: 16,
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        children: [
                          OneButton(
                            label: 'Selecionar Logo',
                            onPressed: getImage,
                          ),
                          OneText.caption('Selecionar uma imagem\nde até 1mb'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              OneCard(
                title: 'Informações da Empresa',
                children: [
                  OneInput(
                    hintText: 'Nome da Empresa',
                    icon: LucideIcons.building,
                    initialValue: settingsController.settingsModel.name,
                    label: 'Nome da Empresa',
                    validator: validatorRequired,
                    onSaved: (value) =>
                        settingsController.settingsModel.name = value,
                  ),
                  OneInput(
                    hintText: 'CNPJ',
                    icon: LucideIcons.dock,
                    label: 'CNPJ',
                    initialValue: settingsController.settingsModel.document,
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        settingsController.settingsModel.document = value,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CnpjInputFormatter(),
                    ],
                  ),
                  OneInput(
                    hintText: 'Digite o telefone',
                    icon: LucideIcons.phone,
                    initialValue: settingsController.settingsModel.phone,
                    onSaved: (value) =>
                        settingsController.settingsModel.phone = value,
                    label: 'Telefone',
                    validator: validatorRequired,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                  ),
                ],
              ),

              OneCard(
                title: 'Informações do PIX',
                children: [
                  OneListTileSelect(
                    title: 'Adicionar QrCode PIX',
                    subtitle: 'Sempre confirme o recebimento do PIX',
                    selected: showPix,
                    onChanged: (value) {
                      setState(() {
                        showPix = !showPix;
                      });
                    },
                  ),
                  if (showPix) ...[
                    SelectPix(onChanged: onChanged),
                    OneInput(
                      label: 'PIX',
                      hintText: 'Digite seu Pix',
                      icon: LucideIcons.circleDollarSign,
                      validator: validatorRequired,
                      initialValue: settingsController.settingsModel.my_pix,
                      onSaved: (value) =>
                          settingsController.settingsModel.my_pix = value,
                      inputFormatters: formatted,
                      focusNode: focusNode,
                      keyboardType: typeBoard,
                    ),
                  ],
                ],
              ),

              OneCard(
                title: 'Texto do Rodapé',
                children: [
                  OneInput(
                    hintText: 'Ex: Não nos responsabilizamos por itens',
                    icon: LucideIcons.textInitial,
                    label: 'Texto',
                    initialValue: settingsController.settingsModel.text_receipt,
                    onSaved: (value) {
                      settingsController.settingsModel.text_receipt = value;
                    },
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
              onPressed: onSave,
              label: OneText('Salvar Configurações'),
              icon: Icon(LucideIcons.check),
            )
          : null,
    );
  }
}
