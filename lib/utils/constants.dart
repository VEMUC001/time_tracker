import 'package:flutter/material.dart';
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

  static String formatDateWithOurFormat(DateTime date) {
    String formattedDate = '${date.year}-${date.month}-${date.day}';
    return formattedDate;
  }

  static Map<String, List<String>> getDatesOfWeekStarting2023() {
    Map<String, List<String>> daysOfTheWeek = {};

    DateTime start = DateTime(2023, 1, 1);
    DateTime end = DateTime.now();

    // Loop through each week and print the dates
    for (var date = start;
        date.isBefore(end);
        date = date.add(
      const Duration(days: 7),
    ),) {
      List<String> daysOfWeek = [];
      DateTime sunday = date.subtract(Duration(days: date.weekday));

      for (int i = 0; i < 7; i++) {
        DateTime day = sunday.add(Duration(days: i));
        daysOfWeek.add(formatDateWithOurFormat(day));
      }

      daysOfTheWeek[sunday.toString().substring(0, 10)] = daysOfWeek;
    }
    debugPrint(daysOfTheWeek.toString());
    return daysOfTheWeek;
  }

  static List<String> getStartOfWeekDates() {
    List<String> startingDateOfWeek = [];
    DateTime end = DateTime.now();
    DateTime start = DateTime(2023, 1, 1);
    for (var date = start;
        date.isBefore(end);
        date = date.add(
      const Duration(days: 7),
    ),) {
      DateTime sunday = date.subtract(Duration(days: date.weekday));
      startingDateOfWeek.add(sunday.toString().substring(0, 10));
    }

    return startingDateOfWeek.reversed.toList();
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
