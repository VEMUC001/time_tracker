//Add to this employee class an optional boolean hasCheckedIn
class Employee {
  String fullName;
  String employeeCode;
  bool hasCheckedIn;
  DateTime? entryTime;
  DateTime? exitTime;
  late Map<String, EmployeeTime> times;

  Employee(this.fullName, this.employeeCode,
      [this.hasCheckedIn = false, this.entryTime, this.exitTime]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['employeeCode'] = employeeCode;
    data['hasCheckedIn'] = hasCheckedIn ? true : false;
    data['entryTime'] = entryTime;
    data['exitTime'] = exitTime;
    return data;
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      json['fullName'],
      json['employeeCode'],
      json['hasCheckedIn'] ?? false,
      json['entryTime'],
      json['exitTime'],
    );
  }
}

class EmployeeTime {
  DateTime entryTime;
  DateTime exitTime;

  EmployeeTime(this.entryTime, this.exitTime);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entryTime'] = entryTime;
    data['exitTime'] = exitTime;
    return data;
  }

  factory EmployeeTime.fromJson(Map<String, dynamic> json) {
    return EmployeeTime(
      json['entryTime'],
      json['exitTime'],
    );
  }
}
