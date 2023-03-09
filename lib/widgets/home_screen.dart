import 'dart:async';
import 'dart:convert';

import 'package:employee_time_tracker/constants.dart';
import 'package:employee_time_tracker/main.dart';
import 'package:employee_time_tracker/models/employee_2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _enteredNumber = "";
  bool isLoading = true;
  List<Employee2> listOfEmployees = [];

  @override
  void initState() {
    super.initState();
    readEmployeeData();
  }

  Future<void> readEmployeeData() async {
    FirebaseDatabase.instance.ref().child('employees').get().then(
      (DataSnapshot snapshot) {
        if (snapshot.exists) {
          var list = snapshot.value as List;
          for (var element in list) {
            Employee2 employee =
                Employee2.fromJson(Map<String, dynamic>.from(element));
            listOfEmployees.add(employee);
          }
        } else {
          debugPrint('No data available.');
        }
      },
    );
  }

  void _appendEnteredNumber(String number, bool clearAll) {
    setState(() {
      if (clearAll) {
        _enteredNumber = "";
      } else {
        _enteredNumber = _enteredNumber + number;
      }
      debugPrint("Entered Number is: $_enteredNumber");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: addEntryBody(),
      backgroundColor: Colors.white,
    );
  }

  Widget addEntryBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            addMessageView("Enter your 4 digit code"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                addCircularButton("1"),
                addCircularButton("2"),
                addCircularButton("3"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                addCircularButton("4"),
                addCircularButton("5"),
                addCircularButton("6"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                addCircularButton("7"),
                addCircularButton("8"),
                addCircularButton("9"),
              ],
            ),
            const SizedBox(height: 10),
            Center(child: addCircularButton("0")),
            _enteredNumber.isNotEmpty
                ? addMessageView("Entering: $_enteredNumber")
                : const SizedBox(height: 1),
            const SizedBox(height: 20),
            addSubmitButton(),
            const SizedBox(height: 10),
            buildListViewEmployees(),
          ],
        ),
      ),
    );
  }

  Padding addMessageView(String message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.blue, fontSize: 24),
        ),
      ),
    );
  }

  Widget addCircularButton(String s) {
    return ElevatedButton(
      onPressed: () => {
        _appendEnteredNumber(s, false),
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color.fromARGB(255, 136, 179, 254);
            }
            return Colors.white;
          },
        ),
        shape: MaterialStateProperty.all<CircleBorder>(
          const CircleBorder(
            side: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          s,
          style: const TextStyle(color: Colors.blue, fontSize: 32),
        ),
      ),
    );
  }

  Widget addSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_enteredNumber.length == 4) {
          // validateEmployeeCode(_enteredNumber);
          validateEmployee2Code(_enteredNumber);
          _appendEnteredNumber("", true);
        } else {
          _appendEnteredNumber("", true);
          snackBarWithMessage("Please enter 4 digits");
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  void validateEmployee2Code(String enteredNumber) {
    bool validated = false;
    for (var employee in puesdoEmployees) {
      if (employee.employeeCode == enteredNumber) {
        validated = true;
        if (employee.hasCheckedIn) {
          //set the exit time for the employee here
          enterExitTime(employee);
          employee.hasCheckedIn = false;
        } else {
          //set the entry time for the employee here
          enterEntryTime(employee);
          employee.hasCheckedIn = true;
        }
        String message = !employee.hasCheckedIn
            ? 'Have a good day ${employee.fullName}. You worked ${timeInBetween2(employee)}'
            : 'Welcome ${employee.fullName}, entry time has been logged';

        snackBarWithMessage(message);
        break;
      }
    }
    if (!validated) {
      snackBarWithMessage(
          'Wrong Code Entered: $enteredNumber, Please try again');
    }
  }

  void enterEntryTime(Employee2 employee) {
    TimeEntry timeEntry = TimeEntry(entryTime: DateTime.now());
    employee.entryMap[Constants.getKeyWithDateTimeNowFormat()] = timeEntry;
  }

  void enterExitTime(Employee2 employee) {
    if (employee.entryMap
        .containsKey(Constants.getKeyWithDateTimeNowFormat())) {
      TimeEntry timeEntry = TimeEntry(
          entryTime: employee
              .entryMap[Constants.getKeyWithDateTimeNowFormat()]!.entryTime,
          exitTime: DateTime.now());
      employee.entryMap.update(
          Constants.getKeyWithDateTimeNowFormat(), (value) => timeEntry);
    } else {
      snackBarWithMessage(
          "No entry found for your entry time for today. Please contact administration");
    }
  }

  String timeInBetween2(Employee2 employee) {
    String key = Constants.getKeyWithDateTimeNowFormat();
    if (employee.entryMap.containsKey(key)) {
      TimeEntry timeEntry = employee.entryMap[key]!;
      if (timeEntry.entryTime != null && timeEntry.exitTime != null) {
        String hours = timeEntry.exitTime!
            .difference(timeEntry.entryTime!)
            .inHours
            .toString();
        String minutes = timeEntry.exitTime!
            .difference(timeEntry.entryTime!)
            .inMinutes
            .toString();
        return "$hours hours, $minutes minutes";
      } else {
        return 'Error missing either the entry or exit time - ${timeEntry.entryTime} ${timeEntry.exitTime}';
      }
    } else {
      return 'Error';
    }
  }

  void snackBarWithMessage(String message) {
    SnackBar snackBar = SnackBar(
      showCloseIcon: true,
      duration: const Duration(seconds: 10),
      closeIconColor: Colors.white,
      backgroundColor: Colors.blue,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget addWorkingTextView(String message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          message,
          style: const TextStyle(color: Colors.blueGrey, fontSize: 18),
        ),
      ),
    );
  }

  Widget buildListViewEmployees() {
    //filter active employees only
    var activeFilteredList =
        puesdoEmployees.where((employee) => employee.hasCheckedIn).toList();

    var inActiveFilteredList =
        puesdoEmployees.where((employee) => !employee.hasCheckedIn).toList();

    return Column(
      children: [
        activeFilteredList.isNotEmpty
            ? addWorkingTextView("Currently Clocked In")
            : const SizedBox(
                height: 1,
              ),
        buildListOfEmployees(activeFilteredList, Colors.green, true),
        inActiveFilteredList.isNotEmpty
            ? addWorkingTextView("Not Clocked In")
            : const SizedBox(
                height: 1,
              ),
        buildListOfEmployees(inActiveFilteredList, Colors.red, false),
      ],
    );
  }

  ListView buildListOfEmployees(
      List<Employee2> filteredList, Color backgroundColor, bool isActiveList) {
    String? entryTime;
    String exitTimeString = "Enter your code to log your time";

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        if (isActiveList) {
          entryTime = Constants.formattedDate(filteredList[index]
              .entryMap[Constants.getKeyWithDateTimeNowFormat()]!
              .entryTime!);
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
                      filteredList[index].fullName,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    if (entryTime != null && entryTime!.isNotEmpty)
                      Text("Clocked in at : $entryTime ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
