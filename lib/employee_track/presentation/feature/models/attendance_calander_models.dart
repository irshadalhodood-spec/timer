
class TimeBlock {
  TimeBlock({
    required this.label,
    required this.startSeconds,
    required this.durationSeconds,
    this.isWork = false,
    this.isBreak = false,
    this.isOt = false,
    this.detailText,
  });
  final String label;
  /// Start offset from midnight in seconds (exact, no rounding).
  final int startSeconds;
  /// Duration in seconds (exact, so e.g. 2:44 is correct not 2:00).
  final int durationSeconds;
  final bool isWork;
  final bool isBreak;
  final bool isOt;
  /// Time and location shown on the block (e.g. check-in, check-out, break details).
  final String? detailText;
}

enum DayDetailType { checkIn, checkOut, breakType }

class DayDetailEntry {
  DayDetailEntry({
    required this.type,
    required this.timeLabel,
    this.location,
  });
  final DayDetailType type;
  final String timeLabel;
  final String? location;
}

class DayViewData {
  DayViewData({required this.blocks, required this.details});
  final List<TimeBlock> blocks;
  final List<DayDetailEntry> details;
}
