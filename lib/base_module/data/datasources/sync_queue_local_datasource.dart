import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../../domain/entities/sync_queue_entity.dart';

class SyncQueueLocalDatasource {
  static SyncEntityType _parseEntityType(String? s) {
    if (s == null) return SyncEntityType.attendance;
    for (final e in SyncEntityType.values) {
      if (_entityTypeToString(e) == s) return e;
    }
    return SyncEntityType.attendance;
  }

  static SyncAction _parseAction(String? s) {
    if (s == null) return SyncAction.create;
    for (final e in SyncAction.values) {
      if (_actionToString(e) == s) return e;
    }
    return SyncAction.create;
  }

  static SyncQueueEntity _rowToEntity(Map<String, dynamic> row) {
    return SyncQueueEntity(
      id: row['id'] as String,
      entityType: _parseEntityType(row['entity_type'] as String?),
      action: _parseAction(row['action'] as String?),
      entityId: row['entity_id'] as String,
      payloadJson: row['payload_json'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
      retryCount: (row['retry_count'] as int?) ?? 0,
      lastError: row['last_error'] as String?,
      lastAttemptAt: row['last_attempt_at'] != null ? DateTime.tryParse(row['last_attempt_at'] as String) : null,
    );
  }

  static String _entityTypeToString(SyncEntityType t) {
    switch (t) {
      case SyncEntityType.attendance: return 'attendance';
      case SyncEntityType.breakRecord: return 'breakRecord';
      case SyncEntityType.checkIn: return 'checkIn';
      case SyncEntityType.checkOut: return 'checkOut';
    }
  }

  static String _actionToString(SyncAction a) {
    switch (a) {
      case SyncAction.create: return 'create';
      case SyncAction.update: return 'update';
      case SyncAction.delete: return 'delete';
    }
  }

  Future<void> enqueue(SyncQueueEntity item) async {
    final db = await AppDatabase.database;
    await db.insert('sync_queue', {
      'id': item.id,
      'entity_type': _entityTypeToString(item.entityType),
      'action': _actionToString(item.action),
      'entity_id': item.entityId,
      'payload_json': item.payloadJson,
      'created_at': item.createdAt.toIso8601String(),
      'retry_count': item.retryCount,
      'last_error': item.lastError,
      'last_attempt_at': item.lastAttemptAt?.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SyncQueueEntity>> getPending() async {
    final db = await AppDatabase.database;
    final rows = await db.query('sync_queue', orderBy: 'created_at ASC');
    return rows.map((r) => _rowToEntity(r as Map<String, dynamic>)).toList();
  }

  Future<void> updateAttempt(SyncQueueEntity item, {String? lastError}) async {
    final db = await AppDatabase.database;
    await db.update('sync_queue', {
      'retry_count': item.retryCount,
      'last_error': lastError ?? item.lastError,
      'last_attempt_at': DateTime.now().toIso8601String(),
    }, where: 'id = ?', whereArgs: [item.id]);
  }

  Future<void> remove(String id) async {
    final db = await AppDatabase.database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> pendingCount() async {
    final db = await AppDatabase.database;
    final r = await db.rawQuery('SELECT COUNT(*) as c FROM sync_queue');
    return (r.first['c'] as int?) ?? 0;
  }

  Stream<int> watchPendingCount() async* {
    while (true) {
      yield await pendingCount();
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }
}
