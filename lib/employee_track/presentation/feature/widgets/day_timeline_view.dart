import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../base_module/presentation/util/date_time_format.dart';
import '../../../../../base_module/domain/entities/translation.dart';
import '../models/attendance_calander_models.dart';

/// Day schedule as a list of blocks with explicit time ranges (e.g. "8:52 AM – 12:42 PM").
/// Avoids positioning bugs and always shows times correctly.
class DayTimelineView extends StatelessWidget {
  const DayTimelineView({
    super.key,
    required this.day,
    this.data,
    this.isLoading = false,
    this.translation,
  });

  final DateTime day;
  final DayViewData? data;
  final bool isLoading;
  final Translation? translation;

  String _formatTime(DateTime d) {
    final locale = translation?.selectedLocale?.languageCode ?? 'en';
    return DateFormat('h:mm a', locale).format(d);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localDay = day.isUtc ? day.toLocal() : day;
    final dayKey = DateTime(localDay.year, localDay.month, localDay.day);

    if (isLoading) {
      return _buildCard(
        theme,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dayTitle(theme, dayKey),
            const SizedBox(height: 16),
            Text(
              translation?.of('analytics.loading_schedule') ?? 'Loading schedule…',
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
      );
    }

    final blocks = data?.blocks ?? [];
    if (blocks.isEmpty) {
      return _buildCard(
        theme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dayTitle(theme, dayKey),
            const SizedBox(height: 12),
            Text(
              translation?.of('analytics.no_attendance_day') ?? 'No attendance this day',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final dayStart = DateTime(dayKey.year, dayKey.month, dayKey.day, 0, 0, 0, 0);

    return _buildCard(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _dayTitle(theme, dayKey),
          const SizedBox(height: 12),
          ...blocks.map((b) {
            final startTime = dayStart.add(Duration(seconds: b.startSeconds));
            final endTime = dayStart.add(Duration(seconds: b.startSeconds + b.durationSeconds));
            final timeRange = '${_formatTime(startTime)} – ${_formatTime(endTime)}';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ScheduleRow(
                theme: theme,
                timeRange: timeRange,
                label: b.label,
                detailText: b.detailText,
                isWork: b.isWork,
                isBreak: b.isBreak,
                isOt: b.isOt,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _dayTitle(ThemeData theme, DateTime dayKey) {
    return Text(
      AppDateTimeFormat.formatDate(dayKey),
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildCard(ThemeData theme, {required Widget child}) {
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
      child: child,
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.theme,
    required this.timeRange,
    required this.label,
    this.detailText,
    required this.isWork,
    required this.isBreak,
    required this.isOt,
  });

  final ThemeData theme;
  final String timeRange;
  final String label;
  final String? detailText;
  final bool isWork;
  final bool isBreak;
  final bool isOt;

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    if (isBreak) {
      chipColor = Colors.orange;
    } else if (isOt) {
      chipColor = theme.colorScheme.tertiary;
    } else {
      chipColor = theme.colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: chipColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                timeRange,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (detailText != null && detailText!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              detailText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
