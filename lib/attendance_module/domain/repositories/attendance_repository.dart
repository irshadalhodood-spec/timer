import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<AttendanceEntity?> getTodayCheckIn(String userId);
  /// Any open (unchecked-out) session, e.g. from a previous day.
  Future<AttendanceEntity?> getOpenAttendance(String userId);
  Future<List<AttendanceEntity>> getAttendancesByUser(String userId, {DateTime? from, DateTime? to});
  Future<AttendanceEntity> saveAttendance(AttendanceEntity attendance);
  Future<void> markSynced(String attendanceId);
  Future<AttendanceEntity?> getById(String id);
}
