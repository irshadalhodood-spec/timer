part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  @override
  List<Object?> get props => [];

  static const AttendanceState initial = AttendanceStateInitial();
  static AttendanceState checkedOut({
    List<AttendanceEntity>? todaySessions = const [],
    Map<String, List<BreakRecordEntity>>? todaySessionBreaks = const {},
  }) =>
      AttendanceStateCheckedOut(
        todaySessions: todaySessions ?? const [],
        todaySessionBreaks: todaySessionBreaks ?? const {},
      );
  static AttendanceState historyLoading({
    AttendanceEntity? todayAttendance,
    List<BreakRecordEntity>? todayBreaks,
    int todayBreakSeconds = 0,
    List<AttendanceEntity>? todaySessions = const [],
  }) =>
      AttendanceStateHistoryLoading(
        todayAttendance: todayAttendance,
        todayBreaks: todayBreaks ?? const [],
        todayBreakSeconds: todayBreakSeconds,
        todaySessions: todaySessions ?? const [],
      );
  static AttendanceState checkedIn(
    AttendanceEntity attendance,
    List<BreakRecordEntity> breaks,
    int breakSeconds, {
    List<AttendanceEntity>? todaySessions = const [],
  }) =>
      AttendanceStateCheckedIn(attendance, breaks, breakSeconds, todaySessions ?? const []);
  static AttendanceState historyLoaded(
    List<AttendanceEntity> list, {
    AttendanceEntity? todayAttendance,
    List<BreakRecordEntity>? todayBreaks,
    int todayBreakSeconds = 0,
    List<AttendanceEntity>? todaySessions = const [],
  }) =>
      AttendanceStateHistoryLoaded(
        list,
        todayAttendance: todayAttendance,
        todayBreaks: todayBreaks ?? const [],
        todayBreakSeconds: todayBreakSeconds,
        todaySessions: todaySessions ?? const [],
      );
  static AttendanceState failure(String message) => AttendanceStateFailure(message);
}

class AttendanceStateInitial extends AttendanceState {
  const AttendanceStateInitial();
}

class AttendanceStateCheckedIn extends AttendanceState {
  const AttendanceStateCheckedIn(this.attendance, this.breaks, this.breakSeconds, [this.todaySessions = const []]);
  final AttendanceEntity attendance;
  final List<BreakRecordEntity> breaks;
  final int breakSeconds;
  /// All attendance sessions for today (including current), in chronological order (check_in_at ASC).
  final List<AttendanceEntity> todaySessions;
  @override
  List<Object?> get props => [attendance, breaks, breakSeconds, todaySessions];
}

class AttendanceStateCheckedOut extends AttendanceState {
  const AttendanceStateCheckedOut({
    this.todaySessions = const [],
    this.todaySessionBreaks = const {},
  });
  /// All attendance sessions for today (all completed when checked out). Empty when next day.
  final List<AttendanceEntity> todaySessions;
  /// Breaks per attendance id for building full activity timeline when checked out.
  final Map<String, List<BreakRecordEntity>> todaySessionBreaks;
  @override
  List<Object?> get props => [todaySessions, todaySessionBreaks];
}

class AttendanceStateHistoryLoading extends AttendanceState {
  const AttendanceStateHistoryLoading({
    this.todayAttendance,
    this.todayBreaks = const [],
    this.todayBreakSeconds = 0,
    this.todaySessions = const [],
  });
  final AttendanceEntity? todayAttendance;
  final List<BreakRecordEntity> todayBreaks;
  final int todayBreakSeconds;
  final List<AttendanceEntity> todaySessions;
  @override
  List<Object?> get props => [todayAttendance, todayBreaks, todayBreakSeconds, todaySessions];
}

class AttendanceStateHistoryLoaded extends AttendanceState {
  const AttendanceStateHistoryLoaded(
    this.list, {
    this.todayAttendance,
    this.todayBreaks = const [],
    this.todayBreakSeconds = 0,
    this.todaySessions = const [],
  });
  final List<AttendanceEntity> list;
  final AttendanceEntity? todayAttendance;
  final List<BreakRecordEntity> todayBreaks;
  final int todayBreakSeconds;
  final List<AttendanceEntity> todaySessions;
  @override
  List<Object?> get props => [list, todayAttendance, todayBreaks, todayBreakSeconds, todaySessions];
}

class AttendanceStateFailure extends AttendanceState {
  const AttendanceStateFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

