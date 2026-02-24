class DayHours {
  const DayHours({
    required this.workHours,
    required this.breakHours,
    required this.overtimeHours,
    required this.shortHours,
    this.isPartialLeave = false,
  });
  final double workHours;
  final double breakHours;
  final double overtimeHours;
  final double shortHours;
  final bool isPartialLeave;
}
