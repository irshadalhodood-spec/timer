import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../attendance_module/domain/entities/attendance_entity.dart';
import '../../../../base_module/domain/entities/translation.dart';
import '../../../../base_module/presentation/core/values/app_constants.dart';
import '../../../../base_module/presentation/util/date_time_format.dart';
import '../../../../base_module/presentation/util/locale_digits.dart';

/// A calendar cell that shows a lightweight tooltip-style overlay on tap.
class DayCellWithTooltip extends StatefulWidget {
  const DayCellWithTooltip({
    required this.date,
    required this.dayRecords,
    required this.theme,
    required this.child,
    required this.workedSecondsForDay,
  });

  final DateTime date;
  final List<AttendanceEntity> dayRecords;
  final ThemeData theme;
  final Widget child;
  final int Function(AttendanceEntity) workedSecondsForDay;

  @override
  State<DayCellWithTooltip> createState() => DayCellWithTooltipState();
}

class DayCellWithTooltipState extends State<DayCellWithTooltip> {
  OverlayEntry? _overlay;
  final _link = LayerLink();

  void _show() {
    _remove();
    final totalWorked = widget.dayRecords.fold<int>(0, (s, a) => s + widget.workedSecondsForDay(a));
    final totalBreak = widget.dayRecords.fold<int>(0, (s, a) => s + a.breakSeconds);
    final workedH = totalWorked ~/ 3600;
    final workedM = (totalWorked % 3600) ~/ 60;
    final breakH = totalBreak ~/ 3600;
    final breakM = (totalBreak % 3600) ~/ 60;
    final otSeconds = (totalWorked - AppConstants.expectedWorkSecondsPerDay).clamp(0, 999999);
    final remainingSeconds = totalWorked < AppConstants.expectedWorkSecondsPerDay
        ? AppConstants.expectedWorkSecondsPerDay - totalWorked
        : 0;
    final otH = otSeconds ~/ 3600;
    final otM = (otSeconds % 3600) ~/ 60;
    final remainH = remainingSeconds ~/ 3600;
    final remainM = (remainingSeconds % 3600) ~/ 60;
    final theme = widget.theme;
    final cs = theme.colorScheme;

    _overlay = OverlayEntry(
      builder: (ctx) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _remove,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              offset: const Offset(0, -8),
              targetAnchor: Alignment.topCenter,
              followerAnchor: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 160, maxWidth: 210),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.outline.withValues(alpha: 0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: 0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppDateTimeFormat.formatDate(widget.date),
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _tipRow(theme, Icons.schedule_rounded,
                          translation.of('attendance.worked'),
                          LocaleDigits.format('${workedH}h ${workedM}m'), cs.primary),
                      const SizedBox(height: 6),
                      _tipRow(theme, Icons.free_breakfast_rounded,
                          translation.of('attendance.breaks'),
                          LocaleDigits.format(breakH > 0 ? '${breakH}h ${breakM}m' : '${breakM}m'),
                          cs.tertiary),
                      if (otSeconds > 0) ...[
                        const SizedBox(height: 6),
                        _tipRow(theme, Icons.more_time_outlined,
                            translation.of('analytics.ot'),
                            LocaleDigits.format('+${otH > 0 ? '${otH}h ' : ''}${otM}m'),
                            Colors.orange),
                      ],
                      if (remainingSeconds > 0) ...[
                        const SizedBox(height: 6),
                        _tipRow(theme, Icons.hourglass_bottom_rounded,
                            translation.of('analytics.short'),
                            LocaleDigits.format('-${remainH > 0 ? '${remainH}h ' : ''}${remainM}m'),
                            cs.error.withValues(alpha: 0.85)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _remove() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  void dispose() {
    _remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onTap: () => _overlay == null ? _show() : _remove(),
        child: widget.child,
      ),
    );
  }
}


Widget _tipRow(ThemeData theme, IconData icon, String label, String value, Color color) {
  return Row(
    children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      Text(
        value,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
      ),
    ],
  );
}
