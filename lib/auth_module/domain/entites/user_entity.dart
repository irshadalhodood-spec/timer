import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String username,
    String? email,
    String? phone,
    String? fullName,
    String? profilePhotoUrl,
    String? jobTitle,
    String? departmentId,
    String? departmentName,
    String? reportingManagerId,
    DateTime? joinDate,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
