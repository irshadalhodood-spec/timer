import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/datasources/auth_api.dart';
import '../../domain/entites/auth_session_entity.dart';
import '../../domain/entites/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

const _keyUsername = 'auth_username';
const _keyPassword = 'auth_password';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthLocalDatasource? local, AuthApi? api})
      : _local = local ?? AuthLocalDatasource(),
        _api = api,
        _storage = const FlutterSecureStorage();

  final AuthLocalDatasource _local;
  final AuthApi? _api;
  final FlutterSecureStorage _storage;

  @override
  Future<AuthSessionEntity?> getSession() => _local.getSession();

  @override
  Future<void> saveSession(AuthSessionEntity session) => _local.saveSession(session);

  @override
  Future<void> clearSession() async {
    await _local.clearSession();
  }

  @override
  Future<void> saveOrganizationInviteUrl(String url) => _local.saveOrganizationInviteUrl(url);

  @override
  Future<String?> getOrganizationInviteUrl() => _local.getOrganizationInviteUrl();

  @override
  Future<AuthSessionEntity?> login(String username, String password) async {
    if (username.isEmpty) return null;
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyPassword, value: password);
    final inviteUrl = await _local.getOrganizationInviteUrl();

    if (_api != null) {
      final response = await _api.login(username, password);
      if (response.success && response.data != null) {
        final loginData = response.data!;
        final session = AuthSessionEntity(
          accessToken: loginData.accessToken,
          refreshToken: loginData.refreshToken,
          user: loginData.user,
          organizationId: loginData.organizationId ?? _extractOrgIdFromInviteUrl(inviteUrl ?? '') ?? 'demo-org-xyz',
          organizationInviteUrl: inviteUrl,
          expiresAt: loginData.expiresAt ?? DateTime.now().add(const Duration(days: 365)),
        );
        await _local.saveSession(session);
        return session;
      }
    }

    final orgId = (inviteUrl != null && inviteUrl.isNotEmpty
            ? _extractOrgIdFromInviteUrl(inviteUrl)
            : null) ??
        'demo-org-xyz';
    final userId = username == 'demo_user' ? 'user_1' : 'local_${username}_${DateTime.now().millisecondsSinceEpoch}';
    final user = UserEntity(
      id: userId,
      username: username,
      fullName: username,
    );
    final session = AuthSessionEntity(
      accessToken: 'local_${DateTime.now().millisecondsSinceEpoch}',
      user: user,
      organizationId: orgId,
      organizationInviteUrl: inviteUrl,
      expiresAt: DateTime.now().add(const Duration(days: 365)),
    );
    await _local.saveSession(session);
    return session;
  }

  String? _extractOrgIdFromInviteUrl(String url) {
    if (url.isEmpty) return null;
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) return 'local_org';
      final id = uri.queryParameters['orgId'] ?? uri.pathSegments.lastOrNull ?? 'local_org';
      return id.isEmpty ? 'local_org' : id;
    } catch (_) {
      return 'local_org';
    }
  }
}
