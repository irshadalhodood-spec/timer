import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeEntity>> getEmployeesByOrg(String orgId, {String? departmentId, String? search});
  Future<EmployeeEntity?> getEmployeeById(String id);
  Future<void> saveEmployees(String orgId, List<EmployeeEntity> employees);
  Future<void> saveEmployee(String orgId, EmployeeEntity employee);
}
