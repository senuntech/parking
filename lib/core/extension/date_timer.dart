import 'package:intl/intl.dart';

extension DateTimer on DateTime {
  String get formated {
    var format = DateFormat('dd/MM/yyyy hh:mm');
    return format.format(this);
  }

  String get formatedHour {
    var format = DateFormat('hh:mm');
    return format.format(this);
  }

  String get formatedDate {
    var format = DateFormat('dd/MM/yyyy');
    return format.format(this);
  }

  DateTime get date {
    var format = DateFormat('yyyy-MM-dd');
    return DateTime.parse(format.format(this));
  }

  DateTime get firstDay {
    return DateTime(year, month, 0);
  }

  DateTime get lastDay {
    final firstDayOfNextMonth = DateTime(year, month + 1, 1);
    return firstDayOfNextMonth.subtract(Duration(milliseconds: 1));
  }

  String get currentNameMonth {
    final format = DateFormat(DateFormat.MONTH, 'pt_BR');
    return _firstUpCase(format.format(this));
  }

  String get currentNameMonthABBR {
    final format = DateFormat(DateFormat.ABBR_MONTH, 'pt_BR');
    return _firstUpCase(format.format(this));
  }

  String _firstUpCase(String text) {
    text = text.replaceRange(0, 1, text[0].toUpperCase());
    return text;
  }
}
