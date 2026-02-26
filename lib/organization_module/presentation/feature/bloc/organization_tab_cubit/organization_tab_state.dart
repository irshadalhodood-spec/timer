import 'package:equatable/equatable.dart';
import 'package:employee_track/organization_module/domain/entities/employee_entity.dart';
import 'package:employee_track/organization_module/domain/entities/organization_entity.dart';


class OrganizationTabState extends Equatable {
  const OrganizationTabState({
    this.organization,
    this.employees = const [],
    this.isInitialLoading = true,
    this.isEmployeesLoading = false,
    this.searchQuery = '',
    this.selectedDepartmentId,
  });

  final OrganizationEntity? organization;
  final List<EmployeeEntity> employees;
  final bool isInitialLoading;
  final bool isEmployeesLoading;
  final String searchQuery;
  final String? selectedDepartmentId;

  OrganizationTabState copyWith({
    OrganizationEntity? organization,
    List<EmployeeEntity>? employees,
    bool? isInitialLoading,
    bool? isEmployeesLoading,
    String? searchQuery,
    String? selectedDepartmentId,
    bool clearSelectedDepartmentId = false,
  }) {
    return OrganizationTabState(
      organization: organization ?? this.organization,
      employees: employees ?? this.employees,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isEmployeesLoading: isEmployeesLoading ?? this.isEmployeesLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDepartmentId: clearSelectedDepartmentId ? null : (selectedDepartmentId ?? this.selectedDepartmentId),
    );
  }

  @override
  List<Object?> get props => [
        organization,
        employees,
        isInitialLoading,
        isEmployeesLoading,
        searchQuery,
        selectedDepartmentId,
      ];
}
