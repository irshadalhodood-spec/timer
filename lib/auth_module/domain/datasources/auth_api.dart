import '../../../../base_module/domain/entities/api_response.dart';
import '../../data/models/login_response.dart';

abstract class AuthApi {
  Future<ApiResponse<LoginResponse?>> login(String username, String password);
}
