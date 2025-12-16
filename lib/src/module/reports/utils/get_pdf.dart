import 'package:brasil_fields/brasil_fields.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/core/extension/date_timer.dart';
import 'package:parking/src/module/ticket/data/model/order_ticket_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const tableHeaders = [
  'Modelo',
  'Placa',
  'Entrada',
  'Saída',
  'Tipo',
  'Valor R\$',
];

String typeVehicle(OrderTicketModel orderTicketModel) {
  if (orderTicketModel.typeVehicles == VehicleEnum.motorcycle.id) {
    return 'Moto';
  } else if (orderTicketModel.typeVehicles == VehicleEnum.car.id) {
    return 'Carro';
  } else {
    return 'Pesado';
  }
}

pw.Table tableReports(List<OrderTicketModel> listOrder) {
  return pw.TableHelper.fromTextArray(
    border: null,
    cellStyle: pw.TextStyle(fontSize: 10),
    headers: tableHeaders,
    data: listOrder.map((e) {
      return [
        e.model,
        e.plate,
        e.createdAt?.formated,
        e.exitAt?.formated,
        typeVehicle(e),
        UtilBrasilFields.obterReal(e.price!),
      ];
    }).toList(),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
      fontSize: 10,
    ),
    headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.blue300, width: .8),
      ),
    ),
    cellAlignment: pw.Alignment.centerLeft,
    cellAlignments: {
      3: pw.Alignment.centerLeft,
      4: pw.Alignment.centerLeft,
      5: pw.Alignment.centerRight,
    },
    headerAlignment: pw.Alignment.topLeft,
  );
}
