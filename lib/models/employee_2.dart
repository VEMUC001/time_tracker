class Employee2 {
  String fullName;
  String employeeCode;
  bool hasCheckedIn = false;
  Map<String, TimeEntry> entryMap;
  Map<String, bool> paidPerWeek;

  Employee2({
    required this.fullName,
    required this.employeeCode,
    required this.hasCheckedIn,
    required this.entryMap,
    required this.paidPerWeek,
  });

  factory Employee2.fromJson(Map<String, dynamic> json) {
    Map<String, TimeEntry> entryMap = {};
    Map<String, bool> paidPerWeek = {};

    if (json['entryMap'] != null) {
      Map<String, dynamic> entryJsonMap =
          Map<String, dynamic>.from(json['entryMap']);
      entryJsonMap.forEach((key, entryJson) {
        TimeEntry entry = TimeEntry.fromJson(
          Map<String, dynamic>.from(entryJson),
        );
        entryMap[key] = entry;
      });
    }

    if (json['paidPerWeek'] != null) {
      Map<String, dynamic> entryJsonMap =
          Map<String, dynamic>.from(json['paidPerWeek']);
      entryJsonMap.forEach((key, booleanJson) {
        entryMap[key] = booleanJson;
      });
    }
    return Employee2(
      fullName: json['fullName'],
      employeeCode: json['employeeCode'],
      hasCheckedIn: json['hasCheckedIn'],
      entryMap: entryMap,
      paidPerWeek: paidPerWeek,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> entryJsonMap = {};
    entryMap.forEach((key, value) {
      entryJsonMap[key] = value.toJson();
    });
    return {
      'fullName': fullName,
      'employeeCode': employeeCode,
      'hasCheckedIn': hasCheckedIn,
      'entryMap': entryJsonMap,
    };
  }
}

class TimeEntry {
  DateTime? entryTime;
  DateTime? exitTime;

  TimeEntry({this.entryTime, this.exitTime});

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      entryTime:
          json['entryTime'] != null ? DateTime.parse(json['entryTime']) : null,
      exitTime:
          json['exitTime'] != null ? DateTime.parse(json['exitTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entryTime': entryTime?.toIso8601String(),
      'exitTime': exitTime?.toIso8601String(),
    };
  }
}
