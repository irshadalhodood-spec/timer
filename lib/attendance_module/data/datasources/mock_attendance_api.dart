import '../../../../base_module/domain/entities/api_response.dart';
import '../../domain/datasources/attendance_api.dart';
import '../../domain/entities/attendance_entity.dart';


class MockAttendanceApi implements AttendanceApi {
  MockAttendanceApi({this.simulatedDelay = const Duration(milliseconds: 600)});

  final Duration simulatedDelay;

  @override
  Future<ApiResponse<List<AttendanceEntity>>> getAttendanceHistory({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    await Future<void>.delayed(simulatedDelay);
    return ApiResponse.success(
      data: <AttendanceEntity>[],
      statusCode: 200,
    );
  }
}
