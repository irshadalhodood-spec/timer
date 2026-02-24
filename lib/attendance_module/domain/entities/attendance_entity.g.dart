// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceEntityImpl _$$AttendanceEntityImplFromJson(
  Map<String, dynamic> json,
) => _$AttendanceEntityImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  checkInAt: DateTime.parse(json['checkInAt'] as String),
  checkOutAt: json['checkOutAt'] == null
      ? null
      : DateTime.parse(json['checkOutAt'] as String),
  checkInLat: (json['checkInLat'] as num?)?.toDouble(),
  checkInLng: (json['checkInLng'] as num?)?.toDouble(),
  checkInAddress: json['checkInAddress'] as String?,
  checkOutLat: (json['checkOutLat'] as num?)?.toDouble(),
  checkOutLng: (json['checkOutLng'] as num?)?.toDouble(),
  checkOutAddress: json['checkOutAddress'] as String?,
  breakSeconds: (json['breakSeconds'] as num?)?.toInt() ?? 0,
  earlyCheckoutNote: json['earlyCheckoutNote'] as String?,
  isEarlyCheckout: json['isEarlyCheckout'] as bool? ?? false,
  deviceInfo: json['deviceInfo'] as String?,
  synced: json['synced'] as bool? ?? false,
  syncedAt: json['syncedAt'] == null
      ? null
      : DateTime.parse(json['syncedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$AttendanceEntityImplToJson(
  _$AttendanceEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'checkInAt': instance.checkInAt.toIso8601String(),
  'checkOutAt': instance.checkOutAt?.toIso8601String(),
  'checkInLat': instance.checkInLat,
  'checkInLng': instance.checkInLng,
  'checkInAddress': instance.checkInAddress,
  'checkOutLat': instance.checkOutLat,
  'checkOutLng': instance.checkOutLng,
  'checkOutAddress': instance.checkOutAddress,
  'breakSeconds': instance.breakSeconds,
  'earlyCheckoutNote': instance.earlyCheckoutNote,
  'isEarlyCheckout': instance.isEarlyCheckout,
  'deviceInfo': instance.deviceInfo,
  'synced': instance.synced,
  'syncedAt': instance.syncedAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
