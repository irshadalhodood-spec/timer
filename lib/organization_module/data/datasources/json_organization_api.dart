import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../base_module/domain/entities/api_response.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/datasources/organization_api.dart';
import '../../domain/entities/organization_entity.dart';
import '../../domain/repositories/organization_repository.dart';
import '../../domain/repositories/employee_repository.dart';

class JsonOrganizationApi implements OrganizationApi {
  JsonOrganizationApi({
    required OrganizationRepository organizationRepository,
    required EmployeeRepository employeeRepository,
    this.assetPath = 'lib/base_module/data/assets/api_endpoints.json',
  })  : _orgRepo = organizationRepository,
        _empRepo = employeeRepository;

  final OrganizationRepository _orgRepo;
  final EmployeeRepository _empRepo;
  final String assetPath;

  Map<String, dynamic>? _cachedJson;

  Future<Map<String, dynamic>> _loadJson() async {
    if (_cachedJson != null) return _cachedJson!;
    final String jsonString = await rootBundle.loadString(assetPath);
    _cachedJson = jsonDecode(jsonString) as Map<String, dynamic>;
    return _cachedJson!;
  }

  @override
  Future<ApiResponse<OrganizationEntity?>> getOrganization(String orgId) async {
    try {
      final map = await _loadJson();
      final endpoints = map['endpoints'] as Map<String, dynamic>?;
      if (endpoints == null) return ApiResponse.failure(message: 'Invalid API JSON', statusCode: 500);

      final orgEndpoint = endpoints['organization'] as Map<String, dynamic>?;
      final response = orgEndpoint?['response'] as Map<String, dynamic>?;
      final data = response?['data'] as Map<String, dynamic>?;
      if (data == null) return ApiResponse.success(data: null, statusCode: 200);

      final org = OrganizationEntity.fromJson(data);
      await _orgRepo.saveOrganization(org);
      return ApiResponse.success(data: org, statusCode: 200);
    } catch (e) {
      return ApiResponse.failure(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<List<EmployeeEntity>>> getEmployees(String orgId) async {
    try {
      final map = await _loadJson();
      final endpoints = map['endpoints'] as Map<String, dynamic>?;
      if (endpoints == null) return ApiResponse.failure(message: 'Invalid API JSON', statusCode: 500);

      final empEndpoint = endpoints['employees'] as Map<String, dynamic>?;
      final response = empEndpoint?['response'] as Map<String, dynamic>?;
      final data = response?['data'] as List<dynamic>?;
      final list = (data ?? []).map((e) => EmployeeEntity.fromJson(e as Map<String, dynamic>)).toList();
      await _empRepo.saveEmployees(orgId, list);
      return ApiResponse.success(data: list, statusCode: 200);
    } catch (e) {
      return ApiResponse.failure(message: e.toString(), statusCode: 500);
    }
  }
}
