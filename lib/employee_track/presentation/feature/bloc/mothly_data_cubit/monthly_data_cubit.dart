import 'package:equatable/equatable.dart';

import '../../../../../attendance_module/domain/entities/attendance_entity.dart';

/// State for the Monthly Score card (calendar view mode and selected year).
/// When this state changes, only the monthly score section rebuilds.
class MonthlyScoreState extends Equatable {
  const MonthlyScoreState({
    this.calendarViewMode = 'monthly',
    this.selectedYear,
    this.refreshTrigger = 0,
    this.isLoading = false,
    this.yearList,
  });

  final String calendarViewMode;
  final int? selectedYear;
  /// Incremented on [refresh] so only this section rebuilds when data is done.
  final int refreshTrigger;
  /// True when this widget triggered a history request (e.g. year change); only this card shows loading.
  final bool isLoading;
  /// Fetched list when viewing a specific year; null until loaded or when in monthly mode.
  final List<AttendanceEntity>? yearList;

  MonthlyScoreState copyWith({
    String? calendarViewMode,
    int? selectedYear,
    int? refreshTrigger,
    bool? isLoading,
    List<AttendanceEntity>? yearList,
  }) {
    return MonthlyScoreState(
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      selectedYear: selectedYear ?? this.selectedYear,
      refreshTrigger: refreshTrigger ?? this.refreshTrigger,
      isLoading: isLoading ?? this.isLoading,
      yearList: yearList ?? this.yearList,
    );
  }

  @override
  List<Object?> get props => [calendarViewMode, selectedYear, refreshTrigger, isLoading, yearList];
}
