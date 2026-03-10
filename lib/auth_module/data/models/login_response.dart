import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entites/user_entity.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,
    String? refreshToken,
    @JsonKey(name: 'data') required UserEntity user,
    String? organizationId,
    DateTime? expiresAt,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
