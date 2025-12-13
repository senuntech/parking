import 'dart:io';

import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/core/extension/date_timer.dart';
import 'package:parking/core/extension/string_extension.dart';
import 'package:parking/core/utils/get_pix.dart';
import 'package:parking/src/module/settings/controller/settings_controller.dart';
import 'package:parking/src/module/settings/model/settings_model.dart';
import 'package:parking/src/module/ticket/model/order_ticket_model.dart';
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

  VehicleEnum get vehicle {
    if (orderTicketModel?.typeVehicles == VehicleEnum.car.id) {
      return VehicleEnum.car;
    }
    if (orderTicketModel?.typeVehicles == VehicleEnum.motorcycle.id) {
      return VehicleEnum.motorcycle;
    }
    return VehicleEnum.car;
  }

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
                orderTicketModel?.exitAt != null ? 'SAÍDA' : 'ENTRADA',
                textAlign: .center,
              ),
              OneText.caption(vehicle.name, textAlign: .center),
              OneSize.height8,
              OneText.caption(
                'Modelo: ${orderTicketModel?.model} - ${orderTicketModel?.plate}',
                textAlign: .center,
              ),
              OneText.caption(
                'Entrada: ${orderTicketModel?.createdAt?.formated}',
                textAlign: .center,
              ),
              if (orderTicketModel?.exitAt != null)
                OneText.caption(
                  'Saída: ${orderTicketModel?.exitAt?.formated}',
                  textAlign: .center,
                ),
              OneSize.height8,
              OneText.heading3(
                'Cliente: ${orderTicketModel?.name}',
                textAlign: .center,
              ),
              if (controller.settingsModel.show_pix ?? false) ...[
                Center(
                  child: QrImageView(
                    data: getPix(
                      type: 1,
                      pix: controller.settingsModel.my_pix!,
                      value: 0,
                    ),
                    version: QrVersions.auto,
                    size: 120,
                  ),
                ),
                OneText.caption('Pague com Pix', textAlign: .center),
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
