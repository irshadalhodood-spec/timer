import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../attendance_module/domain/repositories/attendance_repository.dart';
import 'monthly_data_cubit.dart';

class MonthlyScoreCubit extends Cubit<MonthlyScoreState> {
  MonthlyScoreCubit({
    required AttendanceRepository attendanceRepository,
    required String userId,
  })  : _attendance = attendanceRepository,
        _userId = userId,
        super(const MonthlyScoreState());

  final AttendanceRepository _attendance;
  final String _userId;

  void setViewMode(String mode) {
    emit(state.copyWith(
      calendarViewMode: mode,
      selectedYear: mode == 'monthly' ? null : state.selectedYear,
    ));
  }

  void setSelectedYear(int? year) {
    emit(state.copyWith(selectedYear: year));
  }

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  /// Fetches attendance for the given year and stores in state. Does not touch AttendanceBloc.
  Future<void> loadYear(int year) async {
    emit(state.copyWith(isLoading: true));
    try {
      final list = await _attendance.getAttendancesByUser(
        _userId,
        from: DateTime(year, 1, 1),
        to: DateTime(year, 12, 31, 23, 59, 59),
      );
      emit(state.copyWith(yearList: list, isLoading: false));
    } catch (_) {
      emit(state.copyWith(yearList: [], isLoading: false));
    }
  }

  /// Call when attendance data has finished loading so only this section refreshes.
  void refresh() {
    emit(state.copyWith(refreshTrigger: state.refreshTrigger + 1));
  }
}
