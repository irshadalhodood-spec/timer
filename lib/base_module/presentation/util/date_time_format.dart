import 'package:intl/intl.dart';

import '../../domain/entities/translation.dart';


class AppDateTimeFormat {
  AppDateTimeFormat._();

  static String get _locale => translation.selectedLocale?.languageCode ?? 'en';

  /// Time only, e.g. "2:30 PM" / "٢:٣٠ م"
  static String formatTime(DateTime dateTime) {
    return DateFormat.jm(_locale).format(dateTime);
  }

  /// Date only, e.g. "Feb 23, 2025" / "٢٣ فبراير ٢٠٢٥"
  static String formatDate(DateTime dateTime) {
    return DateFormat.yMMMd(_locale).format(dateTime);
  }

  /// Short month, e.g. "Feb" / "فبراير"
  static String formatMonth(DateTime dateTime) {
    return DateFormat.MMM(_locale).format(dateTime);
  }

  /// Full weekday, e.g. "Monday" / "الإثنين"
  static String formatWeekday(DateTime dateTime) {
    return DateFormat.EEEE(_locale).format(dateTime);
  }

  /// Short weekday, e.g. "Mon" / "الإثنين"
  static String formatDayShort(DateTime dateTime) {
    return DateFormat.E(_locale).format(dateTime);
  }

  /// Month and year, e.g. "Feb 2025" / "فبراير ٢٠٢٥"
  static String formatMonthYear(DateTime dateTime) {
    return DateFormat.yMMM(_locale).format(dateTime);
  }

  /// Date and time, e.g. "Feb 23, 2025 2:30 PM"
  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd(_locale).add_jm().format(dateTime);
  }
}
