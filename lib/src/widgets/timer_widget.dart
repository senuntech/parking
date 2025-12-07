import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_ds/core/colors/one_colors.dart';
import 'package:one_ds/core/ui/atoms/one_tagger.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/extension/date_timer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key, required this.timer});
  final DateTime timer;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    init();
    dateTime = widget.timer;
  }

  void init() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {});
    });
  }

  String get getTimer {
    final now = DateTime.now().difference(widget.timer);
    return now.toString().substring(0, 4);
  }

  @override
  Widget build(BuildContext context) {
    return OneTagger(
      tag: getTimer,
      color: OneColors.warning,
      icon: LucideIcons.clock,
      reversedIcon: true,
    );
  }
}
