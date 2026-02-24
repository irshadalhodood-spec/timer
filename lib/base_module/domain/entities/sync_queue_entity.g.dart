// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_queue_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncQueueEntityImpl _$$SyncQueueEntityImplFromJson(
  Map<String, dynamic> json,
) => _$SyncQueueEntityImpl(
  id: json['id'] as String,
  entityType: $enumDecode(_$SyncEntityTypeEnumMap, json['entityType']),
  action: $enumDecode(_$SyncActionEnumMap, json['action']),
  entityId: json['entityId'] as String,
  payloadJson: json['payloadJson'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
  lastError: json['lastError'] as String?,
  lastAttemptAt: json['lastAttemptAt'] == null
      ? null
      : DateTime.parse(json['lastAttemptAt'] as String),
);

Map<String, dynamic> _$$SyncQueueEntityImplToJson(
  _$SyncQueueEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'entityType': _$SyncEntityTypeEnumMap[instance.entityType]!,
  'action': _$SyncActionEnumMap[instance.action]!,
  'entityId': instance.entityId,
  'payloadJson': instance.payloadJson,
  'createdAt': instance.createdAt.toIso8601String(),
  'retryCount': instance.retryCount,
  'lastError': instance.lastError,
  'lastAttemptAt': instance.lastAttemptAt?.toIso8601String(),
};

const _$SyncEntityTypeEnumMap = {
  SyncEntityType.attendance: 'attendance',
  SyncEntityType.breakRecord: 'breakRecord',
  SyncEntityType.checkIn: 'checkIn',
  SyncEntityType.checkOut: 'checkOut',
};

const _$SyncActionEnumMap = {
  SyncAction.create: 'create',
  SyncAction.update: 'update',
  SyncAction.delete: 'delete',
};
