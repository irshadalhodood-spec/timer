import 'package:dio/dio.dart';

import '../../../../base_module/domain/entities/api_response.dart';
import '../../../../base_module/data/network/api_client.dart';
import '../../../../base_module/presentation/core/values/app_apis.dart';
import '../../../../employee_track/data/datasources/break_record_local_datasource.dart';
import '../../../../employee_track/domain/entities/break_record_entity.dart';
import '../../domain/datasources/attendance_api.dart';
import '../../domain/entities/attendance_entity.dart';
import '../datasources/attendance_local_datasource.dart';

class TrackMeAttendanceApi implements AttendanceApi {
  TrackMeAttendanceApi({
    required AttendanceLocalDatasource attendanceLocal,
    required BreakRecordLocalDatasource breakRecordLocal,
    ApiClient? apiClient,
  })  : _attendanceLocal = attendanceLocal,
        _breakRecordLocal = breakRecordLocal,
        _client = apiClient ?? ApiClient();

  final AttendanceLocalDatasource _attendanceLocal;
  final BreakRecordLocalDatasource _breakRecordLocal;
  final ApiClient _client;

  @override
  Future<ApiResponse<List<AttendanceEntity>>> getAttendanceHistory({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        AppApis.attendanceHistory,
        queryParameters: {
          'userId': userId,
          'from': from.toIso8601String(),
          'to': to.toIso8601String(),
        },
      );
      final map = response.data;
      if (map == null) {
        return ApiResponse.failure(message: 'Empty response', statusCode: response.statusCode);
      }
      final apiResponse = ApiResponse.fromJson<List<AttendanceEntity>>(
        map,
        fromJsonData: (dynamic data) {
          if (data == null) return <AttendanceEntity>[];
          if (data is! List) return <AttendanceEntity>[];
          return data
              .map((e) => AttendanceEntity.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
      if (apiResponse.success && apiResponse.data != null) {
        for (final att in apiResponse.data!) {
          await _attendanceLocal.saveAttendance(att);
        }
      }

      // Fetch break records from same API
      try {
        final breakResponse = await _client.get<Map<String, dynamic>>(
          AppApis.attendanceBreaks,
          queryParameters: {'userId': userId, 'from': from.toIso8601String(), 'to': to.toIso8601String()},
        );
        final breakMap = breakResponse.data;
        if (breakMap != null) {
          final breakData = breakMap['data'];
          if (breakData is List) {
            for (final e in breakData) {
              final br = BreakRecordEntity.fromJson(e as Map<String, dynamic>);
              await _breakRecordLocal.saveBreakRecord(br);
            }
          }
        }
      } catch (_) {}

      final allForUser = await _attendanceLocal.getAttendancesByUser(
        userId,
        from: from,
        to: to,
      );
      return ApiResponse.success(data: allForUser, statusCode: 200);
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
