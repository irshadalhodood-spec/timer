import '../entities/working_hours_config.dart';

abstract class WorkingHoursRepository {
  /// Returns working hours config from API/cache, or default (auto-checkout at end of day).
  Future<WorkingHoursConfig> getWorkingHours();
}
