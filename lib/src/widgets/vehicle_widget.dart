import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/type_charge_enum.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/core/extension/date_timer.dart';

import 'package:parking/src/widgets/timer_widget.dart';

class VehicleWidget extends StatefulWidget {
  const VehicleWidget({
    super.key,
    this.type = VehicleEnum.car,
    required this.dateTime,
    required this.onTap,
    required this.plate,
    required this.model,
    required this.typeCharge,
  });
  final VehicleEnum type;
  final DateTime dateTime;
  final VoidCallback onTap;
  final String plate;
  final String model;
  final TypeChargeEnum typeCharge;

  @override
  State<VehicleWidget> createState() => _VehicleWidgetState();
}

class _VehicleWidgetState extends State<VehicleWidget> {
  Widget get lead {
    Color color = widget.type == VehicleEnum.motorcycle
        ? OneColors.success
        : OneColors.primary;
    Color backGround = color.withAlpha(90);

    if (widget.type == VehicleEnum.motorcycle) {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backGround,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(LucideIcons.motorbike, color: color),
      );
    }

    if (widget.type == VehicleEnum.truck) {
      color = OneColors.warning;
      backGround = color.withAlpha(90);
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backGround,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(LucideIcons.truck, color: color),
      );
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backGround,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(LucideIcons.carFront, color: color),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OneListTile(
      title: '${widget.model.trim()} - ${widget.plate.trim()}',
      leading: lead,
      actions: [
        TimerWidget(timer: widget.dateTime, typeCharge: widget.typeCharge),
      ],
      onTap: widget.onTap,
      children: [OneText.caption(widget.dateTime.formated)],
    );
  }
}
