import 'package:employee_time_tracker/main.dart';
import 'package:employee_time_tracker/models/employee.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _enteredNumber = "";

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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: addEntryBody(),
    );
  }

  Widget addEntryBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
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
      ],
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
        // backgroundColor: const MaterialStatePropertyAll(Colors.white),
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
          validateEmployeeCode(_enteredNumber);
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

  void validateEmployeeCode(String enteredNumber) {
    bool validated = false;
    for (var employee in employees) {
      if (employee.employeeCode == enteredNumber) {
        validated = true;
        if (employee.hasCheckedIn) {
          //set the entry time for the employee here
          employee.entryTime = DateTime.now();
          employee.hasCheckedIn = false;
        } else {
          //set the exit time for the employee here
          employee.exitTime = DateTime.now();
          employee.hasCheckedIn = true;
        }
        String message = employee.hasCheckedIn
            ? 'Have a good day ${employee.fullName}. You worked ${timeInBetween(employee)}'
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

  String timeInBetween(Employee employee) {
    String hours =
        employee.exitTime!.difference(employee.entryTime!).inHours.toString();
    String minutes =
        employee.exitTime!.difference(employee.entryTime!).inMinutes.toString();

    return "$hours hours, $minutes minutes";
  }
}
