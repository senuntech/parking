/* import 'dart:io';


import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' show decodeImage;
import 'package:image_halftone/image_halftone.dart';
import 'package:one_ds/one_ds.dart';

Future<List<int>> printerReceipit(
  SettingsModel settings,
  OrderTicketEntity order,
  bool isPurchase,
) async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  List<int> bytes = [];

  if (settings.imagePath != null) {
    final img = File(settings.imagePath!);
    final imageFilter = await convertImageToHalftoneBlackAndWhite(img);
    final imgs = decodeImage(imageFilter!);
    bytes += generator.imageRaster(imgs!, imageFn: PosImageFn.bitImageRaster);
    bytes += generator.feed(1);
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
    order.departure.removeDiacritic.orEmpty,
    styles: PosStyles(
      align: .center,
      height: .size1,
      bold: true,
      fontType: .fontA,
    ),
  );
  bytes += generator.text(
    'Para',
    styles: PosStyles(
      align: .center,
      height: .size1,
      fontType: .fontB,
      bold: false,
    ),
  );
  bytes += generator.text(
    order.destination.removeDiacritic.orEmpty,
    styles: PosStyles(
      align: .center,
      height: .size1,
      bold: true,
      fontType: .fontA,
    ),
  );
  bytes += generator.feed(1);
  bytes += generator.text(
    UtilBrasilFields.obterReal(order.price ?? 0),
    styles: PosStyles(
      align: .center,
      width: .size2,
      bold: true,
      height: .size2,
      fontType: .fontA,
    ),
  );

  bytes += generator.text(
    'Valor Total',
    styles: PosStyles(
      align: .center,
      height: .size1,
      fontType: .fontB,
      bold: false,
    ),
  );
  bytes += generator.feed(1);
  if (order.customer_name != null) {
    bytes += generator.text(
      order.customer_name.orEmpty,
      styles: PosStyles(align: .center, height: .size1),
    );
  }

  bytes += generator.text(
    'Data: ${order.created_at!.formated}',
    styles: PosStyles(align: .center, height: .size1),
  );
  bytes += generator.feed(1);
  if (settings.showPix) {
    bytes += generator.qrcode(
      getPix(
        type: settings.typePix!,
        pix: settings.myPix!,
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
    settings.textReceipt.removeDiacritic,
    styles: PosStyles(align: .center, height: .size1, fontType: .fontB),
  );
  bytes += generator.feed(1);
  bytes += generator.text(
    '${settings.modelCar.orEmpty} - ${settings.plateCar.orEmpty}',
    styles: PosStyles(align: .center, height: .size1, fontType: .fontA),
  );

  if (!isPurchase) {
    bytes += generator.feed(1);
    bytes += generator.text(
      freeText.removeDiacritic,
      styles: PosStyles(align: .center, height: .size1, fontType: .fontB),
    );
  }

  bytes += generator.cut();
  return bytes;
}
 */
