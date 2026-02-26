

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
    this.isSelected = false,
    this.onTap,
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
  final bool isSelected;
  final VoidCallback? onTap;
  final ThemeData theme;

  static const double _gapLabelToBar = 6;
  static const double _gapBarToText = 8;
  static const double _gapBetweenTextLines = 4;
  static const double _gapBetweenSegments = 2;
  static const double _barRadius = 8;
  static const double _minBarHeight = 4;

  @override
  Widget build(BuildContext context) {
    final workH = d.workHours > 8 ? 8.0 : d.workHours;
    final hasAnyHours = d.workHours > 0 || d.breakHours > 0 || d.overtimeHours > 0;
    final trackColor = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          dayLabel,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: _gapLabelToBar),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              if (availableHeight <= 0) return const SizedBox.shrink();
              final totalHours = workH + d.breakHours + d.overtimeHours;
              // final numGaps = (d.overtimeHours > 0 ? 1 : 0) + (d.breakHours > 0 ? 1 : 0);
              // final gapTotal = numGaps * _gapBetweenSegments;
              // final availableForSegments = (availableHeight - gapTotal).clamp(0.0, availableHeight);
              // final scale = totalHours > 0
              //     ? availableForSegments / totalHours
              //     : 0.0;
              // final workHeight = (workH * scale).clamp(0.0, availableForSegments);
              // final breakHeight = (d.breakHours * scale).clamp(0.0, availableForSegments);
              // final otHeight = (d.overtimeHours * scale).clamp(0.0, availableForSegments);


      
              final scale = maxHours > 0
                  ? availableHeight / (totalHours > maxHours ? totalHours : maxHours)
                  : 0.0;
              final workHeight = (workH * scale).clamp(0.0, availableHeight);
              final breakHeight = (d.breakHours * scale).clamp(0.0, availableHeight);
              final otHeight = (d.overtimeHours * scale).clamp(0.0, availableHeight);
              final bar = Container(
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(_barRadius),
                  border: 
                  // isPartialLeave
                  //     ? Border.all(color: Colors.orange, width: .5)
                  //     :
                       isSelected
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: 0,
                            )
                          : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_barRadius ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (d.overtimeHours > 0) ...[
                        _seg(otHeight, availableHeight, overtimeColor, radiusTop: _barRadius, radiusBottom: 0),
                        // const SizedBox(height: _gapBetweenSegments),
                      ],
                      if (d.breakHours > 0) ...[
                        _seg(breakHeight, availableHeight, breakColor, radiusTop: 0, radiusBottom: 0),
                        // const SizedBox(height: _gapBetweenSegments),
                      ],
                      if (hasAnyHours)
                        _seg(workHeight, availableHeight, workColor, radiusTop: 0, radiusBottom: _barRadius)
                      else
                        _seg(_minBarHeight, availableHeight, workColor.withValues(alpha: 0.35), radiusTop: 0, radiusBottom: _barRadius),
                    ],
                  ),
                ),
              );
              if (onTap != null) {
                return Material(
                  color: Colors.transparent,

                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(_barRadius),
                    child: bar,
                  ),
                );
              }
              return bar;
            },
          ),
        ),
        const SizedBox(height: _gapBarToText),
        LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            if (maxW <= 0) return const SizedBox.shrink();
            return SizedBox(
              height: 40,
              width: maxW,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      d.workHours > 0 ? LocaleDigits.format('${d.workHours.toStringAsFixed(1)}${translation.of('analytics.h')}') : '—',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isPartialLeave ? Colors.orange : theme.colorScheme.primary,
                      ),
                    ),
                    if (d.breakHours > 0 ) ...[
                      const SizedBox(height: _gapBetweenTextLines),
                      Text(
                        LocaleDigits.format([
                          if (d.breakHours > 0) '${d.breakHours.toStringAsFixed(1)}${translation.of('analytics.h')} ${translation.of('analytics.brk')}',
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
                    if ( d.overtimeHours > 0 ) ...[
                      const SizedBox(height: _gapBetweenTextLines),
                      Text(
                        LocaleDigits.format([
                          if (d.overtimeHours > 0) '+${d.overtimeHours.toStringAsFixed(1)}${translation.of('analytics.h')} ${translation.of('analytics.ot')}',
                        ].join('  ')),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 7,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],if (d.shortHours > 0) ...[
                      const SizedBox(height: _gapBetweenTextLines),
                      Text(
                        LocaleDigits.format([
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
                ),
              ),
            );
          },
        ),
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
