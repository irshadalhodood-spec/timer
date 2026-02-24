import '../../domain/entities/sync_queue_entity.dart';
import '../../domain/repositories/sync_queue_repository.dart';
import '../datasources/sync_queue_local_datasource.dart';

class SyncQueueRepositoryImpl implements SyncQueueRepository {
  SyncQueueRepositoryImpl({SyncQueueLocalDatasource? local})
      : _local = local ?? SyncQueueLocalDatasource();

  final SyncQueueLocalDatasource _local;

  @override
  Future<void> enqueue(SyncQueueEntity item) => _local.enqueue(item);

  @override
  Future<List<SyncQueueEntity>> getPending() => _local.getPending();

  @override
  Future<void> updateAttempt(SyncQueueEntity item, {String? lastError}) =>
      _local.updateAttempt(item, lastError: lastError);

  @override
  Future<void> remove(String id) => _local.remove(id);

  @override
  Future<int> pendingCount() => _local.pendingCount();

  @override
  Stream<int> watchPendingCount() => _local.watchPendingCount();
}
