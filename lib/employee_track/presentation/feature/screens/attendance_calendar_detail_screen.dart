import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../attendance_module/domain/entities/attendance_entity.dart';
import '../../../../../base_module/domain/entities/translation.dart';
import '../../../domain/entities/break_record_entity.dart';
import '../../../domain/repositories/break_record_repository.dart';
import '../../../../../base_module/presentation/core/values/app_constants.dart';
import '../../../../../base_module/presentation/util/date_time_format.dart';
import '../../../../../base_module/presentation/util/locale_digits.dart';
import '../models/attendance_calander_models.dart';

class AttendanceCalendarDetailScreen extends StatefulWidget {
  const AttendanceCalendarDetailScreen({
    super.key,
    required this.attendanceList,
    this.weekendWeekdays,
    this.holidays,
  });

  final List<AttendanceEntity> attendanceList;
  final List<int>? weekendWeekdays;
  final List<DateTime>? holidays;

  @override
  State<AttendanceCalendarDetailScreen> createState() =>
      _AttendanceCalendarDetailScreenState();
}

class _AttendanceCalendarDetailScreenState
    extends State<AttendanceCalendarDetailScreen> {
  late final Set<DateTime> _presentDates;
  late final Set<DateTime> _partialLeaveDates;
  late final Set<DateTime> _shortHoursDates;
  late final Map<DateTime, List<AttendanceEntity>> _calendarByDate;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  static const double _minCellSize = 46;
  static const double _maxCellSize = 62;
  static const int _dayViewStartHour = 0;
  static const int _dayViewEndHour = 24;
  /// Fixed height per hour row (gap between 1pm, 2pm, etc.). Larger = taller card and more spacing.
  static const double _hourRowHeight = 80;

  @override
  void initState() {
    super.initState();
    _computeCalendarData();
  }

  void _computeCalendarData() {
    final list = widget.attendanceList;
    final presentDates = <DateTime>{};
    final partialLeaveDates = <DateTime>{};
    final shortHoursDates = <DateTime>{};
    final calendarByDate = <DateTime, List<AttendanceEntity>>{};

    if (list.isNotEmpty) {
      final byDate = <DateTime, List<AttendanceEntity>>{};
      for (final a in list) {
        final checkInLocal =
            a.checkInAt.isUtc ? a.checkInAt.toLocal() : a.checkInAt;
        final d = DateTime(
            checkInLocal.year, checkInLocal.month, checkInLocal.day);
        presentDates.add(d);
        byDate.putIfAbsent(d, () => []).add(a);
        calendarByDate.putIfAbsent(d, () => []).add(a);
      }
      for (final entry in byDate.entries) {
        final daySessions = List<AttendanceEntity>.from(entry.value)
          ..sort((a, b) => a.checkInAt.compareTo(b.checkInAt));
        if (daySessions.isNotEmpty &&
            daySessions.last.checkOutAt != null &&
            daySessions.last.isEarlyCheckout) {
          partialLeaveDates.add(entry.key);
        }
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

    _presentDates = presentDates;
    _partialLeaveDates = partialLeaveDates;
    _shortHoursDates = shortHoursDates;
    _calendarByDate = calendarByDate;
  }

  String _shortDow(int weekday) {
    const en = ['', 'M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return weekday >= 1 && weekday <= 7 ? en[weekday] : '';
  }

  bool _isOffDay(DateTime d) {
    final weekend = widget.weekendWeekdays ?? [6, 7];
    final holidays = widget.holidays ?? [];
    if (weekend.contains(d.weekday)) return true;
    return holidays.any((h) => h.month == d.month && h.day == d.day);
  }

  static DateTime _checkInLocal(AttendanceEntity a) {
    return a.checkInAt.isUtc ? a.checkInAt.toLocal() : a.checkInAt;
  }

  static DateTime _effectiveCheckOut(AttendanceEntity a, {DateTime? now}) {
    if (a.checkOutAt != null) {
      return a.checkOutAt!.isUtc
          ? a.checkOutAt!.toLocal()
          : a.checkOutAt!;
    }
    final checkInLocal = _checkInLocal(a);
    final startOfDay =
        DateTime(checkInLocal.year, checkInLocal.month, checkInLocal.day);
    final endOfCheckInDay = startOfDay.add(const Duration(days: 1));
    if (now != null) {
      return now.isBefore(endOfCheckInDay) ? now : endOfCheckInDay;
    }
    return endOfCheckInDay;
  }

  static int _workedSecondsForDay(
      AttendanceEntity a, DateTime dateLocal, {DateTime? now}) {
    final checkInLocal = _checkInLocal(a);
    final startOfDay =
        DateTime(dateLocal.year, dateLocal.month, dateLocal.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final endAt = a.checkOutAt != null
        ? _effectiveCheckOut(a)
        : (now != null
            ? (now.isBefore(endOfDay) ? now : endOfDay)
            : endOfDay);
    final endAtCapped = endAt.isAfter(endOfDay) ? endOfDay : endAt;
    final effectiveStart =
        checkInLocal.isBefore(startOfDay) ? startOfDay : checkInLocal;
    if (!endAtCapped.isAfter(effectiveStart)) return 0;
    final seconds =
        endAtCapped.difference(effectiveStart).inSeconds - a.breakSeconds;
    return seconds.clamp(0, 86400 * 2);
  }

  Gradient _gradientForDay(
    bool isUpcoming,
    bool present,
    bool offDay,
    bool isPartialLeave,
    bool isShortHours,
    ColorScheme scheme,
  ) {
    if (isUpcoming) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          scheme.surfaceContainerHighest.withValues(alpha: 0.3),
          scheme.surfaceContainerHighest.withValues(alpha: 0.15),
        ],
      );
    }
    if (present && (isPartialLeave || isShortHours)) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.orange.shade400, Colors.orange.shade700],
      );
    }
    if (present) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [scheme.primary.withValues(alpha: 0.9), scheme.primary],
      );
    }
    if (offDay) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          scheme.surfaceContainerHighest,
          scheme.surfaceContainerHighest.withValues(alpha: 0.8),
        ],
      );
    }
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [scheme.error.withValues(alpha: 0.8), scheme.error],
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
    ThemeData theme,
  ) {
    final d = DateTime(day.year, day.month, day.day);
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final isUpcoming = d.isAfter(todayNormalized);
    final present = _presentDates.contains(d);
    final offDay = _isOffDay(d);
    final isPartialLeave = _partialLeaveDates.contains(d);
    final isShortHours = _shortHoursDates.contains(d);

    final gradient = _gradientForDay(
      isUpcoming, present, offDay, isPartialLeave, isShortHours, theme.colorScheme,
    );
    final textColor = (isUpcoming || offDay)
        ? theme.colorScheme.onSurfaceVariant
        : Colors.white;
    final showCross = offDay;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          
          Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                LocaleDigits.ofInt(day.day),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          ),
           if (showCross) ...[
                   
                    Center(child: Icon(Icons.clear_rounded, size: 45, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3))),
                  ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final firstDay = DateTime(now.year - 1, 1, 1);
    final lastDay = DateTime(now.year + 1, 12, 31);

    final today = DateTime(now.year, now.month, now.day);
    final isSelectedToday = _selectedDay != null &&
        _selectedDay!.year == today.year &&
        _selectedDay!.month == today.month &&
        _selectedDay!.day == today.day;

    return Scaffold(
      appBar: AppBar(
        title: Text(translation.of('analytics.calendar_detail')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  //   child: Row(
                  //     children: [
                  //       if (!isSelectedToday)
                  //         TextButton.icon(
                  //           onPressed: () {
                  //             setState(() {
                  //               _selectedDay = today;
                  //               _focusedDay = now;
                  //             });
                  //           },
                  //           icon: Icon(
                  //             Icons.today_outlined,
                  //             size: 18,
                  //             color: theme.colorScheme.primary,
                  //           ),
                  //           label: Text(
                  //             translation.of('analytics.today'),
                  //             style: theme.textTheme.labelLarge?.copyWith(
                  //               color: theme.colorScheme.primary,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ),
                  //       const Spacer(),
                  //     ],
                  //   ),
                  // ),
                  LayoutBuilder(
                builder: (context, constraints) {
                  final cellSize = (constraints.maxWidth / 7)
                      .clamp(_minCellSize, _maxCellSize);
                  final gridWidth = cellSize * 7;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: gridWidth,
                      child: TableCalendar(
                        firstDay: firstDay,
                        lastDay: lastDay,
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            _selectedDay != null &&
                            _selectedDay!.year == day.year &&
                            _selectedDay!.month == day.month &&
                            _selectedDay!.day == day.day,
                        onDaySelected: (selected, focused) {
                          setState(() {
                            _selectedDay = selected;
                            _focusedDay = focused;
                          });
                        },
                        calendarFormat: _calendarFormat,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                          CalendarFormat.twoWeeks: '2 weeks',
                          CalendarFormat.week: 'Week',
                        },
                        onFormatChanged: (format) {
                          setState(() => _calendarFormat = format);
                        },
                        onPageChanged: (focusedDay) {
                          setState(() => _focusedDay = focusedDay);
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) =>
                              _buildDayCell(context, day, focusedDay, theme),
                          todayBuilder: (context, day, focusedDay) =>
                              _buildDayCell(context, day, focusedDay, theme),
                          outsideBuilder: (context, day, focusedDay) =>
                              _buildDayCell(context, day, focusedDay, theme),
                          dowBuilder: (context, day) => Center(
                            child: Text(
                              _shortDow(day.weekday),
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          cellMargin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 2),
                          defaultTextStyle: theme.textTheme.bodySmall!,
                          weekendTextStyle: theme.textTheme.bodySmall!,
                          outsideDaysVisible: true,

                          todayDecoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.6),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          selectedDecoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          markerDecoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: true,
                          titleCentered: true,
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: theme.colorScheme.onSurface,
                            size: 28,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurface,
                            size: 28,
                          ),
                          headerMargin: const EdgeInsets.symmetric(vertical: 12),
                          titleTextStyle: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          formatButtonDecoration: BoxDecoration(
                            border: Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          formatButtonTextStyle: (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        daysOfWeekHeight: 36,
                        rowHeight: 52,
                      ),
                    ),
                  );
                },
              ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      translation.of('analytics.tap_day_hint'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(theme),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                translation.of('analytics.schedule'),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            _buildHourlyDayView(theme, _selectedDay ?? _focusedDay),
          ],
        ),
      ),
    );
  }

  String _hourLabel(int hour) {
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    if (hour < 12) return '$hour AM';
    return '${hour - 12} PM';
  }

  static DateTime _toLocal(DateTime? d) {
    if (d == null) return DateTime.now();
    return d.isUtc ? d.toLocal() : d;
  }

  /// Time with minutes always visible (e.g. "1:37 PM", "2:44 PM") for timeline accuracy.
  static String _formatTimeExact(DateTime d) {
    final locale = translation.selectedLocale?.languageCode ?? 'en';
    return DateFormat('h:mm a', locale).format(d);
  }

  Future<DayViewData> _getTimeBlocksWithExactBreaks(
    DateTime day,
    List<AttendanceEntity> records,
    BreakRecordRepository breakRepo,
  ) async {
    // Use local date only so timeline positions match displayed times (e.g. 9:05 not 8:30).
    final localDay = day.isUtc ? day.toLocal() : day;
    final dayStart = DateTime(localDay.year, localDay.month, localDay.day, 0, 0, 0, 0);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final now = DateTime.now();
    final sorted = List<AttendanceEntity>.from(records)
      ..sort((a, b) => a.checkInAt.compareTo(b.checkInAt));
    final blocks = <TimeBlock>[];
    final details = <DayDetailEntry>[];

    for (final a in sorted) {
      final checkIn = _checkInLocal(a);
      final checkOut = a.checkOutAt != null
          ? _toLocal(a.checkOutAt)
          : (now.isAfter(dayEnd) ? dayEnd : now);
      if (checkOut.isBefore(dayStart) || checkIn.isAfter(dayEnd)) continue;
      final sessionStart = checkIn.isBefore(dayStart) ? dayStart : checkIn;
      final sessionEnd = checkOut.isAfter(dayEnd) ? dayEnd : checkOut;

      details.add(DayDetailEntry(
        type: DayDetailType.checkIn,
        timeLabel: _formatTimeExact(checkIn),
        location: a.checkInAddress,
      ));

      final breakList = await breakRepo.getByAttendanceId(a.id);
      final breaksWithTimes = <(DateTime, DateTime, BreakRecordEntity)>[];
      for (final b in breakList) {
        if (b.endAt == null && !b.startAt.isBefore(sessionEnd)) continue;
        final bStart = _toLocal(b.startAt);
        final bEnd = b.endAt != null ? _toLocal(b.endAt!) : sessionEnd;
        if (!bEnd.isAfter(bStart)) continue;
        breaksWithTimes.add((bStart, bEnd, b));
      }
      breaksWithTimes.sort((x, y) => x.$1.compareTo(y.$1));

      for (final (bStart, bEnd, b) in breaksWithTimes) {
        details.add(DayDetailEntry(
          type: DayDetailType.breakType,
          timeLabel: '${_formatTimeExact(bStart)} – ${_formatTimeExact(bEnd)}',
          location: b.startAddress ?? b.endAddress,
        ));
      }

      details.add(DayDetailEntry(
        type: DayDetailType.checkOut,
        timeLabel: _formatTimeExact(checkOut),
        location: a.checkOutAddress,
      ));

      String _detailStr(String time, String? loc) {
        if (loc != null && loc.trim().isNotEmpty) return '$time · $loc';
        return time;
      }
      final checkInStr = _detailStr(_formatTimeExact(checkIn), a.checkInAddress);
      final checkOutStr = _detailStr(_formatTimeExact(checkOut), a.checkOutAddress);

      final breaks = breaksWithTimes.map((t) => (t.$1, t.$2)).toList();
      final workStarts = <DateTime>[];
      final workEnds = <DateTime>[];
      DateTime cur = sessionStart;
      for (final (bStart, bEnd) in breaks) {
        if (bStart.isAfter(cur)) {
          workStarts.add(cur);
          workEnds.add(bStart);
        }
        cur = bEnd.isAfter(cur) ? bEnd : cur;
      }
      if (cur.isBefore(sessionEnd)) {
        workStarts.add(cur);
        workEnds.add(sessionEnd);
      }

      int workedSoFar = 0;
      const normalWorkCap = AppConstants.expectedWorkSecondsPerDay ~/ 60;
      var workBlockCount = 0;

      for (int i = 0; i < workStarts.length; i++) {
        final segStart = workStarts[i];
        final segEnd = workEnds[i];
        int segMins = segEnd.difference(segStart).inMinutes;
        if (segMins <= 0) continue;

        final startSeconds = segStart.difference(dayStart).inSeconds;
        final remainingNormal = normalWorkCap - workedSoFar;
        final isLastSegment = i == workStarts.length - 1;
        if (remainingNormal > 0) {
          final workMins = segMins > remainingNormal ? remainingNormal : segMins;
          String? workDetail = workBlockCount == 0 ? checkInStr : null;
          if (isLastSegment && segMins <= workMins) {
            workDetail = workDetail != null ? '$workDetail\n$checkOutStr' : checkOutStr;
          }
          blocks.add(TimeBlock(
            label: translation.of('analytics.work'),
            startSeconds: startSeconds,
            durationSeconds: workMins * 60,
            isWork: true,
            detailText: workDetail,
          ));
          workBlockCount++;
          workedSoFar += workMins;
          segMins -= workMins;
          if (segMins > 0) {
            blocks.add(TimeBlock(
              label: translation.of('analytics.ot'),
              startSeconds: startSeconds + (workMins * 60),
              durationSeconds: segMins * 60,
              isOt: true,
              detailText: isLastSegment ? checkOutStr : null,
            ));
            workBlockCount++;
          }
        } else {
          blocks.add(TimeBlock(
            label: translation.of('analytics.ot'),
            startSeconds: startSeconds,
            durationSeconds: segMins * 60,
            isOt: true,
            detailText: isLastSegment ? checkOutStr : null,
          ));
          workBlockCount++;
        }
      }

      for (var k = 0; k < breaksWithTimes.length; k++) {
        final (bStart, bEnd, b) = breaksWithTimes[k];
        if (bStart.isBefore(dayStart) && bEnd.isBefore(dayStart)) continue;
        if (bStart.isAfter(dayEnd)) continue;
        final start = bStart.isBefore(dayStart) ? dayStart : bStart;
        final end = bEnd.isAfter(dayEnd) ? dayEnd : bEnd;
        final durationSeconds = end.difference(start).inSeconds;
        if (durationSeconds <= 0) continue;
        final timeRange = '${_formatTimeExact(bStart)} – ${_formatTimeExact(bEnd)}';
        final breakDetail = _detailStr(timeRange, b.startAddress ?? b.endAddress);
        blocks.add(TimeBlock(
          label: translation.of('analytics.break'),
          startSeconds: start.difference(dayStart).inSeconds,
          durationSeconds: durationSeconds,
          isBreak: true,
          detailText: breakDetail,
        ));
      }
    }

    blocks.sort((a, b) => a.startSeconds.compareTo(b.startSeconds));
    return DayViewData(blocks: blocks, details: details);
  }

  Widget _buildHourlyDayView(ThemeData theme, DateTime day) {
    final localDay = day.isUtc ? day.toLocal() : day;
    final dayKey = DateTime(localDay.year, localDay.month, localDay.day);
    final records = _calendarByDate[dayKey] ?? [];
    if (records.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppDateTimeFormat.formatDate(dayKey),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              translation.of('analytics.no_attendance_day'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final breakRepo = context.read<BreakRecordRepository>();

    return FutureBuilder<DayViewData>(
      future: _getTimeBlocksWithExactBreaks(dayKey, records, breakRepo),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final blocks = data?.blocks ?? [];
        if (snapshot.connectionState == ConnectionState.waiting && data == null) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppDateTimeFormat.formatDate(dayKey),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      translation.of('analytics.loading_schedule'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final hourCount = _dayViewEndHour - _dayViewStartHour;
        final totalHeight = hourCount * _hourRowHeight;
        const totalSeconds = 24 * 3600;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  AppDateTimeFormat.formatDate(dayKey),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 44,
                    child: Column(
                      children: List.generate(hourCount, (i) {
                        final hour = _dayViewStartHour + i;
                        return SizedBox(
                          height: _hourRowHeight,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _hourLabel(hour),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: totalHeight,
                      child: Stack(
                        children: [
                          ...List.generate(hourCount - 1, (i) => Positioned(
                            left: 0,
                            right: 0,
                            top: (i + 1) * _hourRowHeight - 1,
                            height: 1,
                            child: Container(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
                          )),
                          ...blocks.map((b) {
                        final top = (b.startSeconds / totalSeconds) * totalHeight+40;
                        final height = (b.durationSeconds / totalSeconds) * totalHeight;
                        final hasDetail = b.detailText != null && b.detailText!.trim().isNotEmpty;
                        const minBlockNoDetail = 36.0;
                        const minBlockWithDetail = 56.0;
                        final blockHeight = height < (hasDetail ? minBlockWithDetail : minBlockNoDetail) && b.durationSeconds > 0
                            ? (hasDetail ? minBlockWithDetail : minBlockNoDetail)
                            : height;
                        Color bg;
                        if (b.isBreak) {
                          bg = Colors.orange;
                        } else if (b.isOt) {
                          bg = theme.colorScheme.tertiary;
                        } else {
                          bg = theme.colorScheme.primary;
                        }
                        return Positioned(
                          left: 0,
                          right: 0,
                          top: top,
                          height: blockHeight,
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b.label,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                if (hasDetail)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      b.detailText??'',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.95),
                                        fontSize: 9,
                                        height: 1.2,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
                ],
              ),
            ],
          ),
      );
      },
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Wrap(
      spacing: 16,
      runSpacing: 10,
      children: [
            _legendChip(
              theme,
              translation.of('dashboard.days_present'),
              _presentDates.length,
              theme.colorScheme.primary,
            ),
            if (_partialLeaveDates.isNotEmpty || _shortHoursDates.isNotEmpty)
              _legendChip(
                theme,
                translation.of('dashboard.partial_leave'),
                _partialLeaveDates.union(_shortHoursDates).length,
                Colors.orange,
              ),
            _legendChipWithCross(
              theme,
              translation.of('analytics.off_weekend_or_holiday'),
            ),
            _legendChip(
              theme,
              translation.of('dashboard.days_absent'),
              0,
              theme.colorScheme.error,
            ),
          ],
    );
  }

  Widget _legendChip(ThemeData theme, String label, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label${value > 0 ? ': ${LocaleDigits.ofInt(value)}' : ''}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _legendChipWithCross(ThemeData theme, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Icon(
            Icons.close,
            size: 10,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

