import 'package:intl/intl.dart';

class Constants {
  static const appTitle = 'Simple Time Tracker';
  static const appBarTitle = 'One Life Luxuries Time Tracker';

  static String getKeyWithDateTimeNowFormat() {
    DateTime now = DateTime.now();
    return '${now.month}:${now.day}:${now.year}';
  }

  static String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return formatter.format(date);
  }
}
