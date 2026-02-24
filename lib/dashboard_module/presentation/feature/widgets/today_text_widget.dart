
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../base_module/domain/entities/translation.dart';
import '../../../../base_module/presentation/feature/live_time/live_time_cubit.dart';
import '../../../../base_module/presentation/util/locale_digits.dart';
import '../../../domain/attendance_bloc.dart';

class TodayTotalText extends StatelessWidget {
  const TodayTotalText({super.key, required this.state});

  final AttendanceStateCheckedIn state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveTimeCubit, DateTime>(
      buildWhen: (prev, next) =>
          prev.second != next.second || prev.minute != next.minute || prev.hour != next.hour,
      builder: (context, now) {
        int total = 0;
        for (final session in state.todaySessions) {
          if (session.id == state.attendance.id) {
            total += (now.difference(session.checkInAt).inSeconds - state.breakSeconds).clamp(0, 999999);
          } else if (session.checkOutAt != null) {
            total += (session.checkOutAt!.difference(session.checkInAt).inSeconds - session.breakSeconds).clamp(0, 999999);
          }
        }
        final h = total ~/ 3600;
        final m = (total % 3600) ~/ 60;
        return LocaleDigitsText(
          '${translation.of('dashboard.today_total')} $h${translation.of('analytics.h')} $m${translation.of('analytics.mi')}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}
