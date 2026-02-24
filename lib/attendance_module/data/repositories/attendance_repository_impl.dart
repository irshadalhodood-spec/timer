import '../../domain/datasources/attendance_api.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_local_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  AttendanceRepositoryImpl({
    AttendanceLocalDatasource? local,
    AttendanceApi? api,
  })  : _local = local ?? AttendanceLocalDatasource(),
        _api = api;

  final AttendanceLocalDatasource _local;
  final AttendanceApi? _api;

  @override
  Future<AttendanceEntity?> getTodayCheckIn(String userId) =>
      _local.getTodayCheckIn(userId);

  @override
  Future<List<AttendanceEntity>> getAttendancesByUser(String userId, {DateTime? from, DateTime? to}) async {
    if (_api != null && from != null && to != null) {
      final response = await _api.getAttendanceHistory(
        userId: userId,
        from: from,
        to: to,
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw Exception(response.message ?? 'Failed to load attendance history');
    }
    return _local.getAttendancesByUser(userId, from: from, to: to);
  }

  @override
  Future<AttendanceEntity> saveAttendance(AttendanceEntity attendance) =>
      _local.saveAttendance(attendance);

  @override
  Future<void> markSynced(String attendanceId) => _local.markSynced(attendanceId);

  @override
  Future<AttendanceEntity?> getById(String id) => _local.getById(id);
}
