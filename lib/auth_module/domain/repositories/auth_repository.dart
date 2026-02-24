import '../entites/auth_session_entity.dart';

abstract class AuthRepository {
  Future<AuthSessionEntity?> getSession();
  Future<void> saveSession(AuthSessionEntity session);
  Future<void> clearSession();
  Future<void> saveOrganizationInviteUrl(String url);
  Future<String?> getOrganizationInviteUrl();
  Future<AuthSessionEntity?> login(String username, String password);
}
