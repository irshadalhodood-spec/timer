// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthSessionEntityImpl _$$AuthSessionEntityImplFromJson(
  Map<String, dynamic> json,
) => _$AuthSessionEntityImpl(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String?,
  user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
  organizationId: json['organizationId'] as String?,
  organizationInviteUrl: json['organizationInviteUrl'] as String?,
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$$AuthSessionEntityImplToJson(
  _$AuthSessionEntityImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'user': instance.user,
  'organizationId': instance.organizationId,
  'organizationInviteUrl': instance.organizationInviteUrl,
  'expiresAt': instance.expiresAt?.toIso8601String(),
};
