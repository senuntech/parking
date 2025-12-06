import 'dart:convert';

String gerarQrCodePix({
  required String chave,
  required double valor,
  String nomeRecebedor = "PRINT PARKING",
  String cidadeRecebedor = "BRASIL",
}) {
  // Função TLV
  String tlv(String id, String value) {
    final len = value.length.toString().padLeft(2, '0');
    return id + len + value;
  }

  // ----------------------------
  // CRC16 (CCITT-FALSE)
  // ----------------------------
  int crc16Ccitt(List<int> bytes) {
    int crc = 0xFFFF;
    for (final b in bytes) {
      crc ^= (b << 8);
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = ((crc << 1) ^ 0x1021) & 0xFFFF;
        } else {
          crc = (crc << 1) & 0xFFFF;
        }
      }
    }
    return crc & 0xFFFF;
  }

  // ----------------------------
  // Montagem do payload PIX
  // ----------------------------

  // 00 - Payload Format Indicator
  String payload = tlv("00", "01");

  // 01 - Point of Initiation Method (11 = estático)
  payload += tlv("01", "11");

  // 26 - Merchant Account Info
  final merchantAccountInfo = tlv("00", "br.gov.bcb.pix") + tlv("01", chave);
  payload += tlv("26", merchantAccountInfo);

  // 52 - Merchant Category Code
  payload += tlv("52", "0000");

  // 53 - Moeda (986 = BRL)
  payload += tlv("53", "986");

  // 54 - Valor (2 casas decimais)
  payload += tlv("54", valor.toStringAsFixed(2));

  // 58 - País
  payload += tlv("58", "BR");

  // 59 - Nome do recebedor (máx recomendado: 25 chars)
  payload += tlv("59", nomeRecebedor);

  // 60 - Cidade (máx: 15 chars)
  payload += tlv("60", cidadeRecebedor);

  // 62 - TXID → usa "***" para QR estático simples
  payload += tlv("62", tlv("05", "***"));

  // 63 - CRC (coloca placeholder antes de calcular)
  final payloadParaCrc = "${payload}6304";

  final bytes = utf8.encode(payloadParaCrc);
  final crc = crc16Ccitt(bytes).toRadixString(16).toUpperCase().padLeft(4, "0");

  payload += tlv("63", crc);

  return payload;
}
