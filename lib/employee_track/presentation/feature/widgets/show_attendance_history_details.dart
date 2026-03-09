import 'package:employee_track/base_module/domain/entities/translation.dart';
import 'package:employee_track/base_module/presentation/util/date_time_format.dart';
import 'package:employee_track/base_module/presentation/util/locale_digits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../attendance_module/domain/entities/attendance_entity.dart';
import '../../../../base_module/domain/entities/address_display.dart';
import '../../../../base_module/presentation/components/padding/app_padding.dart';
import '../../../domain/entities/break_record_entity.dart';
import '../../../domain/repositories/break_record_repository.dart';
import 'details_card.dart';

class ShowAttendanceHistoryDetails extends StatefulWidget {
  final DateTime date;
  final List<AttendanceEntity> dayRecords;

  const ShowAttendanceHistoryDetails({
    super.key,
    required this.date,
    required this.dayRecords,
  });

  @override
  State<ShowAttendanceHistoryDetails> createState() => _ShowAttendanceHistoryDetailsState();
}

class _ShowAttendanceHistoryDetailsState extends State<ShowAttendanceHistoryDetails> {
  late final Future<Map<String, List<BreakRecordEntity>>> _sessionBreaksFuture;

  @override
  void initState() {
    super.initState();
    final breakRepo = context.read<BreakRecordRepository>();
    _sessionBreaksFuture = _loadSessionBreaks(breakRepo);
  }

  Future<Map<String, List<BreakRecordEntity>>> _loadSessionBreaks(
    BreakRecordRepository breakRepo,
  ) async {
    final sessionBreaks = <String, List<BreakRecordEntity>>{};
    for (final a in widget.dayRecords) {
      sessionBreaks[a.id] = await breakRepo.getByAttendanceId(a.id);
    }
    return sessionBreaks;
  }

  static DateTime _checkInLocal(AttendanceEntity a) {
    return a.checkInAt.isUtc ? a.checkInAt.toLocal() : a.checkInAt;
  }

  static DateTime _effectiveCheckOut(AttendanceEntity a, {DateTime? now}) {
    if (a.checkOutAt != null) {
      return a.checkOutAt!.isUtc ? a.checkOutAt!.toLocal() : a.checkOutAt!;
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();
    final dayRecords = widget.dayRecords;
    final date = widget.date;
    var totalWorked = 0;
    var totalBreak = 0;
    for (final a in dayRecords) {
      totalWorked += _workedSecondsForDay(a, date, now: now);
      totalBreak += a.breakSeconds;
    }
    final workedH = totalWorked ~/ 3600;
    final workedM = (totalWorked % 3600) ~/ 60;
    final breakM = totalBreak ~/ 60;
    final totalWorkedHours = totalWorked / 3600.0;
    final dayOtHours = totalWorkedHours > 8 ? totalWorkedHours - 8 : 0.0;
    final dayShortHours = totalWorkedHours > 0 && totalWorkedHours < 8
        ? 8 - totalWorkedHours
        : 0.0;
    final isPresent = dayRecords.isNotEmpty;
    final daySessions = List<AttendanceEntity>.from(dayRecords)
      ..sort((a, b) => a.checkInAt.compareTo(b.checkInAt));
    final isPartialLeave =
        daySessions.isNotEmpty &&
        daySessions.last.checkOutAt != null &&
        daySessions.last.isEarlyCheckout;
    final earlyCheckoutNote = dayRecords
        .where(
          (a) => a.earlyCheckoutNote != null && a.earlyCheckoutNote!.isNotEmpty,
        )
        .map((a) => a.earlyCheckoutNote!)
        .firstOrNull;
    return FutureBuilder<Map<String, List<BreakRecordEntity>>>(
      future: _sessionBreaksFuture,
      builder: (context, snapshot) {
        final sessionBreaks = snapshot.data ?? {};
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.08),
              ),
              left: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.08),
              ),
              right: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.08),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 14),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  children: [
                    Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppDateTimeFormat.formatWeekday(date),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                AppDateTimeFormat.formatDate(date),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),

                            ],
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isPartialLeave) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  translation.of('dashboard.partial_leave'),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                            ],

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6
                              ),
                              decoration: BoxDecoration(
                                color: isPresent
                                    ? colorScheme.surface
                                    : colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isPresent
                                      ? colorScheme.primary.withValues(
                                          alpha: 0.3)
                                      : colorScheme.error.withValues(
                                          alpha: 0.3),
                                  width: 1
                                ),
                              ),
                              child: Text(
                                isPresent
                                    ? translation.of('dashboard.attendant')
                                    : translation.of('dashboard.absent'),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isPresent
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onErrorContainer
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),

                    if (earlyCheckoutNote != null &&
                        earlyCheckoutNote.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: Colors.orange.shade700
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translation.of(
                                      'dashboard.early_checkout_reason'
                                    ),

                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange.shade800,
                                        ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    earlyCheckoutNote,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (dayRecords.isNotEmpty &&
                        (totalWorked > 0 || totalBreak > 0)) ...[

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.6,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                          ),
                        ),

                        child: Wrap(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  translation.of('attendance.worked'),
                                  style: theme.textTheme.labelMedium
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  LocaleDigits.format('$workedH${translation.of('analytics.h')} $workedM${translation.of('analytics.mi')}'),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),

                            AppPadding(multipliedBy: 0.5),
                           
                            Container(
                              width: 1,
                              height: 24,
                              color: colorScheme.outline
                            ),

                            AppPadding(multipliedBy: 0.5),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.free_breakfast_rounded,
                                  size: 20,
                                  color: colorScheme.tertiary
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  translation.of('attendance.breaks'),
                                  style: theme.textTheme.labelMedium
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant
                                      ),
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  LocaleDigits.format('$breakM ${translation.of('analytics.min')}'),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface
                                  ),
                                ),

                              ],
                            ),

                             if (dayOtHours > 0)
                             Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Icon(
                                   Icons.more_time_outlined,
                                   size: 20,
                                   color: Colors.orange,
                                 ),

                                 const SizedBox(width: 10),

                                 Text(
                                   translation.of('analytics.ot'),
                                   style: theme.textTheme.labelMedium
                                       ?.copyWith(
                                         color: colorScheme.onSurfaceVariant
                                       ),
                                 ),

                                 const SizedBox(width: 6),
                                 
                                 Text(
                                   LocaleDigits.format(
                                     '+${dayOtHours.toStringAsFixed(1)} ${translation.of('analytics.h')}',
                                   ),
                                   style: theme.textTheme.titleSmall?.copyWith(
                                     fontWeight: FontWeight.w700,
                                     color: colorScheme.onSurface
                                   ),
                                 ),

                               ],
                             ),

                            if (dayShortHours > 0) ...[
                              
                              AppPadding(multipliedBy: 0.5),
                              
                              Container(
                                width: 1,
                                height: 24,
                                color: colorScheme.outline),

                              AppPadding(multipliedBy: 0.5),
                              
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.timer_off_outlined,
                                    size: 20,
                                    color: Colors.orange
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    translation.of('analytics.st'),
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant
                                        ),
                                  ),
                                  
                                  const SizedBox(width: 6),

                                  Text(
                                    LocaleDigits.format(
                                      '-${dayShortHours.toStringAsFixed(1)} ${translation.of('analytics.h')}',
                                    ),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),

                                ],
                              ),

                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  children: [
                    ...dayRecords.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final a = entry.value;
                      final worked = _workedSecondsForDay(a, date, now: now);
                      final h = worked ~/ 3600;
                      final m = (worked % 3600) ~/ 60;
                      final bM = a.breakSeconds ~/ 60;
                      final showSessionLabel = dayRecords.length > 1;
                      final hasCheckOut = a.checkOutAt != null;
                      final breaks = (sessionBreaks[a.id] ?? [])..sort((x, y) => x.startAt.compareTo(y.startAt));
                      final workedHours = worked / 3600.0;
                      final otHours = workedHours > 8 ? workedHours - 8 : 0.0;
                      final shortHours = workedHours > 0 && workedHours < 8 ? 8 - workedHours : 0.0;
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 16,
                          top: idx > 0 ? 16 : 0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow.withValues(
                              alpha: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showSessionLabel) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer
                                        .withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    LocaleDigits.format('${translation.of('analytics.sessions')} ${idx + 1}'),
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                              ],
                              DetailRow(
                                icon: Icons.login_rounded,
                                label: translation.of('attendance.check_in_at'),
                                value: AppDateTimeFormat.formatTime(a.checkInAt),
                                subtitle: AddressDisplay.getDisplay(a.checkInAddress),
                              ),
                              ...breaks.expand((b) => [
                                const SizedBox(height: 10),
                                DetailRow(
                                  icon: Icons.free_breakfast_rounded,
                                  label: translation.of('dashboard.break_start'),
                                  value: AppDateTimeFormat.formatTime(b.startAt),
                                  subtitle: AddressDisplay.getDisplay(b.startAddress),
                                ),
                                const SizedBox(height: 10),
                                DetailRow(
                                  icon: Icons.coffee_rounded,
                                  label: translation.of('dashboard.break_end'),
                                  value: b.endAt != null
                                      ? AppDateTimeFormat.formatTime(b.endAt!)
                                      : '—',
                                  subtitle: AddressDisplay.getDisplay(b.endAddress),
                                  valueMuted: b.endAt == null,
                                ),
                              ]),
                              const SizedBox(height: 10),
                              DetailRow(
                                icon: Icons.free_breakfast_rounded,
                                label: translation.of('attendance.breaks'),
                                value: LocaleDigits.format(bM > 0
                                    ? '$bM ${translation.of('analytics.min')}'
                                    : '0 ${translation.of('analytics.min')}'),
                              ),
                              const SizedBox(height: 10),
                              DetailRow(
                                icon: Icons.logout_rounded,
                                label: translation.of(
                                  'attendance.check_out_at',
                                ),
                                value: hasCheckOut
                                    ? AppDateTimeFormat.formatTime(a.checkOutAt!)
                                    : '—',
                                subtitle: hasCheckOut
                                    ? (a.isAutoCheckout
                                        ? translation.of('dashboard.auto_closed_at_eod')
                                        : AddressDisplay.getDisplay(a.checkOutAddress))
                                    : null,
                                valueMuted: !hasCheckOut,
                              ),
                              const SizedBox(height: 10),
                              DetailRow(
                                icon: Icons.schedule_rounded,
                                label: translation.of('attendance.worked'),
                                value: LocaleDigits.format('$h ${translation.of('analytics.h')}  $m ${translation.of('analytics.mi')}'),
                              ),
                              if (otHours > 0) ...[
                                const SizedBox(height: 10),
                                DetailRow(
                                  icon: Icons.add_circle_outline_rounded,
                                  label: translation.of('analytics.ot'),
                                  value: LocaleDigits.format('+${otHours.toStringAsFixed(1)} ${translation.of('analytics.h')}'),
                                ),
                              ],
                              if (shortHours > 0) ...[
                                const SizedBox(height: 10),
                                DetailRow(
                                  icon: Icons.remove_circle_outline_rounded,
                                  label: translation.of('analytics.st'),
                                  value: LocaleDigits.format('-${shortHours.toStringAsFixed(1)} ${translation.of('analytics.h')}'),
                                  valueMuted: true,
                                ),
                              ],
                              if (a.earlyCheckoutNote != null &&
                                  a.earlyCheckoutNote!.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.orange.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline_rounded,
                                            size: 18,
                                            color: Colors.orange.shade700,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            translation.of(
                                              'dashboard.early_checkout_reason',
                                            ),
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.orange.shade800,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        a.earlyCheckoutNote!,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: colorScheme.onSurface,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (a.deviceInfo != null &&
                                  a.deviceInfo!.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                DetailRow(
                                  icon: Icons.phone_android_rounded,
                                  label: translation.of('analytics.device'),
                                  value: a.deviceInfo!,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                    if (dayRecords.length > 1) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(
                            alpha: 0.4,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            DetailRow(
                              icon: Icons.today_rounded,
                              label: translation.of('attendance.worked'),
                              value:
                                  LocaleDigits.format('$workedH${translation.of('analytics.h')} $workedM${translation.of('analytics.mi')}'),
                              compact: true,
                            ),
                            const SizedBox(height: 8),
                            DetailRow(
                              icon: Icons.free_breakfast_rounded,
                              label: translation.of('attendance.breaks'),
                              value:
                                  LocaleDigits.format('$breakM ${translation.of('analytics.min')}'),
                              compact: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        );
    },
    );
  }
}