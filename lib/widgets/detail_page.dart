import 'package:employee_time_tracker/utils/constants.dart';
import 'package:flutter/material.dart';

import '../models/employee_2.dart';

class DetailPage extends StatelessWidget {
  final Employee2 employee;
  final listOfDates = Constants.getStartOfWeekDates();
  final mapOfDatesWithWeeks = Constants.getDatesOfWeekStarting2023();
  int hoursWorkedInWeek = 0;
  int minutesWorkedInWeek = 0;

  DetailPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(employee.fullName),
      ),
      body: employee.entryMap.isNotEmpty
          ? buildListView(context)
          : buildEmptyView(),
    );
  }

  Widget buildListView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: listOfDates.length,
        itemBuilder: (context, index) {
          String keyOfMap = listOfDates[index];
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
                      ...buildWeekWiseViewForEmployee(keyOfMap),
                      const SizedBox(height: 10),
                      if (hoursWorkedInWeek != 0 || minutesWorkedInWeek != 0)
                        Text(
                          "Total - $hoursWorkedInWeek hrs, $minutesWorkedInWeek mins",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> buildWeekWiseViewForEmployee(String startingDate) {
    //get dates of the week
    //get all the dates in a particular week
    List<Widget> addTextViews = [];
    hoursWorkedInWeek = 0;
    minutesWorkedInWeek = 0;
    final daysOfTheWeek = mapOfDatesWithWeeks[startingDate];
    if (daysOfTheWeek != null && daysOfTheWeek.isNotEmpty) {
      for (var date in daysOfTheWeek) {
        //then get the hours worked for each date
        if (employee.entryMap.containsKey(date)) {
          final entryMap = employee.entryMap[date];
          if (entryMap != null) {
            TimeEntry timeEntry = employee.entryMap[date]!;
            if (timeEntry.entryTime != null && timeEntry.exitTime != null) {
              int hours =
                  timeEntry.exitTime!.difference(timeEntry.entryTime!).inHours;
              hoursWorkedInWeek = hoursWorkedInWeek + hours;
              int minutes = (timeEntry.exitTime!
                      .difference(timeEntry.entryTime!)
                      .inMinutes) -
                  (hours * 60);
              minutesWorkedInWeek = minutesWorkedInWeek + minutes;
              addTextViews.add(
                Text("Hours Worked on $date - $hours hours, $minutes minutes"),
              );
              addTextViews.add(const SizedBox(height: 4.0));
            } else {
              addTextViews.add(
                Text(
                  "$date - Missing Entry/Exit Time",
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
              );
            }
          }
        }
      }
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
}
