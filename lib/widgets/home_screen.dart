import 'dart:async';

import 'package:employee_time_tracker/main.dart';
import 'package:employee_time_tracker/utils/constants.dart';
import 'package:employee_time_tracker/models/employee_2.dart';
import 'package:employee_time_tracker/widgets/list_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
  late String _secretCode;
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _secretEmployerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readEmployeeData();
    readSecretCode();
    debugPrint(
        Constants.getWeeksForRange2(DateTime.utc(2023, 01, 01), DateTime.now())
            .toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _secretEmployerController.dispose();
    super.dispose();
  }

  Future<void> readSecretCode() async {
    await getInstanceForFireBase().ref('secretCode').get().then(
          (snapshot) => {
            if (snapshot.exists)
              {
                _secretCode = snapshot.value.toString(),
              }
            else
              {
                debugPrint('No code exists, please check console'),
              }
          },
        );
  }

  Future<void> readEmployeeData() async {
    listOfEmployees.clear();
    await getInstanceForFireBase().ref('employees').get().then(
      (DataSnapshot snapshot) {
        if (snapshot.exists) {
          var list = (snapshot.value as Map).values.toList();
          for (var element in list) {
            Employee2 employee =
                Employee2.fromJson(Map<String, dynamic>.from(element));
            listOfEmployees.add(employee);
          }
          setState(
            () {
              listOfEmployees = listOfEmployees;
            },
          );
        } else {
          debugPrint('No data available.');
        }
      },
    );
  }

  Future<void> writeEmployeeData(
      Employee2 employee, String enteredNumber) async {
    await getInstanceForFireBase()
        .ref('employees/$enteredNumber')
        .update(employee.toJson())
        .then(
          (value) => {debugPrint('Successful')},
        );
  }

  Future<void> addNewEmployee(Employee2 employee, String enteredNumber) async {
    await getInstanceForFireBase()
        .ref('employees/$enteredNumber')
        .set(employee.toJson())
        .then(
          (value) => {
            readEmployeeData(),
            debugPrint('Successfully added Employee '),
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
      resizeToAvoidBottomInset: false,
      body: addEntryBody(),
      backgroundColor: Colors.white,
      floatingActionButton: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 48.0, left: 24.0),
          child: FloatingActionButton(
            onPressed: () => buildBottomSheet(),
            child: const Icon(Icons.person),
          ),
        ),
      ),
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
    for (var employee in listOfEmployees) {
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
        writeEmployeeData(employee, enteredNumber);
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
        String minutes =
            ((timeEntry.exitTime!.difference(timeEntry.entryTime!).inMinutes) -
                    int.parse(hours) * 60)
                .toString();
        return "$hours hours, $minutes minutes";
      } else {
        return 'Error missing either the entry or exit time - ${timeEntry.entryTime}, ${timeEntry.exitTime}';
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
        listOfEmployees.where((employee) => employee.hasCheckedIn).toList();

    var inActiveFilteredList =
        listOfEmployees.where((employee) => !employee.hasCheckedIn).toList();

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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return ListViewTile(
          employee: filteredList[index],
          index: index,
          isActiveList: isActiveList,
          backgroundColor: backgroundColor,
        );
      },
    );
  }

  Future buildBottomSheet() {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Code (4 digits)',
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _secretEmployerController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Employer Code to Validate',
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      //Validate _secretEmployerController
                      String name = _nameController.text;
                      String code = _codeController.text;
                      String secretCode = _secretEmployerController.text;
                      _nameController.clear();
                      _codeController.clear();
                      _secretEmployerController.clear();
                      if (name.isNotEmpty &&
                          code.isNotEmpty &&
                          secretCode.isNotEmpty) {
                        if (code.length == 4) {
                          if (_secretCode == secretCode) {
                            addNewEmployee(
                                Employee2(
                                  fullName: name,
                                  employeeCode: code,
                                  hasCheckedIn: false,
                                  entryMap: {},
                                  paidPerWeek: {},
                                ),
                                code);
                          } else {
                            snackBarWithMessage(
                                "Enter a VALID employeer code to add");
                          }
                        } else {
                          snackBarWithMessage(
                              "Employee code can only be 4 digits");
                        }
                      } else {
                        snackBarWithMessage(
                            "One of the fields is empty - all fields are required");
                      }
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
