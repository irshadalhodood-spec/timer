import '../entities/break_record_entity.dart';

abstract class BreakRecordRepository {
  Future<List<BreakRecordEntity>> getByAttendanceId(String attendanceId);
  Future<BreakRecordEntity> saveBreakRecord(BreakRecordEntity record);
  Future<void> updateBreakRecord(BreakRecordEntity record);
  Future<void> markSynced(String breakRecordId);
}
