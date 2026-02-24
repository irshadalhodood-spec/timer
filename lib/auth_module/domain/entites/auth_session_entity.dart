import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_entity.dart';

part 'auth_session_entity.freezed.dart';
part 'auth_session_entity.g.dart';

@freezed
class AuthSessionEntity with _$AuthSessionEntity {
  const factory AuthSessionEntity({
    required String accessToken,
    String? refreshToken,
    required UserEntity user,
    String? organizationId,
    String? organizationInviteUrl,
    DateTime? expiresAt,
  }) = _AuthSessionEntity;

  factory AuthSessionEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionEntityFromJson(json);
}
