class Employee2 {
  String fullName;
  String employeeCode;
  bool hasCheckedIn;
  Map<DateTime, TimeEntry> entryMap;

  Employee2({
    required this.fullName,
    required this.employeeCode,
    required this.hasCheckedIn,
    required this.entryMap,
  });

  factory Employee2.fromJson(Map<String, dynamic> json) {
    Map<DateTime, TimeEntry> entryMap = {};
    json['entryMap'].forEach((key, value) {
      entryMap[DateTime.parse(key)] = TimeEntry.fromJson(value);
    });
    return Employee2(
      fullName: json['fullName'],
      employeeCode: json['employeeCode'],
      hasCheckedIn: json['hasCheckedIn'],
      entryMap: entryMap,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'fullName': fullName,
      'employeeCode': employeeCode,
      'hasCheckedIn': hasCheckedIn,
      'entryMap': {},
    };
    entryMap.forEach((key, value) {
      json['entryMap'][key.toString()] = value.toJson();
    });
    return json;
  }
}

class TimeEntry {
  DateTime entryTime;
  DateTime exitTime;

  TimeEntry({required this.entryTime, required this.exitTime});

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      entryTime: DateTime.parse(json['entryTime']),
      exitTime: DateTime.parse(json['exitTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entryTime': entryTime.toIso8601String(),
      'exitTime': exitTime.toIso8601String(),
    };
  }
}
