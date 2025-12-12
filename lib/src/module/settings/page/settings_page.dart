import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_ds/core/index.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/src/module/settings/widget/select_pix.dart';
import 'package:path_provider/path_provider.dart';

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

  void getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (image != null) {
      final path = await saveImageInternally(File(image.path));
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
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: OneSizeConstants.size16,
            children: [
              OneCard(
                title: 'Adicione seu logo',
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
                    label: 'Nome da Empresa',
                  ),
                  OneInput(
                    hintText: 'CNPJ',
                    icon: LucideIcons.dock,
                    label: 'CNPJ',

                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CnpjInputFormatter(),
                    ],
                  ),
                  OneInput(
                    hintText: 'Digite o telefone',
                    icon: LucideIcons.phone,
                    label: 'Telefone',

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
                    SelectPix(),
                    OneInput(
                      label: 'PIX',
                      hintText: 'Digite seu Pix',
                      icon: LucideIcons.circleDollarSign,
                    ),
                  ],
                ],
              ),

              OneCard(
                title: 'Informações do Estacionamento',
                children: [
                  OneInput(
                    hintText: 'Ex: R\$ 10,00',
                    icon: LucideIcons.banknoteArrowDown,
                    label: 'Valor Único',
                    keyboardType: TextInputType.number,
                    inputFormatters: [],
                  ),
                  OneInput(
                    hintText: 'Ex: R\$ 10,00',
                    icon: LucideIcons.dollarSign,
                    label: 'Valor Por Hora',
                    keyboardType: TextInputType.number,
                    inputFormatters: [],
                  ),
                  OneInput(
                    hintText: 'Ex: R\$ 10,00',
                    icon: LucideIcons.banknote,
                    label: 'Valor Por Dia',
                    keyboardType: TextInputType.number,
                    inputFormatters: [],
                  ),

                  OneInput(
                    hintText: 'Ex: 10',
                    icon: LucideIcons.octagonMinus,
                    label: 'Quantidade De Vagas',
                    keyboardType: TextInputType.number,
                    inputFormatters: [],
                  ),
                ],
              ),
              OneCard(
                title: 'Texto do Rodapé',
                children: [
                  OneInput(
                    hintText: 'Ex: Não nos responsabilizamos por itens',
                    icon: LucideIcons.textInitial,
                    label: 'Texto',
                    inputFormatters: [],
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
              onPressed: () {},
              label: OneText('Salvar Configurações'),
              icon: Icon(LucideIcons.check),
            )
          : null,
    );
  }
}
