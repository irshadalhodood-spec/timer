// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DepartmentEntityImpl _$$DepartmentEntityImplFromJson(
  Map<String, dynamic> json,
) => _$DepartmentEntityImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  employeeCount: (json['employeeCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$$DepartmentEntityImplToJson(
  _$DepartmentEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'employeeCount': instance.employeeCount,
};

_$OrganizationEntityImpl _$$OrganizationEntityImplFromJson(
  Map<String, dynamic> json,
) => _$OrganizationEntityImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  logoUrl: json['logoUrl'] as String?,
  industry: json['industry'] as String?,
  registeredAddress: json['registeredAddress'] as String?,
  totalHeadcount: (json['totalHeadcount'] as num?)?.toInt(),
  departments:
      (json['departments'] as List<dynamic>?)
          ?.map((e) => DepartmentEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OrganizationEntityImplToJson(
  _$OrganizationEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logoUrl': instance.logoUrl,
  'industry': instance.industry,
  'registeredAddress': instance.registeredAddress,
  'totalHeadcount': instance.totalHeadcount,
  'departments': instance.departments,
};
