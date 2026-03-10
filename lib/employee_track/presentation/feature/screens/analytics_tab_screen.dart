import 'package:employee_track/base_module/presentation/components/padding/app_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../attendance_module/domain/entities/attendance_entity.dart';
import '../../../../base_module/domain/entities/address_display.dart';
import '../../../../employee_track/domain/entities/break_record_entity.dart';
import '../../../../employee_track/domain/repositories/break_record_repository.dart';
import '../../../../base_module/domain/entities/translation.dart';
import '../../../../base_module/presentation/util/date_time_format.dart';
import '../../../../base_module/presentation/util/locale_digits.dart';
import '../../../../base_module/presentation/core/values/app_constants.dart';
import '../../../../attendance_module/domain/repositories/attendance_repository.dart';
import '../../../../auth_module/presentation/feature/bloc/auth_bloc.dart';
import '../../../../base_module/presentation/feature/live_time/live_time_cubit.dart';
import '../../../../dashboard_module/domain/attendance_bloc.dart';
import '../bloc/mothly_data_cubit/monthly_data_cubit.dart';
import '../bloc/mothly_data_cubit/monthly_data_state.dart';
import '../models/day_models.dart';
import '../widgets/show_attendance_history_details.dart';
import 'attendance_calendar_detail_screen.dart';
import '../widgets/attendance_history_card.dart';
import '../widgets/day_bar_widget.dart';
import '../widgets/day_cell_with_tool_tip.dart';
import '../widgets/details_card.dart';

class AnalyticsTabScreen extends StatefulWidget {
  const AnalyticsTabScreen({super.key, this.weekendWeekdays, this.holidays});
  final List<int>? weekendWeekdays;
  final List<DateTime>? holidays;

  @override
  State<AnalyticsTabScreen> createState() => _AnalyticsTabScreenState();
}

class _AnalyticsTabScreenState extends State<AnalyticsTabScreen> {
  var _loaded = false;
  List<AttendanceEntity>? _lastLoadedList;

  /// Selected day in the weekly chart; null = show week summary.
  DateTime? _selectedWeekDay;
  List<int> get _weekendWeekdays => widget.weekendWeekdays ?? [6, 7];
  List<DateTime> get _holidays => widget.holidays ?? [];

  static const double _yearMonthCellSize = 8.0;
  static const double _yearMonthGap = 2.0;
  static const double _yearMonthBlockWidth =
      _yearMonthCellSize * 7 + _yearMonthGap * 6 + 8;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final now = DateTime.now();
      context.read<AttendanceBloc>().add(
        AttendanceHistoryRequested(
          from: now.subtract(const Duration(days: 35)),
          to: now.add(const Duration(days: 1)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is AuthStateAuthenticated
        ? authState.session.user.userId
        : '';
    return BlocProvider<MonthlyScoreCubit>(
      create: (_) => MonthlyScoreCubit(
        attendanceRepository: context.read<AttendanceRepository>(),
        userId: userId,
      ),
      child: BlocListener<AttendanceBloc, AttendanceState>(
        listenWhen: (a, b) => true,
        listener: (context, state) {
          if (state is AttendanceStateHistoryLoaded) {
            setState(() => _lastLoadedList = state.list);
          }
          // After break/checkout actions the bloc emits checkedIn/checkedOut without
          // going through a history state — re-request history so analytics stays fresh.
          if (state is AttendanceStateCheckedIn ||
              state is AttendanceStateCheckedOut) {
            final now = DateTime.now();
            context.read<AttendanceBloc>().add(
              AttendanceHistoryRequested(
                from: now.subtract(const Duration(days: 35)),
                to: now.add(const Duration(days: 1)),
              ),
            );
          }
        },
        child: BlocBuilder<AttendanceBloc, AttendanceState>(
          buildWhen: (a, b) {
            if (a is AttendanceStateHistoryLoaded !=
                b is AttendanceStateHistoryLoaded)
              return true;
            if (a is AttendanceStateHistoryLoading !=
                b is AttendanceStateHistoryLoading)
              return true;
            // Rebuild when live break seconds change during an active session.
            if (b is AttendanceStateCheckedIn &&
                a is AttendanceStateCheckedIn) {
              return a.breakSeconds != b.breakSeconds ||
                  a.breaks.length != b.breaks.length;
            }
            if (b is AttendanceStateHistoryLoaded &&
                a is AttendanceStateHistoryLoaded) {
              return a.todayBreakSeconds != b.todayBreakSeconds ||
                  a.list.length != b.list.length;
            }
            return false;
          },
          builder: (context, state) {
            // Patch today's attendance record in the list with live breakSeconds so
            // graph and history cards reflect real-time break duration.
            final rawList = state is AttendanceStateHistoryLoaded
                ? state.list
                : _lastLoadedList;
            final list = _withLiveTodayBreaks(rawList, state);
            final isLoading = state is AttendanceStateHistoryLoading;
            final showFullScreenLoading = isLoading && list == null;

            if (showFullScreenLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (list != null) {
              return BlocBuilder<LiveTimeCubit, DateTime>(
                buildWhen: (prev, next) =>
                    prev.second != next.second ||
                    prev.minute != next.minute ||
                    prev.hour != next.hour,
                builder: (context, now) => SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWeeklyChart(
                        context,
                        list,
                        now,
                        selectedDate: _selectedWeekDay,
                        onDaySelected: (date) =>
                            setState(() => _selectedWeekDay = date),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<MonthlyScoreCubit, MonthlyScoreState>(
                        builder: (context, scoreState) =>
                            _buildMonthlyScore(context, list, scoreState),
                      ),
                      const SizedBox(height: 24),
                      _buildAttendanceHistory(context, list, now),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CupertinoActivityIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(
    BuildContext context,
    List<AttendanceEntity> list,
    DateTime now, {
    DateTime? selectedDate,
    void Function(DateTime?)? onDaySelected,
  }) {
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekDays = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final dayLabels = [
      (translation.of('analytics.mon')),
      (translation.of('analytics.tue')),
      (translation.of('analytics.wed')),
      (translation.of('analytics.thu')),
      (translation.of('analytics.fri')),
      (translation.of('analytics.sat')),
      (translation.of('analytics.sun')),
    ];

    final todayNormalized = DateTime(now.year, now.month, now.day);
    final dayData = <DayHours>[];
    for (final day in weekDays) {
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final isToday =
          day.year == todayNormalized.year &&
          day.month == todayNormalized.month &&
          day.day == todayNormalized.day;
      var workSeconds = 0;
      var breakSeconds = 0;
      final daySessions = list.where((a) {
        final checkInLocal = a.checkInAt.isUtc
            ? a.checkInAt.toLocal()
            : a.checkInAt;
        return checkInLocal.isAfter(dayStart) && checkInLocal.isBefore(dayEnd);
      }).toList()..sort((a, b) => a.checkInAt.compareTo(b.checkInAt));
      for (final a in daySessions) {
        final checkInLocal = a.checkInAt.isUtc
            ? a.checkInAt.toLocal()
            : a.checkInAt;
        final out = a.checkOutAt != null
            ? (a.checkOutAt!.isUtc ? a.checkOutAt!.toLocal() : a.checkOutAt!)
            : (isToday ? now : dayEnd);
        if (out.isAfter(dayStart)) {
          final end = out.isBefore(dayEnd) ? out : dayEnd;
          final seg = (end.difference(checkInLocal).inSeconds - a.breakSeconds)
              .clamp(0, 86400 * 2);
          workSeconds += seg;
          breakSeconds += a.breakSeconds;
        }
      }
      final totalWorkHours = workSeconds / 3600;
      final breakHours = breakSeconds / 3600;
      // Work capped at 8h; excess goes to OT
      final workHours = totalWorkHours > 8 ? 8.0 : totalWorkHours;
      final overtimeHours = totalWorkHours > 8 ? totalWorkHours - 8 : 0.0;
      // Short only when worked > 0 but < 8h (and no OT)
      final shortHours = totalWorkHours > 0 && totalWorkHours < 8
          ? 8.0 - totalWorkHours
          : 0.0;
      final isPartialLeave =
          (daySessions.isNotEmpty &&
              daySessions.last.checkOutAt != null &&
              daySessions.last.isEarlyCheckout) ||
          (daySessions.isNotEmpty &&
              shortHours > 0 &&
              daySessions.last.checkOutAt != null);
      dayData.add(
        DayHours(
          workHours: workHours,
          breakHours: breakHours,
          overtimeHours: overtimeHours,
          shortHours: shortHours,
          isPartialLeave: isPartialLeave,
        ),
      );
    }

    // Selection: show selected day or week summary
    final selectedIndex = selectedDate == null
        ? null
        : weekDays.indexWhere(
            (d) =>
                d.year == selectedDate.year &&
                d.month == selectedDate.month &&
                d.day == selectedDate.day,
          );
    final int? detailIndex =
        (selectedIndex != null &&
            selectedIndex >= 0 &&
            selectedIndex < dayData.length)
        ? selectedIndex
        : null;
    // Week totals (when no selection)
    final weekWork = dayData.fold<double>(0, (s, d) => s + d.workHours);
    final weekBreak = dayData.fold<double>(0, (s, d) => s + d.breakHours);
    final weekOvertime = dayData.fold<double>(0, (s, d) => s + d.overtimeHours);
    final weekShort = dayData.fold<double>(0, (s, d) => s + d.shortHours);
    final detailWork = detailIndex != null
        ? dayData[detailIndex].workHours
        : weekWork;
    final detailBreak = detailIndex != null
        ? dayData[detailIndex].breakHours
        : weekBreak;
    final detailOvertime = detailIndex != null
        ? dayData[detailIndex].overtimeHours
        : weekOvertime;
    final detailShort = detailIndex != null
        ? dayData[detailIndex].shortHours
        : weekShort;
    final detailLabel = detailIndex != null
        ? AppDateTimeFormat.formatWeekday(weekDays[detailIndex])
        : translation.of('analytics.this_week');

    const maxHoursAxis = 12.0;
    const barMaxHeight = 140.0;
    final theme = Theme.of(context);
    final workColor = theme.colorScheme.primary;
    final breakColor = Colors.amber;
    final overtimeColor = theme.colorScheme.error;
    final shortColor = Colors.orange;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translation.of('dashboard.weekly_chart'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _legendItem(
                context,
                translation.of('dashboard.chart_work_hours'),
                workColor,
              ),
              _legendItem(
                context,
                translation.of('dashboard.chart_break_hours'),
                breakColor,
              ),
              _legendItem(
                context,
                translation.of('dashboard.chart_overtime_hours'),
                overtimeColor,
              ),
              _legendItem(
                context,
                translation.of('dashboard.chart_short_hours'),
                shortColor,
              ),
              _legendItem(
                context,
                translation.of('dashboard.partial_leave'),
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: barMaxHeight + 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final d = dayData[i];
                final day = weekDays[i];
                final isSelected =
                    selectedDate != null &&
                    day.year == selectedDate.year &&
                    day.month == selectedDate.month &&
                    day.day == selectedDate.day;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: DayBar(
                      dayLabel: dayLabels[i],
                      d: d,
                      maxHours: maxHoursAxis,
                      barHeight: barMaxHeight,
                      workColor: workColor,
                      breakColor: breakColor,
                      overtimeColor: overtimeColor,
                      shortColor: shortColor,
                      isPartialLeave: d.isPartialLeave,
                      isSelected: isSelected,
                      onTap: onDaySelected != null
                          ? () => onDaySelected(isSelected ? null : day)
                          : null,
                      theme: theme,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  detailLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryChip(
                      context,
                      translation.of('analytics.work'),
                      LocaleDigits.format(
                        detailWork > 0
                            ? '${detailWork.toStringAsFixed(1)}${translation.of('analytics.h')}'
                            : '—',
                      ),
                      workColor,
                    ),
                    _summaryChip(
                      context,
                      translation.of('analytics.break'),
                      LocaleDigits.format(
                        detailBreak > 0
                            ? '${detailBreak.toStringAsFixed(1)}${translation.of('analytics.h')}'
                            : '—',
                      ),
                      breakColor,
                    ),
                    _summaryChip(
                      context,
                      translation.of('analytics.ot'),
                      LocaleDigits.format(
                        detailOvertime > 0
                            ? '+${detailOvertime.toStringAsFixed(1)}${translation.of('analytics.h')}'
                            : '—',
                      ),
                      detailOvertime > 0
                          ? overtimeColor
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    _summaryChip(
                      context,
                      translation.of('analytics.short'),
                      LocaleDigits.format(
                        detailShort > 0
                            ? '-${detailShort.toStringAsFixed(1)}${translation.of('analytics.h')}'
                            : '—',
                      ),
                      detailShort > 0
                          ? shortColor
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _summaryChip(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyScore(
    BuildContext context,
    List<AttendanceEntity> blocList,
    MonthlyScoreState scoreState,
  ) {
    final now = DateTime.now();
    final theme = Theme.of(context);
    final list = scoreState.calendarViewMode == 'monthly'
        ? blocList
        : scoreState.yearList;
    final presentDates = <DateTime>{};
    final partialLeaveDates = <DateTime>{};
    final shortHoursDates = <DateTime>{};
    final calendarByDate = <DateTime, List<AttendanceEntity>>{};
    if (list != null) {
      final byDate = <DateTime, List<AttendanceEntity>>{};
      for (final a in list) {
        final checkInLocal = a.checkInAt.isUtc
            ? a.checkInAt.toLocal()
            : a.checkInAt;
        final d = DateTime(
          checkInLocal.year,
          checkInLocal.month,
          checkInLocal.day,
        );
        presentDates.add(d);
        byDate.putIfAbsent(d, () => []).add(a);
        calendarByDate.putIfAbsent(d, () => []).add(a);
      }
      for (final entry in byDate.entries) {
        final daySessions = List<AttendanceEntity>.from(entry.value)
          ..sort((a, b) => a.checkInAt.compareTo(b.checkInAt));
        // Partial leave = last session explicitly checked out early
        if (daySessions.isNotEmpty &&
            daySessions.last.checkOutAt != null &&
            daySessions.last.isEarlyCheckout) {
          partialLeaveDates.add(entry.key);
        }
        // Short hours: only mark when the day is fully done (all sessions checked out)
        final allCheckedOut = daySessions.every((a) => a.checkOutAt != null);
        if (allCheckedOut) {
          final totalWorked = daySessions.fold<int>(
            0,
            (s, a) => s + _workedSecondsForDay(a, entry.key, now: null),
          );
          if (totalWorked > 0 &&
              totalWorked < AppConstants.expectedWorkSecondsPerDay) {
            shortHoursDates.add(entry.key);
          }
        }
      }
    }

    final displayYear = scoreState.selectedYear ?? now.year;
    final monthYearLabel = scoreState.calendarViewMode == 'monthly'
        ? LocaleDigits.format(
            '${AppDateTimeFormat.formatMonth(DateTime(now.year, now.month))} $displayYear',
          )
        : LocaleDigits.ofInt(displayYear);

    final content = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translation.of('dashboard.monthly_score'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterChip(
                label: Text(
                  translation.of('analytics.monthly'),
                  style: theme.textTheme.labelMedium,
                ),
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: scoreState.calendarViewMode == 'monthly'
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                selected: scoreState.calendarViewMode == 'monthly',
                onSelected: (selected) {
                  if (selected) _applyCalendarFilter(context, 'monthly', null);
                },
                selectedColor: Colors.transparent,
                showCheckmark: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.smallCornerRadius,
                  ),
                ),
                side: BorderSide(
                  color: scoreState.calendarViewMode == 'monthly'
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: scoreState.calendarViewMode == 'monthly' ? 2 : 1,
                ),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),

              Row(
                children: [
                  Text(
                    translation.of('analytics.year'),
                    style: theme.textTheme.labelMedium,
                  ),
                  AppPadding(multipliedBy: 0.5),
                  DropdownButton<int>(
                    underline: const SizedBox.shrink(),
                    value: scoreState.selectedYear ?? now.year,
                    items: List.generate(5, (i) => now.year - i).map((y) {
                      return DropdownMenuItem<int>(
                        value: y,
                        child: LocaleDigitsText('$y'),
                      );
                    }).toList(),
                    onChanged: (int? year) {
                      if (year != null) {
                        _applyCalendarFilter(context, 'year', year);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                monthYearLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => AttendanceCalendarDetailScreen(
                        attendanceList: list ?? [],
                        weekendWeekdays: widget.weekendWeekdays,
                        holidays: widget.holidays,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month_outlined, size: 18),
                label: Text(translation.of('analytics.detailed_view')),
              ),
            ],
          ),

          if (scoreState.calendarViewMode == 'monthly') ...[
            _buildMonthGrid(
              context,
              now.year,
              now.month,
              presentDates,
              partialLeaveDates,
              theme,
              shortHoursDates: shortHoursDates,
              byDate: calendarByDate,
            ),
            const SizedBox(height: 12),
            _buildMonthLegend(
              context,
              now.year,
              now.month,
              presentDates,
              partialLeaveDates,
              theme,
              shortHoursDates: shortHoursDates,
            ),
          ] else ...[
            _buildYearGrid(
              context,
              scoreState.selectedYear ?? now.year,
              presentDates,
              partialLeaveDates,
              theme,
              shortHoursDates: shortHoursDates,
              byDate: calendarByDate,
            ),
            const SizedBox(height: 12),
            _buildYearLegend(
              context,
              scoreState.selectedYear ?? now.year,
              presentDates,
              partialLeaveDates,
              theme,
              shortHoursDates: shortHoursDates,
            ),
          ],
        ],
      ),
    );

    if (!scoreState.isLoading) return content;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        content,
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.surface.withValues(alpha: 0.7),
            ),
            child: const Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CupertinoActivityIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthGrid(
    BuildContext context,
    int year,
    int month,
    Set<DateTime> presentDates,
    Set<DateTime> partialLeaveDates,
    ThemeData theme, {
    double? cellSizeOverride,
    Set<DateTime>? shortHoursDates,
    Map<DateTime, List<AttendanceEntity>>? byDate,
  }) {
    final first = DateTime(year, month, 1);
    final last = DateTime(year, month + 1, 0);
    final daysInMonth = last.day;
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final startWeekday = first.weekday % 7;
    final rows = ((startWeekday + daysInMonth) / 7).ceil();
    const gap = 2.0;

    Widget buildContent(double cellSize) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: List.generate(7, (col) {
              final label = [
                translation.of('analytics.s'),
                translation.of('analytics.m'),
                translation.of('analytics.t'),
                translation.of('analytics.w'),
                translation.of('analytics.th'),
                translation.of('analytics.f'),
                translation.of('analytics.sa'),
              ][col];
              return SizedBox(
                width: cellSize,
                height: cellSize * 1.5,
                child: Center(
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: cellSizeOverride != null ? 8 : 10,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: gap),
          ...List.generate(rows, (row) {
            return Padding(
              padding: EdgeInsets.only(bottom: row < rows - 1 ? gap : 0),
              child: Row(
                children: List.generate(7, (col) {
                  final dayIndex = row * 7 + col - startWeekday + 1;
                  if (dayIndex < 1 || dayIndex > daysInMonth) {
                    return Padding(
                      padding: EdgeInsets.only(right: col < 6 ? gap : 0),
                      child: SizedBox(
                        width: cellSize,
                        height: cellSize,
                        child: _gridCell(
                          theme,
                          false,
                          true,
                          false,
                          false,
                          false,
                          false,
                          null,
                        ),
                      ),
                    );
                  }
                  final d = DateTime(year, month, dayIndex);
                  final isUpcoming = d.isAfter(todayNormalized);
                  final present = presentDates.contains(d);
                  final offDay = _isOffDay(d);
                  final isPartialLeave = partialLeaveDates.contains(d);
                  final isShortHours = shortHoursDates?.contains(d) ?? false;
                  final dayRecords = byDate?[d];
                  final cell = _gridCell(
                    theme,
                    present,
                    false,
                    offDay,
                    isUpcoming,
                    isPartialLeave,
                    isShortHours,
                    dayIndex,
                  );
                  final tappable =
                      present &&
                      !isUpcoming &&
                      dayRecords != null &&
                      cellSizeOverride == null;
                  return Padding(
                    padding: EdgeInsets.only(right: col < 6 ? gap : 0),
                    child: SizedBox(
                      width: cellSize,
                      height: cellSize,
                      child: tappable
                          ? DayCellWithTooltip(
                              date: d,
                              dayRecords: dayRecords,
                              theme: theme,
                              child: cell,
                              workedSecondsForDay: (a) => _workedSecondsForDay(
                                a,
                                d,
                                now: DateTime.now(),
                              ),
                            )
                          : cell,
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      );
    }

    if (cellSizeOverride != null) {
      return SizedBox(
        width: cellSizeOverride * 7 + gap * 6,
        child: buildContent(cellSizeOverride),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final cellSize = (w - gap * 6) / 7;
        return buildContent(cellSize);
      },
    );
  }

  Widget _buildMonthLegend(
    BuildContext context,
    int year,
    int month,
    Set<DateTime> presentDates,
    Set<DateTime> partialLeaveDates,
    ThemeData theme, {
    Set<DateTime>? shortHoursDates,
  }) {
    final last = DateTime(year, month + 1, 0);
    final today = DateTime.now();
    int present = 0;
    int partialLeave = 0;
    int offDays = 0;
    int absent = 0;
    final todayNormalized = DateTime(today.year, today.month, today.day);
    for (int day = 1; day <= last.day; day++) {
      final d = DateTime(year, month, day);
      if (d.isAfter(todayNormalized)) continue;
      if (partialLeaveDates.contains(d) ||
          (shortHoursDates?.contains(d) ?? false)) {
        partialLeave++;
      }
      if (presentDates.contains(d)) {
        present++;
      } else if (_isOffDay(d)) {
        offDays++;
      } else {
        absent++;
      }
    }
    final minimalStyle = theme.textTheme.labelSmall?.copyWith(fontSize: 10);
    Widget minimalChip(String label, int value, Color color) => Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          LocaleDigitsText('$label: $value', style: minimalStyle),
        ],
      ),
    );
    Widget minimalChipCross(String label, int value) => Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Icon(
              Icons.close,
              size: 6,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 4),
          LocaleDigitsText('$label: $value', style: minimalStyle),
        ],
      ),
    );
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        minimalChip(
          translation.of('dashboard.days_present'),
          present,
          theme.colorScheme.primary,
        ),
        if (partialLeave > 0)
          minimalChip(
            translation.of('dashboard.partial_leave'),
            partialLeave,
            Colors.orange,
          ),
        minimalChip(
          translation.of('dashboard.days_absent'),
          absent,
          theme.colorScheme.error,
        ),
        minimalChipCross(
          translation.of('analytics.off_weekend_or_holiday'),
          offDays,
        ),
      ],
    );
  }

  Widget _buildYearGrid(
    BuildContext context,
    int year,
    Set<DateTime> presentDates,
    Set<DateTime> partialLeaveDates,
    ThemeData theme, {
    Set<DateTime>? shortHoursDates,
    Map<DateTime, List<AttendanceEntity>>? byDate,
  }) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          return SizedBox(
            width: _yearMonthBlockWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppDateTimeFormat.formatMonth(DateTime(year, month)),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                _buildMonthGrid(
                  context,
                  year,
                  month,
                  presentDates,
                  partialLeaveDates,
                  theme,
                  cellSizeOverride: _yearMonthCellSize,
                  shortHoursDates: shortHoursDates,
                  byDate: byDate,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearLegend(
    BuildContext context,
    int year,
    Set<DateTime> presentDates,
    Set<DateTime> partialLeaveDates,
    ThemeData theme, {
    Set<DateTime>? shortHoursDates,
  }) {
    int present = 0;
    int partialLeave = 0;
    int offDays = 0;
    int absent = 0;
    final first = DateTime(year, 1, 1);
    final last = DateTime(year, 12, 31);
    final total = last.difference(first).inDays + 1;
    final todayNormalized = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    for (int i = 0; i < total; i++) {
      final date = first.add(Duration(days: i));
      if (date.isAfter(todayNormalized)) continue;
      if (partialLeaveDates.contains(date) ||
          (shortHoursDates?.contains(date) ?? false))
        partialLeave++;
      if (presentDates.contains(date)) {
        present++;
      } else if (_isOffDay(date)) {
        offDays++;
      } else {
        absent++;
      }
    }
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _legendChip(
          theme,
          translation.of('dashboard.days_present'),
          present,
          theme.colorScheme.primary,
        ),
        if (partialLeave > 0)
          _legendChip(
            theme,
            translation.of('dashboard.partial_leave'),
            partialLeave,
            Colors.orange,
          ),
        _legendChip(
          theme,
          translation.of('dashboard.days_absent'),
          absent,
          theme.colorScheme.error,
        ),
        _legendChipWithCross(
          theme,
          translation.of('analytics.off_weekend_or_holiday'),
          offDays,
        ),
      ],
    );
  }

  Widget _gridCell(
    ThemeData theme,
    bool present,
    bool empty,
    bool isOffDay, [
    bool isUpcoming = false,
    bool isPartialLeave = false,
    bool isShortHours = false,
    int? dayNumber,
  ]) {
    Color color;
    bool showCross = false;
    if (empty || isUpcoming) {
      color = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25);
    } else if (present && (isPartialLeave || isShortHours)) {
      color = Colors.orange;
    } else if (present) {
      color = theme.colorScheme.primary;
    } else if (isOffDay) {
      color = theme.colorScheme.surfaceContainerHighest;
      showCross = true;
    } else {
      color = theme.colorScheme.error;
    }
    final textColor = (empty || isUpcoming)
        ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
        : (present || isOffDay ? theme.colorScheme.onSurface : Colors.white);
    return Container(
      margin: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2)
      ),
      child: dayNumber != null
          ? Stack(
              alignment: Alignment.center,
              children: [
                
                Center(
                  child: Text(
                    LocaleDigits.ofInt(dayNumber),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),

                if (showCross)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Icon(
                      Icons.close,
                      size: 8,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            )
          : showCross
          ? Center(
              child: Icon(
                Icons.close,
                size: 10,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
    );
  }

  Widget _legendChipWithCross(ThemeData theme, String label, int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Icon(
            Icons.close,
            size: 8,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 6),
        LocaleDigitsText('$label: $value', style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _legendChip(ThemeData theme, String label, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        LocaleDigitsText('$label: $value', style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildAttendanceHistory(
    BuildContext context,
    List<AttendanceEntity> list,
    DateTime now,
  ) {
    final theme = Theme.of(context);
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 48, color: theme.colorScheme.outline),
              const SizedBox(height: 12),
              Text(
                translation.of('no_item'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    final byDate = <DateTime, List<AttendanceEntity>>{};
    for (final a in list) {
      final checkInLocal = a.checkInAt.isUtc
          ? a.checkInAt.toLocal()
          : a.checkInAt;
      final d = DateTime(
        checkInLocal.year,
        checkInLocal.month,
        checkInLocal.day,
      );
      byDate.putIfAbsent(d, () => []).add(a);
    }
    final sortedDates = byDate.keys.toList()..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation.of('dashboard.attendance_history'),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedDates.length,
          separatorBuilder: (context, i) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final date = sortedDates[i];
            final dayRecords = byDate[date]!;
            final daySessions = List<AttendanceEntity>.from(dayRecords)
              ..sort((a, b) => a.checkInAt.compareTo(b.checkInAt));
            final isPartialLeave =
                daySessions.isNotEmpty &&
                daySessions.last.checkOutAt != null &&
                daySessions.last.isEarlyCheckout;
            final earlyCheckoutNote = dayRecords
                .where(
                  (a) =>
                      a.earlyCheckoutNote != null &&
                      a.earlyCheckoutNote!.isNotEmpty,
                )
                .map((a) => a.earlyCheckoutNote!)
                .firstOrNull;
            return AttendanceHistoryCard(
              date: date,
              dayRecords: dayRecords,
              isPartialLeave: isPartialLeave,
              earlyCheckoutNote: earlyCheckoutNote,
              now: now,
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ShowAttendanceHistoryDetails(
                    date: date,
                    dayRecords: dayRecords,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  List<AttendanceEntity>? _withLiveTodayBreaks(
    List<AttendanceEntity>? list,
    AttendanceState state,
  ) {
    if (list == null) return null;

    AttendanceEntity? liveAttendance;
    int liveBreakSeconds = 0;

    if (state is AttendanceStateCheckedIn) {
      liveAttendance = state.attendance;
      liveBreakSeconds = state.breakSeconds;
    } else if (state is AttendanceStateHistoryLoaded &&
        state.todayAttendance != null) {
      liveAttendance = state.todayAttendance;
      liveBreakSeconds = state.todayBreakSeconds;
    } else if (state is AttendanceStateHistoryLoading &&
        state.todayAttendance != null) {
      liveAttendance = state.todayAttendance;
      liveBreakSeconds = state.todayBreakSeconds;
    }

    if (liveAttendance == null) return list;

    return list.map((a) {
      if (a.id == liveAttendance!.id) {
        return a.copyWith(breakSeconds: liveBreakSeconds);
      }
      return a;
    }).toList();
  }

  static DateTime _checkInLocal(AttendanceEntity a) {
    return a.checkInAt.isUtc ? a.checkInAt.toLocal() : a.checkInAt;
  }

  static DateTime _effectiveCheckOut(AttendanceEntity a, {DateTime? now}) {
    if (a.checkOutAt != null)
      return a.checkOutAt!.isUtc ? a.checkOutAt!.toLocal() : a.checkOutAt!;
    final checkInLocal = _checkInLocal(a);
    final startOfDay = DateTime(
      checkInLocal.year,
      checkInLocal.month,
      checkInLocal.day,
    );
    final endOfCheckInDay = startOfDay.add(const Duration(days: 1));
    if (now != null) {
      return now.isBefore(endOfCheckInDay) ? now : endOfCheckInDay;
    }
    return endOfCheckInDay;
  }

  static int _workedSecondsForDay(
    AttendanceEntity a,
    DateTime dateLocal, {
    DateTime? now,
  }) {
    final checkInLocal = _checkInLocal(a);
    final startOfDay = DateTime(dateLocal.year, dateLocal.month, dateLocal.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final endAt = a.checkOutAt != null
        ? _effectiveCheckOut(a)
        : (now != null ? (now.isBefore(endOfDay) ? now : endOfDay) : endOfDay);
    final endAtCapped = endAt.isAfter(endOfDay) ? endOfDay : endAt;
    final effectiveStart = checkInLocal.isBefore(startOfDay)
        ? startOfDay
        : checkInLocal;
    if (!endAtCapped.isAfter(effectiveStart)) return 0;
    final seconds =
        endAtCapped.difference(effectiveStart).inSeconds - a.breakSeconds;
    return seconds.clamp(0, 86400 * 2);
  }

  bool _isOffDay(DateTime d) {
    if (_weekendWeekdays.contains(d.weekday)) return true;
    return _holidays.any((h) => h.month == d.month && h.day == d.day);
  }

  void _applyCalendarFilter(BuildContext context, String mode, int? year) {
    final cubit = context.read<MonthlyScoreCubit>();
    if (mode == 'monthly') {
      cubit.setViewMode('monthly');
    } else if (year != null) {
      cubit.setViewMode('year');
      cubit.setSelectedYear(year);
      cubit.loadYear(year);
    }
  }
}
