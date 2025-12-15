import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' show decodeImage;
import 'package:image_halftone/image_halftone.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/extension/date_timer.dart';
import 'package:parking/core/extension/string_extension.dart';
import 'package:parking/src/module/settings/model/settings_model.dart';

Future<List<int>> printerReport({
  required SettingsModel settings,
  required double total,
  required double pix,
  required double cash,
  required double card,
  required DateTime first,
  required DateTime last,
}) async {
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
    'CAIXA',
    styles: PosStyles(
      align: .center,
      width: .size2,
      bold: true,
      height: .size2,
      fontType: .fontA,
    ),
  );
  bytes += generator.text(
    '${first.formatedDate} a ${last.formatedDate}',
    styles: PosStyles(align: .center, height: .size1, fontType: .fontB),
  );
  bytes += generator.feed(1);

  bytes += generator.text('Pix: ${UtilBrasilFields.obterReal(pix)}');
  bytes += generator.text('Dinheiro: ${UtilBrasilFields.obterReal(cash)}');
  bytes += generator.text('Cartao: ${UtilBrasilFields.obterReal(card)}');
  bytes += generator.feed(1);
  bytes += generator.text(
    'Total: ${UtilBrasilFields.obterReal(total)}',
    styles: PosStyles(height: .size2, fontType: .fontB),
  );

  bytes += generator.cut();
  return bytes;
}
