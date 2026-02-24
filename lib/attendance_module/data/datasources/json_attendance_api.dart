import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../base_module/domain/entities/api_response.dart';
import '../../../../employee_track/data/datasources/break_record_local_datasource.dart';
import '../../../../employee_track/domain/entities/break_record_entity.dart';
import '../../domain/datasources/attendance_api.dart';
import '../../domain/entities/attendance_entity.dart';
import 'attendance_local_datasource.dart';

class JsonAttendanceApi implements AttendanceApi {
  JsonAttendanceApi({
    required AttendanceLocalDatasource attendanceLocal,
    required BreakRecordLocalDatasource breakRecordLocal,
    this.assetPath = 'lib/base_module/data/assets/api_endpoints.json',
  })  : _attendanceLocal = attendanceLocal,
        _breakRecordLocal = breakRecordLocal;

  final AttendanceLocalDatasource _attendanceLocal;
  final BreakRecordLocalDatasource _breakRecordLocal;
  final String assetPath;

  Map<String, dynamic>? _cachedJson;

  Future<Map<String, dynamic>> _loadJson() async {
    if (_cachedJson != null) return _cachedJson!;
    final String jsonString = await rootBundle.loadString(assetPath);
    _cachedJson = jsonDecode(jsonString) as Map<String, dynamic>;
    return _cachedJson!;
  }

  @override
  Future<ApiResponse<List<AttendanceEntity>>> getAttendanceHistory({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final map = await _loadJson();
      final endpoints = map['endpoints'] as Map<String, dynamic>?;
      if (endpoints == null) {
        return ApiResponse.failure(message: 'Invalid API JSON', statusCode: 500);
      }

      final attendanceEndpoint = endpoints['attendance_history'] as Map<String, dynamic>?;
      final breakEndpoint = endpoints['break_records'] as Map<String, dynamic>?;

      if (attendanceEndpoint != null) {
        final response = attendanceEndpoint['response'] as Map<String, dynamic>?;
        final data = response?['data'] as List<dynamic>?;
        if (data != null) {
          final list = data
              .map((e) => AttendanceEntity.fromJson(e as Map<String, dynamic>))
              .toList();
          for (final att in list) {
            await _attendanceLocal.saveAttendance(att);
          }
        }
      }

      if (breakEndpoint != null) {
        final response = breakEndpoint['response'] as Map<String, dynamic>?;
        final data = response?['data'] as List<dynamic>?;
        if (data != null) {
          for (final e in data) {
            final br = BreakRecordEntity.fromJson(e as Map<String, dynamic>);
            await _breakRecordLocal.saveBreakRecord(br);
          }
        }
      }

      final allForUser = await _attendanceLocal.getAttendancesByUser(
        userId,
        from: from,
        to: to,
      );
      return ApiResponse.success(data: allForUser, statusCode: 200);
    } catch (e) {
      return ApiResponse.failure(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
}
