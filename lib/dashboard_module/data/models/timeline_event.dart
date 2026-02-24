
enum TimelineEventType { checkIn, checkOut, breakStart, breakEnd }

class TimelineEvent {
  TimelineEvent({
    required this.type,
    required this.time,
    required this.location,
  });

  final TimelineEventType type;
  final DateTime time;
  final String location;
}
