import 'package:employee_time_tracker/utils/constants.dart';
import 'package:flutter/material.dart';

import '../models/employee_2.dart';

class DetailPage extends StatefulWidget {
  final Employee2 employee;

  const DetailPage({super.key, required this.employee});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final listOfWeekStartingDate = Constants.getStartOfWeekDates();
  final mapOfDatesWithWeeks = Constants.getDatesOfWeekStarting2023();
  final currentWeekDates = Constants.getDatesInCurrentWeek();

  int hoursWorkedInWeek = 0;
  int minutesWorkedInWeek = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.employee.fullName),
      ),
      body: widget.employee.entryMap.isNotEmpty
          ? buildListView(context)
          : buildEmptyView(),
    );
  }

  Widget buildListView(BuildContext context) {
    //filter the list before
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          if (currentWeekDates.isNotEmpty) addCurrentWeekView(),
          Expanded(
            child: ListView.builder(
              itemCount: listOfWeekStartingDate.length,
              itemBuilder: (context, index) {
                String startingDateofWeek = listOfWeekStartingDate[index];
                return shouldAddCardView(startingDateofWeek)
                    ? cardView(startingDateofWeek)
                    : const SizedBox(height: 1.0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget cardView(String keyOfMap) {
    hoursWorkedInWeek = 0;
    minutesWorkedInWeek = 0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          //We have to put in paid options,
          //so one can know if that week is settled up or not.
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Starting date of week: $keyOfMap",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...buildWeekWiseViewForEmployee(
                    keyOfMap, hoursWorkedInWeek, minutesWorkedInWeek),
                const SizedBox(height: 10),
                if (hoursWorkedInWeek != 0 || minutesWorkedInWeek != 0)
                  addTotalHoursView()
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildWeekWiseViewForEmployee(
      String startingDate, int hoursWorkedInWeek, int minutesWorkedInWeek) {
    //get all the dates in a particular week
    List<Widget> addTextViews = [];
    final daysOfTheWeek = mapOfDatesWithWeeks[startingDate];
    if (daysOfTheWeek != null && daysOfTheWeek.isNotEmpty) {
      buildDailyView(daysOfTheWeek, addTextViews);
    }
    return addTextViews;

    //then get the hours worked for each date

    //then add all of the hours for the week
  }

  Widget buildEmptyView() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          "No Entry Found for this Employee",
          style: TextStyle(
            fontSize: 32,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  bool shouldAddCardView(String startingDateOfWeek) {
    final daysOfTheWeek = mapOfDatesWithWeeks[startingDateOfWeek];
    for (var date in daysOfTheWeek!) {
      if (widget.employee.entryMap.containsKey(date)) {
        final entryMap = widget.employee.entryMap[date];
        if (entryMap != null) {
          return true;
        }
      }
    }
    return false;
  }

  Widget addCurrentWeekView() {
    List<Widget> addTextViews = [];
    hoursWorkedInWeek = 0;
    minutesWorkedInWeek = 0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 6,
        shadowColor: Colors.greenAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: const [
                  Text(
                    "Current Week",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...buildDailyView(currentWeekDates, addTextViews),
              const SizedBox(height: 10),
              if (hoursWorkedInWeek != 0 || minutesWorkedInWeek != 0)
                addTotalHoursView()
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildDailyView(
      List<String> daysOfTheWeek, List<Widget> addViewsTo) {
    for (String date in daysOfTheWeek) {
      //then get the hours worked for each date
      if (widget.employee.entryMap.containsKey(date)) {
        final entryMap = widget.employee.entryMap[date];
        if (entryMap != null) {
          TimeEntry timeEntry = widget.employee.entryMap[date]!;
          if (timeEntry.entryTime != null && timeEntry.exitTime != null) {
            int hours =
                timeEntry.exitTime!.difference(timeEntry.entryTime!).inHours;
            hoursWorkedInWeek = hoursWorkedInWeek + hours;
            int minutes = (timeEntry.exitTime!
                    .difference(timeEntry.entryTime!)
                    .inMinutes) -
                (hours * 60);
            minutesWorkedInWeek = minutesWorkedInWeek + minutes;
            addViewsTo.add(
              Text("Hours Worked on $date - $hours hours, $minutes minutes"),
            );
            addViewsTo.add(const SizedBox(height: 4.0));
          } else {
            addViewsTo.add(
              Text(
                "$date - Missing Entry/Exit Time",
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
            );
          }
        }
      }
    }
    return addViewsTo;
  }

  Widget addTotalHoursView() {
    return Text(
      "Total - $hoursWorkedInWeek hrs, $minutesWorkedInWeek mins",
      style: const TextStyle(
          fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.bold),
    );
  }
}
