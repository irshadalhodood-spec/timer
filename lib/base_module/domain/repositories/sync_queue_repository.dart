import '../entities/sync_queue_entity.dart';

abstract class SyncQueueRepository {
  Future<void> enqueue(SyncQueueEntity item);
  Future<List<SyncQueueEntity>> getPending();
  Future<void> updateAttempt(SyncQueueEntity item, {String? lastError});
  Future<void> remove(String id);
  Future<int> pendingCount();
  Stream<int> watchPendingCount();
}
