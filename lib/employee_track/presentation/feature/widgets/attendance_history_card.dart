import 'package:flutter/material.dart';

import '../../../../attendance_module/domain/entities/attendance_entity.dart';
import '../../../../base_module/domain/entities/translation.dart';
import '../../../../base_module/presentation/util/date_time_format.dart';
import '../../../../base_module/presentation/util/locale_digits.dart';
import 'mini_chip.dart';

class AttendanceHistoryCard extends StatelessWidget {
  const AttendanceHistoryCard({super.key, 
    required this.date,
    required this.dayRecords,
    required this.onTap,
    this.isPartialLeave = false,
    this.earlyCheckoutNote,
    this.now,
  });
  final DateTime date;
  final List<AttendanceEntity> dayRecords;
  final VoidCallback onTap;
  final bool isPartialLeave;
  final String? earlyCheckoutNote;
  final DateTime? now;

  static int _workedSecondsForDay(AttendanceEntity a, DateTime dateLocal, {DateTime? now}) {
    final checkInLocal = a.checkInAt.isUtc ? a.checkInAt.toLocal() : a.checkInAt;
    final startOfDay = DateTime(dateLocal.year, dateLocal.month, dateLocal.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final endAt = a.checkOutAt != null
        ? (a.checkOutAt!.isUtc ? a.checkOutAt!.toLocal() : a.checkOutAt!)
        : (now != null ? (now.isBefore(endOfDay) ? now : endOfDay) : endOfDay);
    final endAtCapped = endAt.isAfter(endOfDay) ? endOfDay : endAt;
    final effectiveStart = checkInLocal.isBefore(startOfDay) ? startOfDay : checkInLocal;
    if (!endAtCapped.isAfter(effectiveStart)) return 0;
    final seconds = endAtCapped.difference(effectiveStart).inSeconds - a.breakSeconds;
    return seconds.clamp(0, 86400 * 2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var totalWorked = 0;
    var totalBreak = 0;
    AttendanceEntity? firstRecord;
    for (final a in dayRecords) {
      if (firstRecord == null || a.checkInAt.isBefore(firstRecord.checkInAt)) {
        firstRecord = a;
      }
      totalWorked += _workedSecondsForDay(a, date, now: now);
      totalBreak += a.breakSeconds;
    }
    final h = totalWorked ~/ 3600;
    final m = (totalWorked % 3600) ~/ 60;
    final breakM = totalBreak ~/ 60;
    final isPresent = dayRecords.any((a) => a.checkOutAt != null);
    final checkInTime = firstRecord != null
        ? AppDateTimeFormat.formatTime(firstRecord.checkInAt)
        : '—';

    return Material(
      color: theme.colorScheme.surfaceContainerLow.withValues(alpha:0.5),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: isPartialLeave
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: const Border(
                    left: BorderSide(color: Colors.orange, width: 4),
                  ),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isPartialLeave
                        ? Colors.orange.withValues(alpha:0.2)
                        : isPresent
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.errorContainer.withValues(alpha:0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isPartialLeave
                        ? Icons.schedule_rounded
                        : isPresent
                        ? Icons.check_circle_rounded
                        : Icons.schedule_rounded,
                    color: isPartialLeave
                        ? Colors.orange
                        : isPresent
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onErrorContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppDateTimeFormat.formatDate(date),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        checkInTime,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (dayRecords.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            LocaleDigits.format('${dayRecords.length} ${translation.of('analytics.sessions')}'),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      if (isPartialLeave)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            translation.of('dashboard.partial_leave'),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (earlyCheckoutNote != null &&
                          earlyCheckoutNote!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            earlyCheckoutNote!.length > 60
                                ? '${earlyCheckoutNote!.substring(0, 60)}…'
                                : earlyCheckoutNote!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          MiniChip(
                            theme: theme,
                            icon: Icons.schedule_rounded,
                            text: LocaleDigits.format('$h${translation.of('analytics.h')} $m${translation.of('analytics.mi')}'),
                          ),
                          if (breakM > 0) ...[
                            const SizedBox(width: 8),
                            MiniChip(
                              theme: theme,
                              icon: Icons.free_breakfast_rounded,
                              text: LocaleDigits.format('$breakM${translation.of('analytics.mi')} ${translation.of('analytics.break')}'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.outline,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

