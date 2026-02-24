// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserEntityImpl _$$UserEntityImplFromJson(Map<String, dynamic> json) =>
    _$UserEntityImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      fullName: json['fullName'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      jobTitle: json['jobTitle'] as String?,
      departmentId: json['departmentId'] as String?,
      departmentName: json['departmentName'] as String?,
      reportingManagerId: json['reportingManagerId'] as String?,
      joinDate: json['joinDate'] == null
          ? null
          : DateTime.parse(json['joinDate'] as String),
    );

Map<String, dynamic> _$$UserEntityImplToJson(_$UserEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'fullName': instance.fullName,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'jobTitle': instance.jobTitle,
      'departmentId': instance.departmentId,
      'departmentName': instance.departmentName,
      'reportingManagerId': instance.reportingManagerId,
      'joinDate': instance.joinDate?.toIso8601String(),
    };
