import 'package:employee_time_tracker/models/employee.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Employee employee1 = Employee("Chandra", "1234");
Employee employee2 = Employee("Tannu", "9999");
Employee employee3 = Employee("Hamza", "0000");
Employee employee4 = Employee("Jagpreet", "5555");

List<Employee> employees = [employee1, employee2, employee3, employee4];

void main() {
  runApp(const MyApp());
}
