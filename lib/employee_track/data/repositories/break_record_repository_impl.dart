import '../../domain/entities/break_record_entity.dart';
import '../../domain/repositories/break_record_repository.dart';
import '../datasources/break_record_local_datasource.dart';

class BreakRecordRepositoryImpl implements BreakRecordRepository {
  BreakRecordRepositoryImpl({BreakRecordLocalDatasource? local})
      : _local = local ?? BreakRecordLocalDatasource();

  final BreakRecordLocalDatasource _local;

  @override
  Future<List<BreakRecordEntity>> getByAttendanceId(String attendanceId) =>
      _local.getByAttendanceId(attendanceId);

  @override
  Future<BreakRecordEntity> saveBreakRecord(BreakRecordEntity record) =>
      _local.saveBreakRecord(record);

  @override
  Future<void> updateBreakRecord(BreakRecordEntity record) =>
      _local.updateBreakRecord(record);

  @override
  Future<void> markSynced(String breakRecordId) => _local.markSynced(breakRecordId);
}
