import 'package:flutter/material.dart';

import 'app.dart';
import 'models/employee_2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Employee2 puesdoEmployee1 = Employee2(
  fullName: "Chandra",
  employeeCode: "1234",
  hasCheckedIn: false,
  entryMap: {},
);
Employee2 puesdoEmployee2 = Employee2(
  fullName: "Tannu",
  employeeCode: "9999",
  hasCheckedIn: false,
  entryMap: {},
);
Employee2 puesdoEmployee3 = Employee2(
  fullName: "Hamza",
  employeeCode: "0000",
  hasCheckedIn: false,
  entryMap: {},
);
Employee2 puesdoEmployee4 = Employee2(
  fullName: "Jagpreet",
  employeeCode: "5555",
  hasCheckedIn: false,
  entryMap: {},
);

List<Employee2> puesdoEmployees = [
  puesdoEmployee1,
  puesdoEmployee2,
  puesdoEmployee3,
  puesdoEmployee4
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
