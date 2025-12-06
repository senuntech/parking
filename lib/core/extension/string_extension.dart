import 'package:remove_diacritic/remove_diacritic.dart';

extension StringExtension on String? {
  String get orEmpty {
    return this ?? '';
  }

  String get removeDiacritic {
    return removeDiacritics(orEmpty);
  }
}
