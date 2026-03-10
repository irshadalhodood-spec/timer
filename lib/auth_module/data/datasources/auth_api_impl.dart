import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../base_module/domain/entities/api_response.dart';
import '../../../../base_module/data/network/api_client.dart';
import '../../../../base_module/presentation/core/values/app_apis.dart';
import '../../domain/datasources/auth_api.dart';
import '../models/login_request.dart';
import '../models/login_api_response.dart';
import '../models/login_response.dart';
import '../../domain/entites/user_entity.dart';

class TrackMeAuthApi implements AuthApi {
  TrackMeAuthApi({ApiClient? apiClient})
      : _client = apiClient ?? ApiClient();

  final ApiClient _client;

  @override
  Future<ApiResponse<LoginResponse?>> login(String username, String password) async {
          debugPrint("USERLOGINS AUTH-API-IMPL:- $username--$password");
    try {
      final request = LoginRequest(username: username, password: password);
      final response = await _client.post<Map<String, dynamic>>(
        AppApis.login,
        data: request.toJson(),
      );
                debugPrint("USERLOGINS AUTH-API-IMPL RES:-  $response--$username--$password");

      final map = response.data;
      if (map == null) {
        return ApiResponse.failure(message: 'Empty response', statusCode: response.statusCode);
      }

      final apiResponse = LoginApiResponse.fromJson(map);
      if (!apiResponse.status) {
        return ApiResponse.failure(
          message: apiResponse.message ?? 'Login failed',
          statusCode: response.statusCode ?? 401,
        );
        
      }

      if (apiResponse.data.isEmpty) {
        return ApiResponse.failure(
          message: apiResponse.message ?? 'Invalid response: missing user data',
          statusCode: response.statusCode ?? 400,
        );
      }

      final userData = apiResponse.data.first;
      final user = UserEntity(
        userId: userData.userId,
        username: userData.username,
        email: userData.email ?? (username.contains('@') ? username : null),
        adminUser: userData.adminUser,
      );

      String? sessionId = _getSessionIdFromHeaders(response.headers);
      if (sessionId == null || sessionId.isEmpty) {
        sessionId = user.userId;
      }
      _client.setAccessToken(sessionId);

      final loginResponse = LoginResponse(
        accessToken: sessionId,
        refreshToken: null,
        user: user,
        organizationId: null,
        expiresAt: DateTime.now().add(const Duration(days: 365)),
      );
      return ApiResponse.success(data: loginResponse, statusCode: response.statusCode ?? 200);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 500;
      final message = _extractErrorMessage(e);
      return ApiResponse.failure(message: message, statusCode: statusCode);
    } catch (e) {
      return ApiResponse.failure(message: e.toString(), statusCode: 500);
    }
  }

  /// Extract user-facing message from DioException (response body or connection error).
  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String? ??
          data['msg'] as String?;
      if (msg != null && msg.toString().trim().isNotEmpty) return msg;
    }
    if (e.response?.statusMessage != null && e.response!.statusMessage!.trim().isNotEmpty) {
      return e.response!.statusMessage!;
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Check your network.';
      case DioExceptionType.connectionError:
        return 'Cannot reach server. Check network or try again.';
      case DioExceptionType.badResponse:
        return 'Server error (${e.response?.statusCode ?? 'unknown'}).';
      default:
        return e.message ?? 'Login failed';
    }
  }

  String? _getSessionIdFromHeaders(Headers headers) {
    final setCookie = headers.value('set-cookie') ?? headers.value('Set-Cookie');
    if (setCookie == null) return null;
    const prefix = 'session_id=';
    final start = setCookie.indexOf(prefix);
    if (start < 0) return null;
    final valueStart = start + prefix.length;
    final end = setCookie.indexOf(';', valueStart);
    if (end < 0) return setCookie.substring(valueStart).trim();
    return setCookie.substring(valueStart, end).trim();
  }
}
