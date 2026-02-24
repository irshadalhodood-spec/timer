import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_entity.freezed.dart';
part 'organization_entity.g.dart';

@freezed
class DepartmentEntity with _$DepartmentEntity {
  const factory DepartmentEntity({
    required String id,
    required String name,
    int? employeeCount,
  }) = _DepartmentEntity;

  factory DepartmentEntity.fromJson(Map<String, dynamic> json) =>
      _$DepartmentEntityFromJson(json);
}

@freezed
class OrganizationEntity with _$OrganizationEntity {
  const factory OrganizationEntity({
    required String id,
    required String name,
    String? logoUrl,
    String? industry,
    String? registeredAddress,
    int? totalHeadcount,
    @Default([]) List<DepartmentEntity> departments,
  }) = _OrganizationEntity;

  factory OrganizationEntity.fromJson(Map<String, dynamic> json) =>
      _$OrganizationEntityFromJson(json);
}
