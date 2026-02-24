import 'package:dio/dio.dart';
import 'package:employee_track/base_module/domain/entities/translation.dart';
import 'package:flutter/material.dart';

import '../../presentation/core/values/app_apis.dart';
import 'shared_prefrences.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppApis.baseUrl, 
    connectTimeout:  const Duration(seconds:5000),
    receiveTimeout: const Duration(seconds:5000),
  ));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
         final token =  _getToken(); 
         debugPrint("API TOKEN : ${token.toString()}");
         options.headers['x-api-key'] = 'R%%%@!innovix33%@2.in&&.2class2';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException error, handler) {
     
         if (error.response?.statusCode == 401) {
         debugPrint('Unauthorized: Refresh token or prompt login.');
        } else {
         debugPrint('Error occurred: ${error.message}');
        }
        return handler.next(error); 
      },
    ));
  }
//GET request
 Future<dynamic> get(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.get(endpoint, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

  //POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data,);
      debugPrint("API RESPONSE : ${response.data}");
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

  // PUT request (Update)
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

  // PATCH request
  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.patch(endpoint, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

   Future<String?> _getToken() async {
    final prefs = await SharedPreferencesHelper.getString('auth_token'); 
    return prefs;
  }

  // Error Handling
  void _handleError(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw translation.of('connection_timeout');
          // 'Connection Timeout';
        case DioExceptionType.receiveTimeout:
          throw translation.of('receive_timeout');
        case DioExceptionType.badResponse:
          throw '${translation.of('server_error')} ${e.response?.statusCode}';
        case DioExceptionType.unknown:
          throw '${translation.of('unexpected_error')} ${e.message}';
        default:
          throw '${translation.of('error')} ${e.message}';
      }
    } else {
      throw 'Unknown Error: $e';
    }
  }
}
final apiService = ApiService();