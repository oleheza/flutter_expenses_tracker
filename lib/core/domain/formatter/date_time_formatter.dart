import 'package:intl/intl.dart';

import '../../../app/config/app_language.dart';

class DateTimeFormatter {
  String formatToLongDate(DateTime dateTime, AppLanguage? language) {
    return DateFormat.yMMMMEEEEd(language?.code).format(dateTime);
  }

  String formatToShortDate(DateTime dateTime) {
    return DateFormat.y().format(dateTime);
  }
}
