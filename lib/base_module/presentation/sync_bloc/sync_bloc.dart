import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/sync_queue_entity.dart';
import '../../../attendance_module/domain/repositories/attendance_repository.dart';
import '../../../employee_track/domain/repositories/break_record_repository.dart';
import '../../domain/repositories/sync_queue_repository.dart';

part 'sync_event.dart';
part 'sync_state.dart';

/// Processes pending sync queue when online. API calls can be added later.
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  SyncBloc({
    required SyncQueueRepository syncQueueRepository,
    required AttendanceRepository attendanceRepository,
    required BreakRecordRepository breakRecordRepository,
  })  : _syncQueue = syncQueueRepository,
        _attendance = attendanceRepository,
        _breakRecord = breakRecordRepository,
        super(const SyncStateInitial()) {
    on<SyncTriggered>(_onSyncTriggered);
    on<SyncPendingCountRequested>(_onSyncPendingCountRequested);
  }

  final SyncQueueRepository _syncQueue;
  final AttendanceRepository _attendance;
  final BreakRecordRepository _breakRecord;

  Future<void> _onSyncTriggered(SyncTriggered event, Emitter<SyncState> emit) async {
    emit(SyncState.syncing);
    try {
      final pending = await _syncQueue.getPending();
      int synced = 0;
      for (final item in pending) {
        try {
          final success = await _processItem(item);
          if (success) {
            await _syncQueue.remove(item.id);
            synced++;
          } else {
            await _syncQueue.updateAttempt(
              item.copyWith(retryCount: item.retryCount + 1, lastAttemptAt: DateTime.now()),
              lastError: 'API not connected',
            );
          }
        } catch (e) {
          await _syncQueue.updateAttempt(
            item.copyWith(retryCount: item.retryCount + 1, lastAttemptAt: DateTime.now()),
            lastError: '$e',
          );
        }
      }
      emit(SyncState.synced(synced: synced, total: pending.length));
    } catch (e) {
      emit(SyncState.failed(error: e.toString()));
    }
  }

  Future<bool> _processItem(SyncQueueEntity item) async {
    // When API is connected, replace with real HTTP calls. For now we just mark local records as synced.
    final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>?;
    if (payload == null) return true;

    switch (item.entityType) {
      case SyncEntityType.attendance:
        final id = payload['id'] as String? ?? item.entityId;
        await _attendance.markSynced(id);
        return true;
      case SyncEntityType.breakRecord:
        final id = payload['id'] as String? ?? item.entityId;
        await _breakRecord.markSynced(id);
        return true;
      case SyncEntityType.checkIn:
      case SyncEntityType.checkOut:
        final id = payload['attendanceId'] as String? ?? item.entityId;
        await _attendance.markSynced(id);
        return true;
    }
  }

  Future<void> _onSyncPendingCountRequested(SyncPendingCountRequested event, Emitter<SyncState> emit) async {
    final count = await _syncQueue.pendingCount();
    emit(SyncState.pendingCount(count));
  }
}
