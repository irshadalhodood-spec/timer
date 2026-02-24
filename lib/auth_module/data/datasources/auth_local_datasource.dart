import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../base_module/data/app_database.dart';
import '../../domain/entites/auth_session_entity.dart';
import '../../domain/entites/user_entity.dart';

const _keyInviteUrl = 'org_invite_url';

class AuthLocalDatasource {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<AuthSessionEntity?> getSession() async {
    final db = await AppDatabase.database;
    final rows = await db.query('auth_session', limit: 1);
    if (rows.isEmpty) return null;
    final row = rows.first;
    final userJson = row['user_json'] as String?;
    if (userJson == null) return null;
    return AuthSessionEntity(
      accessToken: row['access_token'] as String,
      refreshToken: row['refresh_token'] as String?,
      user: UserEntity.fromJson(jsonDecode(userJson) as Map<String, dynamic>),
      organizationId: row['organization_id'] as String?,
      organizationInviteUrl: row['organization_invite_url'] as String?,
      expiresAt: row['expires_at'] != null ? DateTime.tryParse(row['expires_at'] as String) : null,
    );
  }

  Future<void> saveSession(AuthSessionEntity session) async {
    final db = await AppDatabase.database;
    await db.delete('auth_session');
    await db.insert('auth_session', {
      'access_token': session.accessToken,
      'refresh_token': session.refreshToken,
      'user_json': jsonEncode(session.user.toJson()),
      'organization_id': session.organizationId,
      'organization_invite_url': session.organizationInviteUrl,
      'expires_at': session.expiresAt?.toIso8601String(),
    });
  }

  Future<void> clearSession() async {
    final db = await AppDatabase.database;
    await db.delete('auth_session');
  }

  Future<void> saveOrganizationInviteUrl(String url) async {
    final prefs = await _prefs;
    await prefs.setString(_keyInviteUrl, url);
  }

  Future<String?> getOrganizationInviteUrl() async {
    final prefs = await _prefs;
    return prefs.getString(_keyInviteUrl);
  }
}
