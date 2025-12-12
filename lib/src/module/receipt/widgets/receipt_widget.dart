import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/extension/date_timer.dart';
import 'package:parking/core/utils/get_pix.dart';

class ReceiptWidget extends StatelessWidget {
  ReceiptWidget({super.key, required this.isExist});
  final Color backGround = Color(0xffFFFFE6);
  final bool isExist;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGround,
      child: Column(
        spacing: OneSizeConstants.size8,

        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        children: [
          OneSize.height32,
          Center(child: OneSelectImage(backGroundColor: backGround)),
          OneSize.height8,
          OneText.heading3('Estacionamento do Mané', textAlign: .center),
          OneText.caption(
            '(77) 9. 9992-1234 | 123.123.12/0001-89 ',
            textAlign: .center,
          ),

          OneSize.height8,

          OneText.heading1(isExist ? 'SAÍDA' : 'ENTRADA', textAlign: .center),
          OneSize.height8,
          OneText.caption('Modelo: GOL - XXXX-XXXX', textAlign: .center),
          OneText.caption(
            'Entrada: ${DateTime.now().formated}',
            textAlign: .center,
          ),
          if (isExist)
            OneText.caption(
              'Saída: ${DateTime.now().formated}',
              textAlign: .center,
            ),
          OneSize.height8,
          OneText.heading3('Cliente: Marcos', textAlign: .center),
          Center(
            child: QrImageView(
              data: getPix(type: 1, pix: 'cristianpaulo4@gmail.com', value: 0),
              version: QrVersions.auto,
              size: 120,
            ),
          ),
          OneText.caption('Pague com Pix', textAlign: .center),
          OneText.bodyText('ok', textAlign: .center),
          OneText.caption('Qui', textAlign: .center),
          OneText.bodyText('freeText', textAlign: .center),

          OneSize.height32,
        ],
      ),
    );
  }
}
