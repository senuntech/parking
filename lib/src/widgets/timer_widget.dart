import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_ds/core/colors/one_colors.dart';
import 'package:one_ds/core/ui/atoms/one_tagger.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/extension/duration_extension.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key, required this.timer});
  final DateTime timer;

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

  String get getTimer {
    final now = DateTime.now().difference(widget.timer);
    return now.toHms();
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
