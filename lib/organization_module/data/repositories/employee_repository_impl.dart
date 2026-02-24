import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_local_datasource.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  EmployeeRepositoryImpl({EmployeeLocalDatasource? local})
      : _local = local ?? EmployeeLocalDatasource();

  final EmployeeLocalDatasource _local;

  @override
  Future<List<EmployeeEntity>> getEmployeesByOrg(String orgId, {String? departmentId, String? search}) =>
      _local.getEmployeesByOrg(orgId, departmentId: departmentId, search: search);

  @override
  Future<EmployeeEntity?> getEmployeeById(String id) => _local.getEmployeeById(id);

  @override
  Future<void> saveEmployees(String orgId, List<EmployeeEntity> employees) =>
      _local.saveEmployees(employees, orgId);

  @override
  Future<void> saveEmployee(String orgId, EmployeeEntity employee) =>
      _local.saveEmployee(employee, orgId);
}
