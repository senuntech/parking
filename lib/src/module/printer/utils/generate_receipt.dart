import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' show decodeImage;
import 'package:image_halftone/image_halftone.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/extension/string_extension.dart';
import 'package:parking/core/utils/get_pix.dart' show getPix;
import 'package:parking/src/module/settings/data/model/settings_model.dart';
import 'package:parking/src/module/ticket/data/model/order_ticket_model.dart';
import 'package:parking/src/utils/vehicle_utils.dart';

Future<List<int>> printerReceipit(
  SettingsModel settings,
  OrderTicketModel order,
  bool isPurchase,
) async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  List<int> bytes = [];

  if (settings.image_path != null) {
    final img = File(settings.image_path!);
    final imageFilter = await convertImageToHalftoneBlackAndWhite(img);
    final imgs = decodeImage(imageFilter!);
    bytes += generator.imageRaster(imgs!, imageFn: PosImageFn.bitImageRaster);
  }

  bytes += generator.text(
    settings.name.removeDiacritic,
    styles: PosStyles(
      align: .center,
      height: .size2,
      bold: true,
      fontType: .fontA,
    ),
  );
  bytes += generator.text(
    '${settings.phone.removeDiacritic} | ${settings.document.removeDiacritic}',
    styles: PosStyles(align: .center, height: .size1, fontType: .fontB),
  );
  bytes += generator.feed(1);
  bytes += generator.text(
    order.exitAt != null ? 'SAIDA' : 'ENTRADA',
    styles: PosStyles(
      align: .center,
      width: .size2,
      bold: true,
      height: .size2,
      fontType: .fontA,
    ),
  );
  bytes += generator.text(
    getDate(order),
    styles: PosStyles(align: .center, height: .size1, fontType: .fontB),
  );

  bytes += generator.text(
    getVehicle(order.typeVehicles!).name,
    styles: PosStyles(
      align: .center,
      height: .size1,
      fontType: .fontB,
      bold: false,
    ),
  );
  bytes += generator.text(
    '${order.model.removeDiacritic.orEmpty} - ${order.plate.removeDiacritic.orEmpty}',
    styles: PosStyles(
      align: .center,
      height: .size1,
      fontType: .fontB,
      bold: false,
    ),
  );

  if (order.name != null) {
    bytes += generator.text(
      order.name.orEmpty,
      styles: PosStyles(align: .center, height: .size1),
    );
  }

  bytes += generator.feed(1);
  if (order.exitAt == null) {
    final List<int> barData = order.code!
        .split('')
        .map((e) => int.parse(e))
        .toList();
    bytes += generator.barcode(Barcode.code128(barData));
  }
  if (order.exitAt != null) {
    bytes += generator.text(
      UtilBrasilFields.obterReal(getTotal(order)),
      styles: PosStyles(align: .center, bold: true, fontType: .fontA),
    );
  }
  if ((settings.show_pix ?? false) && (order.exitAt != null)) {
    bytes += generator.qrcode(
      getPix(
        type: settings.type_pix!,
        pix: settings.my_pix!,
        value: order.price ?? 0,
      ),
    );
    bytes += generator.feed(1);

    bytes += generator.text(
      'Pague com Pix',
      styles: PosStyles(align: .center, height: .size1, fontType: .fontB),
    );
  }

  bytes += generator.text(
    settings.text_receipt.removeDiacritic,
    styles: PosStyles(align: .center, height: .size1, fontType: .fontB),
  );

  /*  if (!isPurchase) {
    bytes += generator.feed(1);
    bytes += generator.text(
      ' settings.free_text.removeDiacritic',
      styles: PosStyles(align: .center, height: .size1, fontType: .fontB),
    );
  } */

  bytes += generator.cut();
  return bytes;
}
