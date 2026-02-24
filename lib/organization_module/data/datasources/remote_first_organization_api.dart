import '../../../../base_module/domain/entities/api_response.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/datasources/organization_api.dart';
import '../../domain/entities/organization_entity.dart';
import 'json_organization_api.dart';
import 'trackme_organization_api.dart';

/// Tries TrackMe API first; on failure falls back to JSON asset.
class RemoteFirstOrganizationApi implements OrganizationApi {
  RemoteFirstOrganizationApi({
    required TrackMeOrganizationApi trackMe,
    required JsonOrganizationApi jsonFallback,
  })  : _trackMe = trackMe,
        _jsonFallback = jsonFallback;

  final TrackMeOrganizationApi _trackMe;
  final JsonOrganizationApi _jsonFallback;

  @override
  Future<ApiResponse<OrganizationEntity?>> getOrganization(String orgId) async {
    final response = await _trackMe.getOrganization(orgId);
    if (response.success) return response;
    return _jsonFallback.getOrganization(orgId);
  }

  @override
  Future<ApiResponse<List<EmployeeEntity>>> getEmployees(String orgId) async {
    final response = await _trackMe.getEmployees(orgId);
    if (response.success) return response;
    return _jsonFallback.getEmployees(orgId);
  }
}
