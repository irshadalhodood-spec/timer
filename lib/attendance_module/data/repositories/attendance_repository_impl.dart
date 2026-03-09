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
  Future<AttendanceEntity?> getOpenAttendance(String userId) =>
      _local.getOpenAttendance(userId);

  /// Local-first: always reads from local DB. Use [refreshAttendanceHistoryFromApi] to sync from REST API.
  @override
  Future<List<AttendanceEntity>> getAttendancesByUser(String userId, {DateTime? from, DateTime? to}) =>
      _local.getAttendancesByUser(userId, from: from, to: to);

  /// Fetches from REST API and merges into local DB (API layer writes to local). No-op if API is null.
  @override
  Future<void> refreshAttendanceHistoryFromApi(String userId, DateTime from, DateTime to) async {
    if (_api == null) return;
    final response = await _api.getAttendanceHistory(
      userId: userId,
      from: from,
      to: to,
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to refresh attendance from API');
    }
  }

  @override
  Future<AttendanceEntity> saveAttendance(AttendanceEntity attendance) =>
      _local.saveAttendance(attendance);

  @override
  Future<void> markSynced(String attendanceId) => _local.markSynced(attendanceId);

  @override
  Future<AttendanceEntity?> getById(String id) => _local.getById(id);
}
