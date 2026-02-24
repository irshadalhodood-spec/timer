import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../base_module/presentation/feature/live_time/live_time_cubit.dart';
import '../../../../base_module/presentation/util/locale_digits.dart';

class LiveTimerText extends StatelessWidget {
  const LiveTimerText({super.key,
    required this.checkInAt,
    required this.breakSeconds,
  });

  final DateTime checkInAt;
  final int breakSeconds;

  static String _formatDuration(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    final str = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return LocaleDigits.format(str);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveTimeCubit, DateTime>(
      buildWhen: (prev, next) => prev.second != next.second || prev.minute != next.minute || prev.hour != next.hour,
      builder: (context, now) {
        final sec = now.difference(checkInAt).inSeconds - breakSeconds;
        final elapsed = sec.clamp(0, 999999);
        return Text(
          _formatDuration(elapsed),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        );
      },
    );
  }
}
