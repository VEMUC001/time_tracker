import 'package:employee_time_tracker/models/employee.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'models/employee_2.dart';

Employee employee1 = Employee("Chandra", "1234");
Employee employee2 = Employee("Tannu", "9999");
Employee employee3 = Employee("Hamza", "0000");
Employee employee4 = Employee("Jagpreet", "5555");

List<Employee> employees = [employee1, employee2, employee3, employee4];

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

void main() {
  runApp(const MyApp());
}
