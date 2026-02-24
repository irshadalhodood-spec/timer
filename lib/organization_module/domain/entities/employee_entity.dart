import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_entity.freezed.dart';
part 'employee_entity.g.dart';

@freezed
class EmployeeEntity with _$EmployeeEntity {
  const factory EmployeeEntity({
    required String id,
    required String fullName,
    String? jobTitle,
    String? departmentId,
    String? departmentName,
    String? email,
    String? phone,
    String? profilePhotoUrl,
    DateTime? joinDate,
    String? reportingManagerId,
    @JsonKey(includeFromJson: false, includeToJson: false) 
    EmployeeEntity? reportingManager,
    @Default(false) bool isOnline,
  }) = _EmployeeEntity;

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) =>
      _$EmployeeEntityFromJson(json);
}
