

import 'package:flutter/material.dart';

import '../../../../base_module/domain/entities/translation.dart';
import '../../../../base_module/presentation/util/locale_digits.dart';
import '../models/day_models.dart';

class DayBar extends StatelessWidget {
  const DayBar({super.key, 
    required this.dayLabel,
    required this.d,
    required this.maxHours,
    required this.barHeight,
    required this.workColor,
    required this.breakColor,
    required this.overtimeColor,
    required this.shortColor,
    this.isPartialLeave = false,
    required this.theme,
  });

  final String dayLabel;
  final DayHours d;
  final double maxHours;
  final double barHeight;
  final Color workColor;
  final Color breakColor;
  final Color overtimeColor;
  final Color shortColor;
  final bool isPartialLeave;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final workH = d.workHours > 8 ? 8.0 : d.workHours;
    final hasAnyHours = d.workHours > 0 || d.breakHours > 0 || d.overtimeHours > 0;
    const minBarHeight = 4.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          dayLabel,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              if (availableHeight <= 0) return const SizedBox.shrink();
              final totalHours = workH + d.breakHours + d.overtimeHours;
              // Scale by maxHours so bar fill is comparable across days (e.g. 8h = full when maxHours=8).
              // If totalHours > maxHours, cap scale so segments don't overflow.
              final scale = maxHours > 0
                  ? availableHeight / (totalHours > maxHours ? totalHours : maxHours)
                  : 0.0;
              final workHeight = (workH * scale).clamp(0.0, availableHeight);
              final breakHeight = (d.breakHours * scale).clamp(0.0, availableHeight);
              final otHeight = (d.overtimeHours * scale).clamp(0.0, availableHeight);
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: isPartialLeave
                      ? Border.all(color: Colors.orange, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (d.overtimeHours > 0)
                      _seg(otHeight, availableHeight, overtimeColor, radiusTop: 8, radiusBottom: 0),
                    if (d.breakHours > 0)
                      _seg(breakHeight, availableHeight, breakColor, radiusTop: 0, radiusBottom: 0),
                    if (hasAnyHours)
                      _seg(workHeight, availableHeight, workColor, radiusTop: 0, radiusBottom: 8)
                    else
                      _seg(minBarHeight, availableHeight, workColor.withValues(alpha: 0.25), radiusTop: 0, radiusBottom: 8),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(
          d.workHours > 0 ? LocaleDigits.format('${d.workHours.toStringAsFixed(1)}${translation.of('analytics.h')}') : '—',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: isPartialLeave ? Colors.orange : theme.colorScheme.primary,
          ),
        ),
        if (d.breakHours > 0 || d.overtimeHours > 0 || d.shortHours > 0) ...[
          const SizedBox(height: 2),
          Text(
            LocaleDigits.format([
              if (d.breakHours > 0) '${d.breakHours.toStringAsFixed(1)}${translation.of('analytics.h')} ${translation.of('analytics.brk')}',
              if (d.overtimeHours > 0) '+${d.overtimeHours.toStringAsFixed(1)}${translation.of('analytics.h')} ${translation.of('analytics.ot')}',
              if (d.shortHours > 0) '-${d.shortHours.toStringAsFixed(1)}${translation.of('analytics.h')} ${translation.of('analytics.st')}',
            ].join('  ')),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 7,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _seg(double h, double maxH, Color color, {double radiusTop = 0, double radiusBottom = 0}) {
    if (h <= 0) return const SizedBox.shrink();
    final height = h.clamp(2.0, maxH);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radiusTop),
          bottom: Radius.circular(radiusBottom),
        ),
      ),
    );
  }
}
