// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeEntityImpl _$$EmployeeEntityImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeEntityImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      jobTitle: json['jobTitle'] as String?,
      departmentId: json['departmentId'] as String?,
      departmentName: json['departmentName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      joinDate: json['joinDate'] == null
          ? null
          : DateTime.parse(json['joinDate'] as String),
      reportingManagerId: json['reportingManagerId'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
    );

Map<String, dynamic> _$$EmployeeEntityImplToJson(
  _$EmployeeEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'jobTitle': instance.jobTitle,
  'departmentId': instance.departmentId,
  'departmentName': instance.departmentName,
  'email': instance.email,
  'phone': instance.phone,
  'profilePhotoUrl': instance.profilePhotoUrl,
  'joinDate': instance.joinDate?.toIso8601String(),
  'reportingManagerId': instance.reportingManagerId,
  'isOnline': instance.isOnline,
};
