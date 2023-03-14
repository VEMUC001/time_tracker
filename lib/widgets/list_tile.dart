import 'package:animations/animations.dart';
import 'package:employee_time_tracker/models/employee_2.dart';
import 'package:employee_time_tracker/widgets/detail_page.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ListViewTile extends StatelessWidget {
  final int index;
  final Employee2 employee;
  final bool isActiveList;
  final Color backgroundColor;
  const ListViewTile(
      {super.key,
      required this.employee,
      required this.index,
      required this.isActiveList,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return mainView();
  }

  OpenContainer<Object> mainView() {
    return OpenContainer(
      middleColor: Colors.transparent.withOpacity(0.0),
      openColor: Colors.transparent,
      transitionDuration: const Duration(seconds: 1),
      closedBuilder: (BuildContext context, void Function() action) {
        return buildView(context, action);
      },
      openBuilder:
          (BuildContext context, void Function({Object? returnValue}) action) {
        return DetailPage(employee: employee);
      },
    );
  }

  Widget buildView(BuildContext context, void Function() action) {
    String? entryTime;
    if (isActiveList &&
        employee.entryMap[Constants.getKeyWithDateTimeNowFormat()] != null) {
      entryTime = Constants.formattedDate(employee
          .entryMap[Constants.getKeyWithDateTimeNowFormat()]!.entryTime!);
    } else {}

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 10,
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(4.0),
          height: 60,
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Text(
                  employee.fullName,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                if (entryTime != null && entryTime.isNotEmpty)
                  Text("Clocked in at : $entryTime ",
                      style: const TextStyle(color: Colors.white, fontSize: 14))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
