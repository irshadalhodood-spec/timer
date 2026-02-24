// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'break_record_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BreakRecordEntityImpl _$$BreakRecordEntityImplFromJson(
  Map<String, dynamic> json,
) => _$BreakRecordEntityImpl(
  id: json['id'] as String,
  attendanceId: json['attendanceId'] as String,
  userId: json['userId'] as String,
  startAt: DateTime.parse(json['startAt'] as String),
  endAt: json['endAt'] == null ? null : DateTime.parse(json['endAt'] as String),
  startAddress: json['startAddress'] as String?,
  endAddress: json['endAddress'] as String?,
  synced: json['synced'] as bool? ?? false,
  syncedAt: json['syncedAt'] == null
      ? null
      : DateTime.parse(json['syncedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$BreakRecordEntityImplToJson(
  _$BreakRecordEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'attendanceId': instance.attendanceId,
  'userId': instance.userId,
  'startAt': instance.startAt.toIso8601String(),
  'endAt': instance.endAt?.toIso8601String(),
  'startAddress': instance.startAddress,
  'endAddress': instance.endAddress,
  'synced': instance.synced,
  'syncedAt': instance.syncedAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
};
