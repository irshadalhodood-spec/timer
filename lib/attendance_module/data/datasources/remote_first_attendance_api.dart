import '../../../../base_module/domain/entities/api_response.dart';
import '../../domain/datasources/attendance_api.dart';
import '../../domain/entities/attendance_entity.dart';
import 'json_attendance_api.dart';
import 'trackme_attendance_api.dart';

class RemoteFirstAttendanceApi implements AttendanceApi {
  RemoteFirstAttendanceApi({
    required TrackMeAttendanceApi trackMe,
    required JsonAttendanceApi jsonFallback,
  })  : _trackMe = trackMe,
        _jsonFallback = jsonFallback;

  final TrackMeAttendanceApi _trackMe;
  final JsonAttendanceApi _jsonFallback;

  @override
  Future<ApiResponse<List<AttendanceEntity>>> getAttendanceHistory({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    final response = await _trackMe.getAttendanceHistory(
      userId: userId,
      from: from,
      to: to,
    );
    if (response.success) return response;
    return _jsonFallback.getAttendanceHistory(
      userId: userId,
      from: from,
      to: to,
    );
  }
}
