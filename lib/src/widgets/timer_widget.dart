import 'package:flutter/material.dart';
import 'package:one_ds/core/colors/one_colors.dart';
import 'package:one_ds/core/ui/atoms/one_tagger.dart';
import 'package:parking/core/extension/date_timer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key, required this.timer});
  final DateTime timer;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    return OneTagger(tag: widget.timer.formatedHour, color: OneColors.success);
  }
}
