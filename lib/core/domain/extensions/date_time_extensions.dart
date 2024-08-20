import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  bool isSameDate(DateTime? anotherDate) {
    return anotherDate != null &&
        year == anotherDate.year &&
        month == anotherDate.month &&
        day == anotherDate.day;
  }

  DateTime toEndOfDay() {
    return copyWith(
      hour: 23,
      minute: 59,
      second: 59,
      microsecond: 999,
      millisecond: 999,
    );
  }

  DateTime toStartOfDay() {
    return copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      microsecond: 0,
      millisecond: 0,
    );
  }

  String formatToShortDate() {
    return DateFormat.yMd().format(this);
  }
}
