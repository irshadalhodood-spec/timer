import 'package:dio/dio.dart';

import '../../presentation/core/values/app_apis.dart';

/// HTTP client for API calls. Uses [AppApis.baseUrl] by default.
/// After login, call [setAccessToken] with the session ID so subsequent
/// requests send the Cookie header.
class ApiClient {
  ApiClient({String? baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? AppApis.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: <String, dynamic>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );

  final Dio _dio;

  Dio get dio => _dio;

  /// Sets the session ID for cookie-based auth. Sends "Cookie: session_id=value"
  /// on every request. Pass null or empty to clear.
  void setAccessToken(String? sessionId) {
    _dio.interceptors.removeWhere((e) => e is _AuthInterceptor);
    final value = sessionId?.trim();
    if (value != null && value.isNotEmpty) {
      _dio.interceptors.add(_AuthInterceptor(value));
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._sessionId);
  final String _sessionId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Cookie'] = 'session_id=$_sessionId';
    handler.next(options);
  }
}
