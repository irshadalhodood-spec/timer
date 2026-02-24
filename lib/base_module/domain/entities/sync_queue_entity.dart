import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_queue_entity.freezed.dart';
part 'sync_queue_entity.g.dart';

enum SyncEntityType { attendance, breakRecord, checkIn, checkOut }

enum SyncAction { create, update, delete }

@freezed
class SyncQueueEntity with _$SyncQueueEntity {
  const factory SyncQueueEntity({
    required String id,
    required SyncEntityType entityType,
    required SyncAction action,
    required String entityId,
    required String payloadJson,
    required DateTime createdAt,
    @Default(0) int retryCount,
    String? lastError,
    DateTime? lastAttemptAt,
  }) = _SyncQueueEntity;

  factory SyncQueueEntity.fromJson(Map<String, dynamic> json) =>
      _$SyncQueueEntityFromJson(json);
}
