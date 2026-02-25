
class AppApis {
  static const String baseUrl = 'https://trackme.com/api';
  static const String login = '/login';
  static const String organization = '/v1/organization';
  static const String employees = '/v1/employees';
  static const String attendanceHistory = '/v1/attendance/history';
  static const String attendanceBreaks = '/v1/attendance/breaks';
  /// Working hours / shift config: { "shiftStart": "08:00", "shiftEnd": "18:00" } or
  /// { "shiftStart": "20:00", "shiftEnd": "07:00", "endsNextDay": true }.
  static const String workingHours = '/v1/settings/working-hours';
}
