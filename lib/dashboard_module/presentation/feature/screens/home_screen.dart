import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../base_module/data/services/attendance_notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../base_module/data/services/geo_service.dart';
import '../../../../base_module/domain/entities/address_display.dart';
import '../../../../base_module/domain/entities/translation.dart';
import '../../../../base_module/presentation/util/date_time_format.dart';
import '../../../../base_module/presentation/util/locale_digits.dart';
import '../../../../base_module/presentation/components/custom_button/button.dart';
import '../../../../base_module/presentation/core/values/app_constants.dart';
import '../../../domain/attendance_bloc.dart';
import '../../../data/models/timeline_event.dart';
import '../widgets/live_daily_summary.dart';
import '../widgets/live_timer_text.dart';
import '../widgets/progress_bar.dart';
import '../widgets/today_text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSubmittingLocation = false;
  Timer? _notificationUpdateTimer;

  @override
  void initState() {
    super.initState();
    AttendanceNotificationService.onNotificationAction = _handleNotificationAction;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AttendanceBloc>().add(const AttendanceLoadRequested());
      }
    });
  }

  @override
  void dispose() {
    AttendanceNotificationService.onNotificationAction = null;
    _notificationUpdateTimer?.cancel();
    _notificationUpdateTimer = null;
    try {
      context.read<AttendanceNotificationService>().clearAttendanceNotification();
    } catch (_) {}
    super.dispose();
  }

  void _handleNotificationAction(String action) {
    if (!mounted) return;
    switch (action) {
      case 'checkOut':
        _fetchGeoAndCheckOut(context);
        break;
      case 'startBreak':
        context.read<AttendanceBloc>().add(const AttendanceBreakStartRequested());
        break;
      case 'endBreak':
        context.read<AttendanceBloc>().add(const AttendanceBreakEndRequested());
        break;
    }
  }

  void _updateAttendanceNotification(AttendanceStateCheckedIn state) {
    final now = DateTime.now();
    int workedSeconds = 0;
    for (final session in state.todaySessions) {
      if (session.id == state.attendance.id) {
        workedSeconds += (now.difference(session.checkInAt).inSeconds - state.breakSeconds).clamp(0, 999999);
      } else if (session.checkOutAt != null) {
        workedSeconds += (session.checkOutAt!.difference(session.checkInAt).inSeconds - session.breakSeconds).clamp(0, 999999);
      }
    }
    final isOnBreak = state.breaks.any((b) => b.endAt == null);
    context.read<AttendanceNotificationService>().showAttendanceNotification(
      checkInAtIso: state.attendance.checkInAt.toIso8601String(),
      breakSeconds: state.breakSeconds,
      workedSeconds: workedSeconds,
      isOnBreak: isOnBreak,
      expectedWorkSeconds: AppConstants.expectedWorkSecondsPerDay,
    );
  }

  void _startNotificationTimer() {
    _notificationUpdateTimer?.cancel();
    _notificationUpdateTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (!mounted) return;
      final state = context.read<AttendanceBloc>().state;
      AttendanceStateCheckedIn? checkedIn;
      if (state is AttendanceStateCheckedIn) {
        checkedIn = state;
      } else if (state is AttendanceStateHistoryLoaded && state.todayAttendance != null) {
        checkedIn = AttendanceStateCheckedIn(
          state.todayAttendance!,
          state.todayBreaks,
          state.todayBreakSeconds,
          state.todaySessions,
        );
      } else if (state is AttendanceStateHistoryLoading && state.todayAttendance != null) {
        checkedIn = AttendanceStateCheckedIn(
          state.todayAttendance!,
          state.todayBreaks,
          state.todayBreakSeconds,
          state.todaySessions,
        );
      }
      if (checkedIn != null) _updateAttendanceNotification(checkedIn);
    });
  }

  void _cancelNotificationTimer() {
    _notificationUpdateTimer?.cancel();
    _notificationUpdateTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceStateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        final checkedInState = _resolveCheckedInState(state);
        if (checkedInState != null) {
          _updateAttendanceNotification(checkedInState);
          _startNotificationTimer();
        } else {
          _cancelNotificationTimer();
          context.read<AttendanceNotificationService>().clearAttendanceNotification();
        }
      },
      builder: (context, state) {
        AttendanceStateCheckedIn? checkedInState;
        if (state is AttendanceStateCheckedIn) {
          checkedInState = state;
        } else if (state is AttendanceStateHistoryLoaded && state.todayAttendance != null) {
          checkedInState = AttendanceStateCheckedIn(
            state.todayAttendance!,
            state.todayBreaks,
            state.todayBreakSeconds,
            state.todaySessions,
          );
        } else if (state is AttendanceStateHistoryLoading && state.todayAttendance != null) {
          checkedInState = AttendanceStateCheckedIn(
            state.todayAttendance!,
            state.todayBreaks,
            state.todayBreakSeconds,
            state.todaySessions,
          );
        }
        final isCheckedIn = checkedInState != null;

        if (state is AttendanceStateFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    onTap: () => context.read<AttendanceBloc>().add(const AttendanceLoadRequested()),
                    text: translation.of('retry'),
                    bgColor: Colors.green,
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLiveTimer(context, checkedInState),
              const SizedBox(height: 24),
              _buildPrimaryActions(context, isCheckedIn),
              if (isCheckedIn) ...[
                const SizedBox(height: 16),
                _buildSecondaryActions(context, checkedInState),
              ],
              const SizedBox(height: 24),
              _buildDailySummary(context, checkedInState, state is AttendanceStateCheckedOut ? state : null),
              const SizedBox(height: 24),
              _buildActivityTimeline(context, checkedInState, state is AttendanceStateCheckedOut ? state : null),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiveTimer(BuildContext context, AttendanceStateCheckedIn? state) {
    final displayAddress = state != null ? AddressDisplay.getDisplay(state.attendance.checkInAddress) : null;
    final locationText = state != null
        ? (displayAddress?.isNotEmpty == true
            ? displayAddress!
            : (state.attendance.checkInLat != null && state.attendance.checkInLng != null
                ? LocaleDigits.format('${state.attendance.checkInLat!.toStringAsFixed(5)}, ${state.attendance.checkInLng!.toStringAsFixed(5)}')
                : null))
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center
        ,
        children: [
          if (locationText != null) ...[
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    locationText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Text(
            translation.of('dashboard.live_work_timer'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          state != null
              ? LiveTimerText(
                  checkInAt: state.attendance.checkInAt,
                  breakSeconds: state.breakSeconds,
                )
              : Text(
                  '00:00:00',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
          const SizedBox(height: 8),
          Text(
            state != null
                ? '${translation.of('dashboard.started_at')} ${AppDateTimeFormat.formatTime(state.attendance.checkInAt)}'
                : translation.of('dashboard.check_in_to_start'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          if (state != null && state.todaySessions.length > 1) ...[
            const SizedBox(height: 8),
            TodayTotalText(state: state),
          ],
        ],
      ),
    );
  }

  Future<void> _fetchGeoAndCheckIn(BuildContext context) async {
    if (_isSubmittingLocation) return;
    setState(() => _isSubmittingLocation = true);
    try {
      final geo = await context.read<GeoService>().getCurrentLocationWithAddress();
      if (!mounted) return;
      context.read<AttendanceBloc>().add(AttendanceCheckInRequested(
            lat: geo?.latitude,
            lng: geo?.longitude,
            address: geo?.address,
            deviceInfo: null,
          ));
    } finally {
      if (mounted) setState(() => _isSubmittingLocation = false);
    }
  }

  AttendanceStateCheckedIn? _resolveCheckedInState(AttendanceState state) {
    if (state is AttendanceStateCheckedIn) return state;
    if (state is AttendanceStateHistoryLoaded && state.todayAttendance != null) {
      return AttendanceStateCheckedIn(
        state.todayAttendance!,
        state.todayBreaks,
        state.todayBreakSeconds,
        state.todaySessions,
      );
    }
    if (state is AttendanceStateHistoryLoading && state.todayAttendance != null) {
      return AttendanceStateCheckedIn(
        state.todayAttendance!,
        state.todayBreaks,
        state.todayBreakSeconds,
        state.todaySessions,
      );
    }
    return null;
  }

  Future<void> _fetchGeoAndCheckOut(BuildContext context) async {
    if (_isSubmittingLocation) return;
    final bloc = context.read<AttendanceBloc>();
    final checkedInState = _resolveCheckedInState(bloc.state);
    if (checkedInState == null) return;
    final now = DateTime.now();
    final workedSeconds = now.difference(checkedInState.attendance.checkInAt).inSeconds - checkedInState.breakSeconds;
    final isEarlyCheckout = workedSeconds < AppConstants.expectedWorkSecondsPerDay;

    if (isEarlyCheckout) {
      final note = await _showWhyCheckoutDialog(context);
      if (!mounted) return;
      if (note == null) return; 
      setState(() => _isSubmittingLocation = true);
      try {
        final geo = await context.read<GeoService>().getCurrentLocationWithAddress();
        if (!mounted) return;
        bloc.add(AttendanceCheckOutRequested(
              lat: geo?.latitude,
              lng: geo?.longitude,
              address: geo?.address,
              earlyCheckoutNote: note.isEmpty ? null : note,
              isEarlyCheckout: true,
            ));
      } finally {
        if (mounted) setState(() => _isSubmittingLocation = false);
      }
      return;
    }

    setState(() => _isSubmittingLocation = true);
    try {
      final geo = await context.read<GeoService>().getCurrentLocationWithAddress();
      if (!mounted) return;
      bloc.add(AttendanceCheckOutRequested(
            lat: geo?.latitude,
            lng: geo?.longitude,
            address: geo?.address,
          ));
    } finally {
      if (mounted) setState(() => _isSubmittingLocation = false);
    }
  }

 
  Future<String?> _showWhyCheckoutDialog(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(translation.of('dashboard.why_checkout')),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: translation.of('dashboard.early_checkout_reason_hint'),
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text(translation.of('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text(translation.of('dashboard.submit')),
          ),
        ],
      ),
    );
    return result;
  }

  Widget _buildPrimaryActions(BuildContext context, bool isCheckedIn) {
    if (isCheckedIn) {
      return PrimaryButton(
        isLoading: 
          _isSubmittingLocation,
        onTap: _isSubmittingLocation ? () {} : () => _fetchGeoAndCheckOut(context),
        text:  translation.of('dashboard.check_out'),
        bgColor: Theme.of(context).colorScheme.error,
      );
    }
    return PrimaryButton(
      isLoading: 
          _isSubmittingLocation,
      onTap: _isSubmittingLocation ? () {} : () => _fetchGeoAndCheckIn(context),
      text:   translation.of('dashboard.check_in'),
      bgColor: Colors.green,
    );
  }


  Widget _buildSecondaryActions(BuildContext context, AttendanceStateCheckedIn state) {
    final hasActiveBreak = state.breaks.any((b) => b.endAt == null);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: hasActiveBreak
                ? null
                : () => context.read<AttendanceBloc>().add(AttendanceBreakStartRequested()),
            child: Text(translation.of('dashboard.start_break')),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: hasActiveBreak
                ? () => context.read<AttendanceBloc>().add(AttendanceBreakEndRequested())
                : null,
            child: Text(translation.of('dashboard.end_break')),
          ),
        ),
      ],
    );
  }

  Widget _buildDailySummary(
    BuildContext context,
    AttendanceStateCheckedIn? checkedInState,
    AttendanceStateCheckedOut? checkedOutState,
  ) {
    int? todayWorked;
    int? todayBreak;
    if (checkedInState != null && checkedInState.todaySessions.isNotEmpty) {
      todayWorked = 0;
      todayBreak = 0;
      final now = DateTime.now();
      for (final session in checkedInState.todaySessions) {
        if (session.id == checkedInState.attendance.id) {
          final elapsed = now.difference(session.checkInAt).inSeconds;
          todayWorked = (todayWorked! + elapsed - checkedInState.breakSeconds).clamp(0, 999999);
          todayBreak = todayBreak! + checkedInState.breakSeconds;
        } else if (session.checkOutAt != null) {
          final sessionWorked = session.checkOutAt!.difference(session.checkInAt).inSeconds - session.breakSeconds;
          todayWorked = todayWorked! + sessionWorked.clamp(0, 999999);
          todayBreak = todayBreak! + session.breakSeconds;
        }
      }
    } else if (checkedOutState != null && checkedOutState.todaySessions.isNotEmpty) {
      todayWorked = 0;
      todayBreak = 0;
      for (final session in checkedOutState.todaySessions) {
        if (session.checkOutAt != null) {
          final sessionWorked = session.checkOutAt!.difference(session.checkInAt).inSeconds - session.breakSeconds;
          todayWorked = todayWorked! + sessionWorked.clamp(0, 999999);
          todayBreak = todayBreak! + session.breakSeconds;
        }
      }
    }
    final showCheckedOutToday = checkedOutState != null && checkedOutState.todaySessions.isNotEmpty;
    final showNotCheckedIn = checkedInState == null && !showCheckedOutToday;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation.of('dashboard.daily_hours_summary'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        if (showNotCheckedIn)
          _buildDailySummaryNotCheckedIn(context)
        else if (checkedInState != null)
          LiveDailySummary(
            checkInAt: checkedInState.attendance.checkInAt,
            breaks: checkedInState.breaks,
            todayWorkedSeconds: todayWorked,
            todayBreakSeconds: todayBreak,
            todaySessions: checkedInState.todaySessions.isNotEmpty ? checkedInState.todaySessions : null,
            currentAttendanceId: checkedInState.attendance.id,
            currentBreakSeconds: checkedInState.breakSeconds,
          )
        else
          LiveDailySummary(
            checkInAt: checkedOutState!.todaySessions.first.checkInAt,
            breaks: const [],
            todayWorkedSeconds: todayWorked,
            todayBreakSeconds: todayBreak,
          ),
      ],
    );
  }

  Widget _buildDailySummaryNotCheckedIn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LocaleDigitsText(
          '${translation.of('dashboard.today')}: 0${translation.of('analytics.h')} 0${translation.of('analytics.mi')}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        NineHourProgressBar(workedSeconds: 0, breakSeconds: 0),
      ],
    );
  }

  Widget _buildActivityTimeline(
    BuildContext context,
    AttendanceStateCheckedIn? state,
    AttendanceStateCheckedOut? checkedOutState,
  ) {
    final events = <TimelineEvent>[];
    if (state != null) {
      final sessions = state.todaySessions.isNotEmpty ? state.todaySessions : [state.attendance];
      for (final session in sessions) {
        final isCurrentSession = session.id == state.attendance.id;
        final sessionCheckInDisplay = AddressDisplay.getDisplay(session.checkInAddress) ?? translation.of('dashboard.geo_tagged');
        events.add(TimelineEvent(
          type: TimelineEventType.checkIn,
          time: session.checkInAt,
          location: sessionCheckInDisplay,
        ));
        if (isCurrentSession) {
          for (final b in state.breaks) {
            events.add(TimelineEvent(
              type: TimelineEventType.breakStart,
              time: b.startAt,
              location: AddressDisplay.getDisplay(b.startAddress) ?? sessionCheckInDisplay,
            ));
            if (b.endAt != null) {
              events.add(TimelineEvent(
                type: TimelineEventType.breakEnd,
                time: b.endAt!,
                location: AddressDisplay.getDisplay(b.endAddress) ?? sessionCheckInDisplay,
              ));
            }
          }
        }
        if (session.checkOutAt != null) {
          events.add(TimelineEvent(
            type: TimelineEventType.checkOut,
            time: session.checkOutAt!,
            location: AddressDisplay.getDisplay(session.checkOutAddress) ?? translation.of('dashboard.geo_tagged'),
          ));
        }
      }
      events.sort((a, b) => a.time.compareTo(b.time));
    } else if (checkedOutState != null && checkedOutState.todaySessions.isNotEmpty) {
      for (final session in checkedOutState.todaySessions) {
        final sessionCheckInDisplay = AddressDisplay.getDisplay(session.checkInAddress) ?? translation.of('dashboard.geo_tagged');
        events.add(TimelineEvent(
          type: TimelineEventType.checkIn,
          time: session.checkInAt,
          location: sessionCheckInDisplay,
        ));
        final breaks = checkedOutState.todaySessionBreaks[session.id] ?? [];
        for (final b in breaks) {
          events.add(TimelineEvent(
            type: TimelineEventType.breakStart,
            time: b.startAt,
            location: AddressDisplay.getDisplay(b.startAddress) ?? sessionCheckInDisplay,
          ));
          if (b.endAt != null) {
            events.add(TimelineEvent(
              type: TimelineEventType.breakEnd,
              time: b.endAt!,
              location: AddressDisplay.getDisplay(b.endAddress) ?? sessionCheckInDisplay,
            ));
          }
        }
        if (session.checkOutAt != null) {
          events.add(TimelineEvent(
            type: TimelineEventType.checkOut,
            time: session.checkOutAt!,
            location: AddressDisplay.getDisplay(session.checkOutAddress) ?? translation.of('dashboard.geo_tagged'),
          ));
        }
      }
      events.sort((a, b) => a.time.compareTo(b.time));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation.of('dashboard.today_activity_timeline'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              translation.of('dashboard.check_in_to_start'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: events.map((e) => _buildTimelineTile(context, e)).toList(),
          ),
      ],
    );
  }

  Widget _buildTimelineTile(BuildContext context, TimelineEvent event) {
    IconData icon;
    String label;
    Color? color;
    switch (event.type) {
      case TimelineEventType.checkIn:
        icon = Iconsax.check;
        label = 'Check in';
        color = Colors.green;
        break;
      case TimelineEventType.checkOut:
        icon = Iconsax.logout;
        label = 'Check out';
        color = Theme.of(context).colorScheme.error;
        break;
      case TimelineEventType.breakStart:
        icon = Iconsax.coffee;
        label = 'Break Start';
        color = Colors.brown;
        break;
      case TimelineEventType.breakEnd:
        icon = Iconsax.play_circle;
        label = 'Break End';
        color = Colors.brown;
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleDigits.format('$label - ${AppDateTimeFormat.formatTime(event.time)}, ${event.location}'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

