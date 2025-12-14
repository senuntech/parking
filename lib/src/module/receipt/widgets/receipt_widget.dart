import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/type_charge_enum.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/core/extension/date_timer.dart';
import 'package:parking/core/extension/string_extension.dart';
import 'package:parking/core/utils/get_pix.dart';
import 'package:parking/src/module/settings/controller/settings_controller.dart';
import 'package:parking/src/module/settings/model/settings_model.dart';
import 'package:parking/src/module/ticket/model/order_ticket_model.dart';
import 'package:parking/src/utils/vehicle_utils.dart';
import 'package:provider/provider.dart';

class ReceiptWidget extends StatelessWidget {
  ReceiptWidget({
    super.key,
    required this.isExist,
    required this.orderTicketModel,
  });
  final Color backGround = Color(0xffFFFFE6);
  final bool isExist;
  final OrderTicketModel? orderTicketModel;

  File? getImage(SettingsModel settingsModel) {
    if (settingsModel.image_path != null) {
      return File(settingsModel.image_path!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, controller, child) {
        return Container(
          color: backGround,
          child: Column(
            spacing: OneSizeConstants.size8,

            crossAxisAlignment: .stretch,
            mainAxisAlignment: .center,
            children: [
              OneSize.height32,
              Center(
                child: OneSelectImage(
                  backGroundColor: backGround,
                  image: getImage(controller.settingsModel),
                ),
              ),
              OneSize.height8,
              OneText.heading3(
                controller.settingsModel.name.orEmpty,
                textAlign: .center,
              ),
              OneText.caption(
                '${controller.settingsModel.phone.orEmpty} | ${controller.settingsModel.document.orEmpty}',
                textAlign: .center,
              ),

              OneSize.height8,

              OneText.heading1(
                orderTicketModel!.exitAt != null ? 'SAÍDA' : 'ENTRADA',
                textAlign: .center,
              ),

              OneText.caption(getDate(orderTicketModel!), textAlign: .center),

              OneText.caption(
                getVehicle(orderTicketModel!.typeVehicles!).name,
                textAlign: .center,
              ),
              OneText.caption(
                ' ${orderTicketModel!.model} - ${orderTicketModel!.plate}',
                textAlign: .center,
              ),
              if (orderTicketModel?.exitAt != null) ...[
                OneText.heading2(
                  'Total: ${UtilBrasilFields.obterReal(getTotal(orderTicketModel!))}',
                  textAlign: .center,
                ),
              ],

              OneSize.height8,
              OneText.heading3(orderTicketModel!.name!, textAlign: .center),
              if ((controller.settingsModel.show_pix ?? false) &&
                  orderTicketModel!.exitAt != null) ...[
                Center(
                  child: QrImageView(
                    data: getPix(
                      type: 1,
                      pix: controller.settingsModel.my_pix!,
                      value: getTotal(orderTicketModel!),
                    ),
                    version: QrVersions.auto,
                    size: 120,
                  ),
                ),
                OneText.caption('Pague com Pix', textAlign: .center),
              ],
              if (orderTicketModel?.exitAt == null) ...[
                OneSize.height4,
                Center(
                  child: BarcodeWidget(
                    barcode: Barcode.codabar(),
                    data: orderTicketModel!.code!,
                    width: 200,
                    height: 100,
                  ),
                ),
              ],
              OneText.bodyText(DateTime.now().formated, textAlign: .center),
              OneText.caption(
                controller.settingsModel.text_receipt.orEmpty,
                textAlign: .center,
              ),
              OneSize.height32,
            ],
          ),
        );
      },
    );
  }
}
