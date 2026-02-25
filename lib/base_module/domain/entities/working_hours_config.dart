/// Working hours / shift config from API (e.g. morning 8–6 or night 8–next day 7).
/// Used to compute auto-checkout time when employee doesn't check out.
class WorkingHoursConfig {
  const WorkingHoursConfig({
    required this.shiftStartHour,
    required this.shiftStartMinute,
    required this.shiftEndHour,
    required this.shiftEndMinute,
    this.endsNextDay = false,
  });

  /// Shift start hour (0–23), e.g. 8 for 08:00.
  final int shiftStartHour;
  final int shiftStartMinute;
  /// Shift end hour (0–23), e.g. 18 for 18:00 or 7 for 07:00 next day.
  final int shiftEndHour;
  final int shiftEndMinute;
  /// True if shift ends next calendar day (e.g. night 20:00 – 07:00).
  final bool endsNextDay;

  /// Parse from API JSON: { "shiftStart": "08:00", "shiftEnd": "18:00" } or
  /// { "shiftStart": "20:00", "shiftEnd": "07:00", "endsNextDay": true }.
  static WorkingHoursConfig? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final start = _parseTime(json['shiftStart']);
    final end = _parseTime(json['shiftEnd']);
    if (start == null || end == null) return null;
    final endsNextDay = json['endsNextDay'] as bool? ?? false;
    return WorkingHoursConfig(
      shiftStartHour: start.$1,
      shiftStartMinute: start.$2,
      shiftEndHour: end.$1,
      shiftEndMinute: end.$2,
      endsNextDay: endsNextDay,
    );
  }

  static (int, int)? _parseTime(dynamic value) {
    if (value is! String) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0].trim());
    final m = int.tryParse(parts[1].trim());
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) return null;
    return (h, m);
  }

  /// Default: end of day (midnight next day) for auto-checkout.
  static WorkingHoursConfig get defaultConfig => const WorkingHoursConfig(
        shiftStartHour: 0,
        shiftStartMinute: 0,
        shiftEndHour: 0,
        shiftEndMinute: 0,
        endsNextDay: true,
      );
}
