import 'package:dio/dio.dart';

import '../../../../base_module/domain/entities/api_response.dart';
import '../../../../base_module/data/network/api_client.dart';
import '../../../../base_module/presentation/core/values/app_apis.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../domain/datasources/organization_api.dart';
import '../../domain/entities/organization_entity.dart';
import '../../domain/repositories/organization_repository.dart';

/// Fetches organization and employees from TrackMe API; persists via repos; returns Freezed entities.
class TrackMeOrganizationApi implements OrganizationApi {
  TrackMeOrganizationApi({
    required OrganizationRepository organizationRepository,
    required EmployeeRepository employeeRepository,
    ApiClient? apiClient,
  })  : _orgRepo = organizationRepository,
        _empRepo = employeeRepository,
        _client = apiClient ?? ApiClient();

  final OrganizationRepository _orgRepo;
  final EmployeeRepository _empRepo;
  final ApiClient _client;

  @override
  Future<ApiResponse<OrganizationEntity?>> getOrganization(String orgId) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        AppApis.organization,
        queryParameters: {'orgId': orgId},
      );
      final map = response.data;
      if (map == null) {
        return ApiResponse.failure(message: 'Empty response', statusCode: response.statusCode);
      }
      final apiResponse = ApiResponse.fromJson<OrganizationEntity?>(
        map,
        fromJsonData: (dynamic data) {
          if (data == null) return null;
          if (data is! Map<String, dynamic>) return null;
          return OrganizationEntity.fromJson(data);
        },
      );
      if (apiResponse.success && apiResponse.data != null) {
        await _orgRepo.saveOrganization(apiResponse.data!);
      }
      return apiResponse;
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

  @override
  Future<ApiResponse<List<EmployeeEntity>>> getEmployees(String orgId) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        AppApis.employees,
        queryParameters: {'orgId': orgId},
      );
      final map = response.data;
      if (map == null) {
        return ApiResponse.failure(message: 'Empty response', statusCode: response.statusCode);
      }
      final apiResponse = ApiResponse.fromJson<List<EmployeeEntity>>(
        map,
        fromJsonData: (dynamic data) {
          if (data == null) return <EmployeeEntity>[];
          if (data is! List) return <EmployeeEntity>[];
          return data
              .map((e) => EmployeeEntity.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
      if (apiResponse.success && apiResponse.data != null) {
        await _empRepo.saveEmployees(orgId, apiResponse.data!);
      }
      return apiResponse;
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
