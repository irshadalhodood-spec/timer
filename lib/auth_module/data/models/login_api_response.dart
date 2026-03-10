/// Raw API response for POST /api/login.
/// Shape: { "status": true, "data": [{ "user_id": 9, "username": "...", "admin_user": false }], "message": "..." }
class LoginApiResponse {
  const LoginApiResponse({
    required this.status,
    this.data = const [],
    this.message,
  });

  final bool status;
  final List<LoginUserData> data;
  final String? message;

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) {
    final dataRaw = json['data'];
    List<LoginUserData> dataList = [];
    if (dataRaw is List && dataRaw.isNotEmpty) {
      for (final item in dataRaw) {
        if (item is Map<String, dynamic>) {
          dataList.add(LoginUserData.fromJson(item));
        }
      }
    } else if (dataRaw is Map<String, dynamic>) {
      dataList = [LoginUserData.fromJson(dataRaw)];
    }
    return LoginApiResponse(
      status: json['status'] == true || json['status'] == 'true',
      data: dataList,
      message: json['message'] as String?,
    );
  }
}

/// User object inside login API response "data" array.
class LoginUserData {
  const LoginUserData({
    required this.userId,
    required this.username,
    this.adminUser,
    this.email,
  });

  final String userId;
  final String username;
  final bool? adminUser;
  final String? email;

  factory LoginUserData.fromJson(Map<String, dynamic> json) {
    final userId = json['user_id'] ?? json['id'];
    return LoginUserData(
      userId: userId?.toString() ?? '',
      username: json['username'] as String? ?? '',
      adminUser: json['admin_user'] as bool?,
      email: json['email'] as String?,
    );
  }
}
