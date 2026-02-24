import 'package:dio/dio.dart';

import '../../presentation/core/values/app_apis.dart';


class ApiClient {
  ApiClient({String? baseUrl}) : _dio = Dio(BaseOptions(
    baseUrl: baseUrl ?? AppApis.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
  ));

  final Dio _dio;
  String? _accessToken;

  Dio get dio => _dio;

  void setAccessToken(String? token) {
    _accessToken = token;
    _dio.interceptors.removeWhere((e) => e is _AuthInterceptor);
    if (token != null && token.isNotEmpty) {
      _dio.interceptors.add(_AuthInterceptor(token));
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
      _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._token);
  final String _token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $_token';
    handler.next(options);
  }
}
