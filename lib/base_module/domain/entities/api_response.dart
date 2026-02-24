/// Represents a typical API call response structure.
/// Use for binding UI to API-style responses (mock or real).
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  factory ApiResponse.success({T? data, int? statusCode}) =>
      ApiResponse<T>(success: true, data: data, statusCode: statusCode ?? 200);

  factory ApiResponse.failure({String? message, int? statusCode}) =>
      ApiResponse<T>(success: false, message: message ?? 'Unknown error', statusCode: statusCode ?? 500);

  /// Map from JSON-like structure: { "success": true, "data": [...], "message": null }
  static ApiResponse<T> fromJson<T>(
    Map<String, dynamic> json, {
    required T? Function(dynamic)? fromJsonData,
  }) {
    final success = json['success'] as bool? ?? false;
    final message = json['message'] as String?;
    final statusCode = json['statusCode'] as int?;
    T? data;
    if (json['data'] != null && fromJsonData != null) {
      data = fromJsonData(json['data']);
    }
    return ApiResponse<T>(
      success: success,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }
}
