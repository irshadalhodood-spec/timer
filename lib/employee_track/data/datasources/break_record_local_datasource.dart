import 'package:sqflite/sqflite.dart';
import '../../../base_module/data/app_database.dart';
import '../../domain/entities/break_record_entity.dart';

class BreakRecordLocalDatasource {
  static BreakRecordEntity _rowToEntity(Map<String, dynamic> row) {
    return BreakRecordEntity(
      id: row['id'] as String,
      attendanceId: row['attendance_id'] as String,
      userId: row['user_id'] as String,
      startAt: DateTime.parse(row['start_at'] as String),
      endAt: row['end_at'] != null ? DateTime.tryParse(row['end_at'] as String) : null,
      startAddress: row['start_address'] as String?,
      endAddress: row['end_address'] as String?,
      synced: (row['synced'] as int?) == 1,
      syncedAt: row['synced_at'] != null ? DateTime.tryParse(row['synced_at'] as String) : null,
      createdAt: row['created_at'] != null ? DateTime.tryParse(row['created_at'] as String) : null,
    );
  }

  static Map<String, Object?> _entityToRow(BreakRecordEntity e) {
    return {
      'id': e.id,
      'attendance_id': e.attendanceId,
      'user_id': e.userId,
      'start_at': e.startAt.toIso8601String(),
      'end_at': e.endAt?.toIso8601String(),
      'start_address': e.startAddress,
      'end_address': e.endAddress,
      'synced': e.synced ? 1 : 0,
      'synced_at': e.syncedAt?.toIso8601String(),
      'created_at': e.createdAt?.toIso8601String(),
    };
  }

  Future<List<BreakRecordEntity>> getByAttendanceId(String attendanceId) async {
    final db = await AppDatabase.database;
    final rows = await db.query('break_records', where: 'attendance_id = ?', whereArgs: [attendanceId], orderBy: 'start_at ASC');
    return rows.map((r) => _rowToEntity(r as Map<String, dynamic>)).toList();
  }

  Future<BreakRecordEntity> saveBreakRecord(BreakRecordEntity record) async {
    final db = await AppDatabase.database;
    await db.insert('break_records', _entityToRow(record), conflictAlgorithm: ConflictAlgorithm.replace);
    return record;
  }

  Future<void> updateBreakRecord(BreakRecordEntity record) async {
    final db = await AppDatabase.database;
    await db.update('break_records', _entityToRow(record), where: 'id = ?', whereArgs: [record.id]);
  }

  Future<void> markSynced(String breakRecordId) async {
    final db = await AppDatabase.database;
    await db.update('break_records', {'synced': 1, 'synced_at': DateTime.now().toIso8601String()}, where: 'id = ?', whereArgs: [breakRecordId]);
  }
}
