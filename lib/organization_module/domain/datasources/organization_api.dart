import '../../../../base_module/domain/entities/api_response.dart';
import '../entities/employee_entity.dart';
import '../entities/organization_entity.dart';

/// Contract for fetching organization and employees from an API (real or JSON).
abstract class OrganizationApi {
  Future<ApiResponse<OrganizationEntity?>> getOrganization(String orgId);
  Future<ApiResponse<List<EmployeeEntity>>> getEmployees(String orgId);
}
