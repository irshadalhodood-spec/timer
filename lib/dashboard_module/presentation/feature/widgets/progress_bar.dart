import 'package:flutter/material.dart';

import '../../../../base_module/presentation/core/values/app_constants.dart';
import '../../../../base_module/presentation/util/date_time_format.dart';
import '../../../../base_module/presentation/util/locale_digits.dart';

const int _targetSeconds = AppConstants.expectedWorkSecondsPerDay;
const double _barHeight = 10.0;
const double _minSegmentWidth = 3.0;

/// One segment of the progress bar in timeline order (work, break, work, break, … or remaining).
class ProgressBarSegment {
  const ProgressBarSegment({
    required this.type,
    required this.durationSeconds,
    this.startAt,
    this.endAt,
  });
  final String type; // 'work' | 'break' | 'remaining'
  final int durationSeconds;
  final DateTime? startAt;
  final DateTime? endAt;

  String get label {
    switch (type) {
      case 'work':
        return 'Work';
      case 'break':
        return 'Break';
      default:
        return 'Remaining';
    }
  }

  String get tooltipMessage {
    final durationStr = _formatDuration(durationSeconds);
    if (startAt != null && endAt != null) {
      final startStr = AppDateTimeFormat.formatTime(startAt!);
      final endStr = AppDateTimeFormat.formatTime(endAt!);
      return LocaleDigits.format('$label  $startStr – $endStr  ($durationStr)');
    }
    if (startAt != null) {
      final startStr = AppDateTimeFormat.formatTime(startAt!);
      return LocaleDigits.format('$label  $startStr – …  ($durationStr)');
    }
    return LocaleDigits.format('$label  ($durationStr)');
  }

  static String _formatDuration(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

class NineHourProgressBar extends StatelessWidget {
  const NineHourProgressBar({
    super.key,
    required this.workedSeconds,
    required this.breakSeconds,
    this.segments,
  });

  final int workedSeconds;
  final int breakSeconds;
  /// When set, bar is drawn in timeline order (work → break → work → … → remaining) and each segment shows tooltip on hover/tap.
  final List<ProgressBarSegment>? segments;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final workColor = colorScheme.primary;
    final breakColor = colorScheme.surfaceContainerHighest;
    final remainingColor = colorScheme.error.withOpacity(0.1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        if (totalWidth <= 0) return const SizedBox.shrink();

        if (segments != null && segments!.isNotEmpty) {
          return _buildTimelineBar(
            context,
            totalWidth,
            segments!,
            workColor: workColor,
            breakColor: breakColor,
            remainingColor: remainingColor,
          );
        }

        // Legacy: single work, break, remaining
        final work = workedSeconds.clamp(0, _targetSeconds);
        final break_ = breakSeconds.clamp(0, _targetSeconds - work);
        final remaining = (_targetSeconds - work - break_).clamp(0, _targetSeconds);
        final total = work + break_ + remaining;
        final scale = total > 0 ? totalWidth / total : totalWidth;

        double workW = (work * scale).roundToDouble();
        double breakW = (break_ * scale).roundToDouble();
        double remainingW = (remaining * scale).roundToDouble();

        if (work > 0 && workW < _minSegmentWidth) workW = _minSegmentWidth;
        if (break_ > 0 && breakW < _minSegmentWidth) breakW = _minSegmentWidth;
        if (remaining > 0 && remainingW < _minSegmentWidth) remainingW = _minSegmentWidth;

        final sum = workW + breakW + remainingW;
        if (sum > totalWidth && sum > 0) {
          workW = totalWidth * (workW / sum);
          breakW = totalWidth * (breakW / sum);
          remainingW = totalWidth * (remainingW / sum);
        }
        remainingW = (totalWidth - workW - breakW).clamp(0.0, totalWidth);

        final children = <Widget>[];
        if (workW > 0) {
          children.add(SizedBox(width: workW, height: _barHeight, child: ColoredBox(color: workColor)));
        }
        if (breakW > 0) {
          children.add(SizedBox(width: breakW, height: _barHeight, child: ColoredBox(color: breakColor)));
        }
        if (remainingW > 0) {
          children.add(SizedBox(width: remainingW, height: _barHeight, child: ColoredBox(color: remainingColor)));
        }
        if (children.isEmpty) {
          children.add(SizedBox(width: totalWidth, height: _barHeight, child: ColoredBox(color: remainingColor)));
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: totalWidth,
            height: _barHeight,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: children,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimelineBar(
    BuildContext context,
    double totalWidth,
    List<ProgressBarSegment> segments, {
    required Color workColor,
    required Color breakColor,
    required Color remainingColor,
  }) {
    final totalSeconds = segments.fold<int>(0, (s, e) => s + e.durationSeconds);
    final scale = totalSeconds > 0 ? totalWidth / totalSeconds : totalWidth;

    final validSegments = segments.where((s) => s.durationSeconds > 0).toList();
    if (validSegments.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: totalWidth,
          height: _barHeight,
          child: ColoredBox(color: remainingColor),
        ),
      );
    }

    final widths = <double>[];
    for (final seg in validSegments) {
      double w = (seg.durationSeconds * scale).roundToDouble();
      if (w < _minSegmentWidth) w = _minSegmentWidth;
      widths.add(w);
    }
    var sumW = widths.fold<double>(0, (a, b) => a + b);
    if (sumW > totalWidth && sumW > 0) {
      final ratio = totalWidth / sumW;
      for (var i = 0; i < widths.length; i++) {
        widths[i] = (widths[i] * ratio).roundToDouble();
        if (widths[i] < _minSegmentWidth) widths[i] = _minSegmentWidth;
      }
    }
    sumW = widths.fold<double>(0, (a, b) => a + b);
    if (widths.isNotEmpty && (sumW - totalWidth).abs() > 0.5) {
      widths[widths.length - 1] = (totalWidth - sumW + widths.last).clamp(_minSegmentWidth, totalWidth);
    }

    final children = <Widget>[];
    for (var i = 0; i < validSegments.length; i++) {
      final seg = validSegments[i];
      final w = i < widths.length ? widths[i] : totalWidth / validSegments.length;
      final color = seg.type == 'work'
          ? workColor
          : seg.type == 'break'
              ? breakColor
              : remainingColor;
      children.add(
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: seg.tooltipMessage,
          preferBelow: false,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              width: w,
              height: _barHeight,
              child: ColoredBox(color: color),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: totalWidth,
        height: _barHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: children,
        ),
      ),
    );
  }
}
