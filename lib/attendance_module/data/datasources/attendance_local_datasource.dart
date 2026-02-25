import 'package:sqflite/sqflite.dart';
import '../../../base_module/data/app_database.dart';
import '../../domain/entities/attendance_entity.dart';

class AttendanceLocalDatasource {
  static AttendanceEntity _rowToEntity(Map<String, dynamic> row) {
    return AttendanceEntity(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      checkInAt: DateTime.parse(row['check_in_at'] as String),
      checkOutAt: row['check_out_at'] != null ? DateTime.tryParse(row['check_out_at'] as String) : null,
      checkInLat: (row['check_in_lat'] as num?)?.toDouble(),
      checkInLng: (row['check_in_lng'] as num?)?.toDouble(),
      checkInAddress: row['check_in_address'] as String?,
      checkOutLat: (row['check_out_lat'] as num?)?.toDouble(),
      checkOutLng: (row['check_out_lng'] as num?)?.toDouble(),
      checkOutAddress: row['check_out_address'] as String?,
      breakSeconds: (row['break_seconds'] as int?) ?? 0,
      earlyCheckoutNote: row['early_checkout_note'] as String?,
      isEarlyCheckout: (row['is_early_checkout'] as int?) == 1,
      isAutoCheckout: (row['is_auto_checkout'] as int?) == 1,
      deviceInfo: row['device_info'] as String?,
      synced: (row['synced'] as int?) == 1,
      syncedAt: row['synced_at'] != null ? DateTime.tryParse(row['synced_at'] as String) : null,
      createdAt: row['created_at'] != null ? DateTime.tryParse(row['created_at'] as String) : null,
      updatedAt: row['updated_at'] != null ? DateTime.tryParse(row['updated_at'] as String) : null,
    );
  }

  static Map<String, Object?> _entityToRow(AttendanceEntity e) {
    return {
      'id': e.id,
      'user_id': e.userId,
      'check_in_at': e.checkInAt.toIso8601String(),
      'check_out_at': e.checkOutAt?.toIso8601String(),
      'check_in_lat': e.checkInLat,
      'check_in_lng': e.checkInLng,
      'check_in_address': e.checkInAddress,
      'check_out_lat': e.checkOutLat,
      'check_out_lng': e.checkOutLng,
      'check_out_address': e.checkOutAddress,
      'break_seconds': e.breakSeconds,
      'early_checkout_note': e.earlyCheckoutNote,
      'is_early_checkout': e.isEarlyCheckout ? 1 : 0,
      'is_auto_checkout': e.isAutoCheckout ? 1 : 0,
      'device_info': e.deviceInfo,
      'synced': e.synced ? 1 : 0,
      'synced_at': e.syncedAt?.toIso8601String(),
      'created_at': e.createdAt?.toIso8601String(),
      'updated_at': e.updatedAt?.toIso8601String(),
    };
  }

  Future<AttendanceEntity?> getTodayCheckIn(String userId) async {
    final db = await AppDatabase.database;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final rows = await db.query(
      'attendances',
      where: 'user_id = ? AND check_in_at >= ? AND check_in_at < ? AND check_out_at IS NULL',
      whereArgs: [userId, start.toIso8601String(), end.toIso8601String()],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _rowToEntity(rows.first as Map<String, dynamic>);
  }

  /// Returns any open (unchecked-out) attendance, e.g. from yesterday if user didn't check out.
  Future<AttendanceEntity?> getOpenAttendance(String userId) async {
    final db = await AppDatabase.database;
    final rows = await db.query(
      'attendances',
      where: 'user_id = ? AND check_out_at IS NULL',
      whereArgs: [userId],
      orderBy: 'check_in_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _rowToEntity(rows.first as Map<String, dynamic>);
  }

  Future<List<AttendanceEntity>> getAttendancesByUser(String userId, {DateTime? from, DateTime? to}) async {
    final db = await AppDatabase.database;
    String where = 'user_id = ?';
    List<Object?> args = [userId];
    if (from != null) {
      where += ' AND check_in_at >= ?';
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where += ' AND check_in_at < ?';
      args.add(to.toIso8601String());
    }
    final rows = await db.query('attendances', where: where, whereArgs: args, orderBy: 'check_in_at DESC');
    return rows.map((r) => _rowToEntity(r as Map<String, dynamic>)).toList();
  }

  Future<AttendanceEntity> saveAttendance(AttendanceEntity attendance) async {
    final db = await AppDatabase.database;
    await db.insert('attendances', _entityToRow(attendance), conflictAlgorithm: ConflictAlgorithm.replace);
    return attendance;
  }

  Future<void> markSynced(String attendanceId) async {
    final db = await AppDatabase.database;
    await db.update('attendances', {'synced': 1, 'synced_at': DateTime.now().toIso8601String()}, where: 'id = ?', whereArgs: [attendanceId]);
  }

  Future<AttendanceEntity?> getById(String id) async {
    final db = await AppDatabase.database;
    final rows = await db.query('attendances', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return _rowToEntity(rows.first as Map<String, dynamic>);
  }
}
