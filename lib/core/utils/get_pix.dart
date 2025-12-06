import 'package:parking/core/enum/type_pix_enum.dart';
import 'package:parking/core/utils/pix_generator.dart';

String getPix({required int type, required String pix, required double value}) {
  pix = pix.trim();
  if (type == TypePixEnum.telefone.type) {
    pix = pix.replaceAll(RegExp(r'[.\-\/()\s]'), '');
    pix = '+55$pix';
  }
  if (type == TypePixEnum.cpf.type || type == TypePixEnum.cnpj.type) {
    pix = pix.replaceAll(RegExp(r'[.\-\/]'), '');
  }

  return gerarQrCodePix(chave: pix, valor: value);
}
