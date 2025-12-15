import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:one_ds/core/index.dart';
import 'package:parking/src/module/reports/presenters/controller/reports_controller.dart';

Future<void> showDatePickerApp(
  BuildContext context,
  ReportsController reportsController,
  Function(DateTime first, DateTime last) onSelected,
  DateTime first,
  DateTime last,
) async {
  DateTime? firstTemp;
  DateTime? lastTemp;
  OneBottomSheet.show(
    context: context,
    title: 'Selecionar Data',
    content: [
      CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.range,
          selectedDayHighlightColor: OneColors.primary,
        ),
        value: [first, last],
        onValueChanged: (dates) async {
          firstTemp = dates.first;
          lastTemp = dates.last;
        },
      ),
      OneDivider(),
      Align(
        alignment: .centerRight,
        child: Padding(
          padding: .all(8.0),
          child: OneButton(
            onPressed: () async {
              Navigator.pop(context);
              if (firstTemp == null || lastTemp == null) {
                return;
              }

              onSelected(firstTemp!, lastTemp!);
              await reportsController.getOrderByDate(firstTemp!, lastTemp!);
            },
            label: 'Selecionar',
            style: OneButtonStyle.primary,
          ),
        ),
      ),
    ],
  );
}
