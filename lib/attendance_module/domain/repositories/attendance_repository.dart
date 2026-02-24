import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<AttendanceEntity?> getTodayCheckIn(String userId);
  Future<List<AttendanceEntity>> getAttendancesByUser(String userId, {DateTime? from, DateTime? to});
  Future<AttendanceEntity> saveAttendance(AttendanceEntity attendance);
  Future<void> markSynced(String attendanceId);
  Future<AttendanceEntity?> getById(String id);
}
