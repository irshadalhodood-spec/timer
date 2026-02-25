import 'package:employee_track/base_module/domain/entities/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';

import '../../../../attendance_module/domain/entities/attendance_entity.dart';
import '../../../../base_module/presentation/core/values/app_constants.dart';
import '../../../../base_module/presentation/feature/live_time/live_time_cubit.dart';
import '../../../../base_module/presentation/util/locale_digits.dart';
import '../../../../employee_track/domain/entities/break_record_entity.dart';
import 'progress_bar.dart';

class LiveDailySummary extends StatelessWidget {
  const LiveDailySummary({super.key,
    required this.checkInAt,
    required this.breaks,
    this.todayWorkedSeconds,
    this.todayBreakSeconds,
    this.todaySessions,
    this.currentAttendanceId,
    this.currentBreakSeconds,
  });

  final DateTime checkInAt;
  final List<BreakRecordEntity> breaks;
  final int? todayWorkedSeconds;
  final int? todayBreakSeconds;
  final List<AttendanceEntity>? todaySessions;
  final String? currentAttendanceId;
  final int? currentBreakSeconds;

  static String _formatHoursMinutes(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    if (h > 0) return '${h}${translation.of('analytics.h')} ${m}${translation.of('analytics.mi')}';
    return '${m}${translation.of('analytics.mi')}';
  }

  int _totalBreakSecondsFromBreaks(DateTime now) {
    int sec = 0;
    for (final b in breaks) {
      if (b.endAt != null) {
        sec += b.endAt!.difference(b.startAt).inSeconds;
      } else {
        sec += now.difference(b.startAt).inSeconds;
      }
    }
    return sec;
  }

  int _workedSeconds(DateTime now) {
    if (todaySessions != null &&
        todaySessions!.isNotEmpty &&
        currentAttendanceId != null &&
        currentBreakSeconds != null) {
      int total = 0;
      for (final session in todaySessions!) {
        if (session.id == currentAttendanceId) {
          total += (now.difference(session.checkInAt).inSeconds - currentBreakSeconds!).clamp(0, 999999);
        } else if (session.checkOutAt != null) {
          total += (session.checkOutAt!.difference(session.checkInAt).inSeconds - session.breakSeconds).clamp(0, 999999);
        }
      }
      return total;
    }
    if (todayWorkedSeconds != null) return todayWorkedSeconds!.clamp(0, 999999);
    final totalElapsed = now.difference(checkInAt).inSeconds;
    final breakSecs = _totalBreakSecondsFromBreaks(now);
    return (totalElapsed - breakSecs).clamp(0, 999999);
  }

  int _breakSecondsForBar(DateTime now) {
    if (todaySessions != null &&
        todaySessions!.isNotEmpty &&
        currentAttendanceId != null &&
        currentBreakSeconds != null) {
      int total = 0;
      for (final session in todaySessions!) {
        if (session.id == currentAttendanceId) {
          total += currentBreakSeconds!;
        } else {
          total += session.breakSeconds;
        }
      }
      return total;
    }
    if (todayBreakSeconds != null) return todayBreakSeconds!;
    return _totalBreakSecondsFromBreaks(now);
  }

  /// Build timeline segments (work → break → work → … → remaining) for the progress bar. Only when currently checked in (currentAttendanceId != null).
  List<ProgressBarSegment>? _buildTimelineSegments(DateTime now) {
    if (currentAttendanceId == null) return null;
    final sortedBreaks = List<BreakRecordEntity>.from(breaks)..sort((a, b) => a.startAt.compareTo(b.startAt));
    final segments = <ProgressBarSegment>[];
    var currentStart = checkInAt;

    for (final b in sortedBreaks) {
      final workDuration = b.startAt.difference(currentStart).inSeconds;
      if (workDuration > 0) {
        segments.add(ProgressBarSegment(
          type: 'work',
          startAt: currentStart,
          endAt: b.startAt,
          durationSeconds: workDuration,
        ));
      }
      final breakEnd = b.endAt ?? now;
      final breakDuration = breakEnd.difference(b.startAt).inSeconds;
      if (breakDuration > 0) {
        segments.add(ProgressBarSegment(
          type: 'break',
          startAt: b.startAt,
          endAt: breakEnd,
          durationSeconds: breakDuration,
        ));
      }
      currentStart = breakEnd;
    }

    final finalWorkDuration = now.difference(currentStart).inSeconds;
    if (finalWorkDuration > 0) {
      segments.add(ProgressBarSegment(
        type: 'work',
        startAt: currentStart,
        endAt: now,
        durationSeconds: finalWorkDuration,
      ));
    }

    final totalWorkSoFar = segments
        .where((s) => s.type == 'work')
        .fold<int>(0, (s, e) => s + e.durationSeconds);
    final otSeconds = (totalWorkSoFar - AppConstants.expectedWorkSecondsPerDay).clamp(0, 999999);
    final totalSoFar = segments.fold<int>(0, (s, e) => s + e.durationSeconds);
    final remaining = otSeconds > 0
        ? 0
        : (AppConstants.expectedWorkSecondsPerDay - totalSoFar).clamp(0, AppConstants.expectedWorkSecondsPerDay);

    if (otSeconds > 0) {
      // Replace the tail of the last work segment with OT
      final lastWorkIndex = segments.lastIndexWhere((s) => s.type == 'work');
      if (lastWorkIndex >= 0) {
        final lastWork = segments[lastWorkIndex];
        final regularWorkDuration = lastWork.durationSeconds - otSeconds;
        if (regularWorkDuration > 0) {
          segments[lastWorkIndex] = ProgressBarSegment(
            type: 'work',
            startAt: lastWork.startAt,
            endAt: lastWork.startAt?.add(Duration(seconds: regularWorkDuration)),
            durationSeconds: regularWorkDuration,
          );
          segments.add(ProgressBarSegment(
            type: 'ot',
            startAt: lastWork.startAt?.add(Duration(seconds: regularWorkDuration)),
            endAt: lastWork.endAt,
            durationSeconds: otSeconds,
          ));
        } else {
          segments[lastWorkIndex] = ProgressBarSegment(
            type: 'ot',
            startAt: lastWork.startAt,
            endAt: lastWork.endAt,
            durationSeconds: lastWork.durationSeconds,
          );
        }
      }
    } else if (remaining > 0) {
      segments.add(ProgressBarSegment(
        type: 'remaining',
        startAt: now,
        endAt: now.add(Duration(seconds: remaining)),
        durationSeconds: remaining,
      ));
    }

    return segments.isEmpty ? null : segments;
  }

  @override
  Widget build(BuildContext context) {
    final needsLiveTick = (todaySessions != null &&
            todaySessions!.isNotEmpty &&
            currentAttendanceId != null) ||
        (todayWorkedSeconds == null && todayBreakSeconds == null);
    if (needsLiveTick) {
      return BlocBuilder<LiveTimeCubit, DateTime>(
        buildWhen: (prev, next) =>
            prev.second != next.second || prev.minute != next.minute || prev.hour != next.hour,
        builder: (context, now) {
          final worked = _workedSeconds(now);
          final breakSecs = _breakSecondsForBar(now);
          final segments = _buildTimelineSegments(now);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LocaleDigitsText(
                '${translation.of('dashboard.today')} ${_formatHoursMinutes(worked)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              NineHourProgressBar(
                workedSeconds: worked,
                breakSeconds: breakSecs,
                segments: segments,
              ),
            ],
          );
        },
      );
    }
    final now = DateTime.now();
    final worked = _workedSeconds(now);
    final breakSecs = _breakSecondsForBar(now);
    final segments = _buildTimelineSegments(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LocaleDigitsText(
          '${translation.of('dashboard.today')} ${_formatHoursMinutes(worked)}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        NineHourProgressBar(
          workedSeconds: worked,
          breakSeconds: breakSecs,
          segments: segments,
        ),
      ],
    );
  }
}
