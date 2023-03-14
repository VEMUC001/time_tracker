import 'package:intl/intl.dart';

class Constants {
  static const appTitle = 'Simple Time Tracker';
  static const appBarTitle = 'One Life Luxuries Time Tracker';

  static String getKeyWithDateTimeNowFormat() {
    DateTime now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  static String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return formatter.format(date);
  }

  static String formattedDateOnlyWithYearDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static List<String> getWeeksForRange2(DateTime start, DateTime end) {
    var result = <String>[];

    var date = start;
    DateTime? week;

    while (date.difference(end).inDays <= 0) {
      // start new week on Monday
      if (date.weekday == 1 && week != null) {
        result.add(formattedDateOnlyWithYearDate(week));
        week = null;
      }

      week = date;

      date = date.add(const Duration(days: 1));
    }

    // result.add(formattedDateOnlyWithYearDate(week!));

    return result;
  }
}
