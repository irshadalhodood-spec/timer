import '../../domain/entities/working_hours_config.dart';
import '../../domain/repositories/working_hours_repository.dart';
import '../../presentation/core/values/app_apis.dart';
import '../network/api_client.dart';

class WorkingHoursRepositoryImpl implements WorkingHoursRepository {
  WorkingHoursRepositoryImpl({required ApiClient apiClient}) : _client = apiClient;

  final ApiClient _client;
  WorkingHoursConfig? _cached;
  DateTime? _cacheTime;
  static const _cacheValidDuration = Duration(minutes: 30);

  @override
  Future<WorkingHoursConfig> getWorkingHours() async {
    if (_cached != null &&
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < _cacheValidDuration) {
      return _cached!;
    }
    try {
      final response = await _client.get<Map<String, dynamic>>(AppApis.workingHours);
      final data = response.data;
      if (data != null) {
        final map = data['data'] as Map<String, dynamic>? ?? data;
        final config = WorkingHoursConfig.fromJson(Map<String, dynamic>.from(map as Map));
        if (config != null) {
          _cached = config;
          _cacheTime = DateTime.now();
          return config;
        }
      }
    } catch (_) {
      // Use default on network/parse error
    }
    _cached = WorkingHoursConfig.defaultConfig;
    _cacheTime = DateTime.now();
    return _cached!;
  }
}
