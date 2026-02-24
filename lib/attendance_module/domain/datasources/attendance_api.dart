import '../../../../base_module/domain/entities/api_response.dart';
import '../entities/attendance_entity.dart';


abstract class AttendanceApi {
  
  Future<ApiResponse<List<AttendanceEntity>>> getAttendanceHistory({
    required String userId,
    required DateTime from,
    required DateTime to,
  });
}
