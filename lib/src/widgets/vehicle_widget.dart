import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_ds/core/ui/index.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/enum/vehicle_enum.dart';
import 'package:parking/core/extension/date_timer.dart';
import 'package:parking/src/widgets/timer_widget.dart';

class VehicleWidget extends StatefulWidget {
  const VehicleWidget({
    super.key,
    this.type = VehicleEnum.car,
    required this.dateTime,
  });
  final VehicleEnum type;
  final DateTime dateTime;

  @override
  State<VehicleWidget> createState() => _VehicleWidgetState();
}

class _VehicleWidgetState extends State<VehicleWidget> {
  Widget get lead {
    bool typeItem = (widget.type == VehicleEnum.motorcycle);
    Color color = typeItem ? OneColors.success : OneColors.primary;
    Color backGround = color.withAlpha(90);

    if (widget.type == VehicleEnum.motorcycle) {
      return CircleAvatar(
        backgroundColor: backGround,
        child: Icon(LucideIcons.motorbike, color: color),
      );
    }
    return CircleAvatar(
      backgroundColor: backGround,
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
      title: 'GOL - PLA-123',
      leading: lead,
      actions: [TimerWidget(timer: widget.dateTime)],
      children: [OneText.caption('06/12/2025 12:00h')],
      onTap: () {},
    );
  }
}
