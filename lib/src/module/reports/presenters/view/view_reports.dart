import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:one_ds/one_ds.dart';
import 'package:parking/core/extension/date_timer.dart';
import 'package:parking/core/extension/string_extension.dart';
import 'package:parking/src/module/reports/presenters/controller/reports_controller.dart';
import 'package:parking/src/module/reports/utils/get_pdf.dart';
import 'package:parking/src/module/settings/controller/settings_controller.dart';
import 'package:parking/src/module/settings/model/settings_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class ViewReports extends StatefulWidget {
  const ViewReports({super.key, required this.listDates});
  final List<DateTime> listDates;

  @override
  State<ViewReports> createState() => _ViewReportsState();
}

String freeText = """
 Esta é a versão gratuita do Gertor Transportes. Assine o plano premium e tenha acesso ilimitado a todas as funcionalidades!
  """;

class _ViewReportsState extends State<ViewReports> {
  late ReportsController controller;
  late SettingsController settingsController;
  late SettingsModel settingsModel;
  //late PurchaseApp publisherApp;

  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

  @override
  void initState() {
    controller = context.read<ReportsController>();
    settingsController = context.read<SettingsController>();
    //publisherApp = context.read<PurchaseApp>();
    settingsModel = settingsController.settingsModel;
    super.initState();
  }

  Future<Uint8List> _generatePdf() async {
    pw.MemoryImage? logo;
    const double fontSize10 = 10.0;
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    final img = settingsModel.image_path;
    if (img != null) {
      final image = File(img);
      logo = pw.MemoryImage(image.readAsBytesSync());
    }

    contentHeader(context) {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      settingsModel.name.orEmpty,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '${settingsModel.phone.orEmpty} | CPF/CNPJ: ${settingsModel.document.orEmpty}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      settingsModel.text_receipt.orEmpty,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                if (logo != null) pw.Center(child: pw.Image(logo, height: 60)),
              ],
            ),
            pw.SizedBox(height: 20),

            pw.Text(
              'Relatório: ${widget.listDates.first.formatedDate} à ${widget.listDates.last.formatedDate}',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
          ],
        ),
      );
    }

    contentResume(context) {
      return [
        pw.SizedBox(height: 15),
        pw.Align(
          child: pw.Text(
            'Valor Total:${UtilBrasilFields.obterReal(controller.getTotal)} ',
            style: pw.TextStyle(
              fontSize: fontSize10,
              fontWeight: pw.FontWeight.bold,
            ),
            textAlign: pw.TextAlign.center,
          ),
          alignment: pw.Alignment.centerRight,
        ),

        pw.SizedBox(height: 50),
        /* if (!publisherApp.isPurchased) ...[
          pw.Text(
            freeText,
            style: const pw.TextStyle(fontSize: fontSize10),
            textAlign: pw.TextAlign.center,
          ),

          pw.SizedBox(height: 50),
        ], */
      ];
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        footer: (context) {
          return pw.Text(
            'Criado em ${DateTime.now().formated}',
            style: pw.TextStyle(fontSize: 8),
          );
        },
        build: (context) {
          return [
            contentHeader(context),
            tableReports(controller.listOrder),
            ...contentResume(context),
          ];
        },
      ),
    );

    return await pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'PDF',
        subtitle: 'Compartilhe ou Imprima',
        context: context,
        actions: [
          OneMiniButton(
            icon: LucideIcons.printer,

            onPressed: () async {
              await Printing.layoutPdf(
                onLayout: (format) async => await _generatePdf(),
              );
            },
          ),
          OneMiniButton(
            icon: LucideIcons.share2,
            color: OneColors.success,
            onPressed: () async {
              await Printing.sharePdf(
                bytes: await _generatePdf(),
                filename: 'Relatório-${DateTime.now().date}.pdf',
              );
            },
          ),
        ],
      ),
      body: Consumer<ReportsController>(
        builder: (context, value, child) {
          return PdfPreview(
            useActions: false,
            build: (format) async => await _generatePdf(),
            scrollViewDecoration: BoxDecoration(color: Colors.grey.shade200),
            pdfPreviewPageDecoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: const Offset(2, 2),
                  blurRadius: 5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
