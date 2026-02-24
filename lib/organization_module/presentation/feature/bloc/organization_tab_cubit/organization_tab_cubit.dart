import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_track/organization_module/domain/repositories/employee_repository.dart';
import 'package:employee_track/organization_module/domain/datasources/organization_api.dart';
import 'package:employee_track/organization_module/domain/repositories/organization_repository.dart';
import 'organization_tab_state.dart';

/// Cubit for organization tab: loads org + employees, and refetches only
/// employees when search/department change to avoid full scaffold refresh.
class OrganizationTabCubit extends Cubit<OrganizationTabState> {
  OrganizationTabCubit({
    required String orgId,
    required OrganizationApi api,
    required OrganizationRepository orgRepo,
    required EmployeeRepository empRepo,
  })  : _orgId = orgId,
        _api = api,
        _orgRepo = orgRepo,
        _empRepo = empRepo,
        super(const OrganizationTabState());

  final String _orgId;
  final OrganizationApi _api;
  final OrganizationRepository _orgRepo;
  final EmployeeRepository _empRepo;

  /// Initial load: sync from API, then load org + employees.
  Future<void> load() async {
    emit(state.copyWith(isInitialLoading: true));
    try {
      await _api.getOrganization(_orgId);
      await _api.getEmployees(_orgId);
      final org = await _orgRepo.getCurrentOrganization();
      final employees = await _empRepo.getEmployeesByOrg(
        _orgId,
        departmentId: state.selectedDepartmentId,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );
      emit(state.copyWith(
        organization: org,
        employees: employees,
        isInitialLoading: false,
        isEmployeesLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(
        organization: null,
        employees: const [],
        isInitialLoading: false,
        isEmployeesLoading: false,
      ));
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _loadEmployees();
  }

  void setSelectedDepartmentId(String? departmentId) {
    emit(state.copyWith(
      clearSelectedDepartmentId: departmentId == null,
      selectedDepartmentId: departmentId,
    ));
    _loadEmployees();
  }

  /// Refetch only employees; org and scaffold stay stable.
  Future<void> _loadEmployees() async {
    emit(state.copyWith(isEmployeesLoading: true));
    try {
      final employees = await _empRepo.getEmployeesByOrg(
        _orgId,
        departmentId: state.selectedDepartmentId,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );
      emit(state.copyWith(employees: employees, isEmployeesLoading: false));
    } catch (_) {
      emit(state.copyWith(employees: const [], isEmployeesLoading: false));
    }
  }
}
