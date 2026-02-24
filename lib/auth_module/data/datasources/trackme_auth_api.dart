import 'package:dio/dio.dart';

import '../../../../base_module/domain/entities/api_response.dart';
import '../../../../base_module/data/network/api_client.dart';
import '../../../../base_module/presentation/core/values/app_apis.dart';
import '../../domain/datasources/auth_api.dart';
import '../../domain/entites/login_response.dart';


class TrackMeAuthApi implements AuthApi {
  TrackMeAuthApi({ApiClient? apiClient})
      : _client = apiClient ?? ApiClient();

  final ApiClient _client;

  @override
  Future<ApiResponse<LoginResponse?>> login(String username, String password) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        AppApis.login,
        data: {'username': username, 'password': password},
      );
      final map = response.data;
      if (map == null) {
        return ApiResponse.failure(message: 'Empty response', statusCode: response.statusCode);
      }
      return ApiResponse.fromJson<LoginResponse?>(
        map,
        fromJsonData: (dynamic data) {
          if (data == null) return null;
          if (data is! Map<String, dynamic>) return null;
          return LoginResponse.fromJson(data);
        },
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 500;
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message'] as String? ?? e.message
          : e.message ?? 'Network error';
      return ApiResponse.failure(message: message, statusCode: statusCode);
    } catch (e) {
      return ApiResponse.failure(message: e.toString(), statusCode: 500);
    }
  }
}
