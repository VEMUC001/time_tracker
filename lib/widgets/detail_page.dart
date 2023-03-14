import 'package:flutter/material.dart';

import '../models/employee_2.dart';

class DetailPage extends StatelessWidget {
  final Employee2 employee;

  const DetailPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(employee.fullName),
      ),
      // body: buildListView(),
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
        itemCount: employee.entryMap.keys.length,
        itemBuilder: (context, index) {
          String keyOfMap = employee.entryMap.keys.toList()[index];
          return Column(
            children: [
              Text(keyOfMap),
              const SizedBox(height: 10),
              Text(employee.entryMap[keyOfMap]!.entryTime!.toString()),
              const SizedBox(height: 10),
              if (employee.entryMap[keyOfMap] != null &&
                  employee.entryMap[keyOfMap]!.exitTime != null)
                Text(employee.entryMap[keyOfMap]!.exitTime!.toString()),
            ],
          );
        },
      ),
    );
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
