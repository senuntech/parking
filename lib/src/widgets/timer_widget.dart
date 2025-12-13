import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_ds/core/colors/one_colors.dart';
import 'package:one_ds/core/ui/atoms/one_tagger.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/extension/duration_extension.dart';
import 'package:parking/core/enum/type_charge_enum.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key, required this.timer, required this.typeCharge});
  final DateTime timer;
  final TypeChargeEnum typeCharge;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    init();
    dateTime = widget.timer;
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  void init() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  String get getDay {
    final now = DateTime.now().difference(widget.timer).inDays;
    if (now > 1) {
      return '$now Dias';
    }
    return '$now Dia';
  }

  String get getHour {
    final now = DateTime.now().difference(widget.timer);
    return now.toHms();
  }

  ({Color corlor, IconData icon}) get getTag {
    if (widget.typeCharge == TypeChargeEnum.day) {
      return (corlor: OneColors.primary, icon: LucideIcons.calendarDays);
    }

    if (widget.typeCharge == TypeChargeEnum.hour) {
      return (corlor: OneColors.warning, icon: LucideIcons.clock);
    }

    return (corlor: OneColors.success, icon: LucideIcons.check);
  }

  String get getTagWidget {
    if (widget.typeCharge == TypeChargeEnum.day) {
      return getDay;
    }

    if (widget.typeCharge == TypeChargeEnum.hour) {
      return getHour;
    }

    return 'Fixo';
  }

  @override
  Widget build(BuildContext context) {
    return OneTagger(
      tag: getTagWidget,
      color: getTag.corlor,
      icon: getTag.icon,
      reversedIcon: true,
    );
  }
}
