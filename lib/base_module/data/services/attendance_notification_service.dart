import 'dart:io';

import 'package:flutter/services.dart';

/// Service that shows check-in / check-out / break time in the native
/// notification shade (Android) or notification center (iOS) via Method Channel.
/// Supports action buttons (Check Out, Start Break, End Break) and a progress line.
class AttendanceNotificationService {
  AttendanceNotificationService() : _channel = const MethodChannel('com.example.employee_track/attendance_notification') {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  static const _methodShow = 'showAttendanceNotification';
  static const _methodClear = 'clearAttendanceNotification';

  final MethodChannel _channel;

  /// Called when the user taps an action in the notification (checkOut, startBreak, endBreak).
  static void Function(String action)? onNotificationAction;

  Future<dynamic> _onMethodCall(MethodCall call) async {
    if (call.method == 'notificationAction' && call.arguments is String) {
      onNotificationAction?.call(call.arguments as String);
    }
    return null;
  }

  /// Shows or updates the persistent attendance notification in the notification area.
  /// [expectedWorkSeconds] Target work seconds per day (e.g. 8h) for the progress bar.
  /// [breakSegments] Each item is {startSeconds, endSeconds} from check-in, so the timeline bar can show breaks at actual positions.
  Future<void> showAttendanceNotification({
    required String checkInAtIso,
    required int breakSeconds,
    required int workedSeconds,
    required bool isOnBreak,
    required int expectedWorkSeconds,
    List<Map<String, int>> breakSegments = const [],
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    try {
      await _channel.invokeMethod(_methodShow, <String, dynamic>{
        'checkInAtIso': checkInAtIso,
        'breakSeconds': breakSeconds,
        'workedSeconds': workedSeconds,
        'isOnBreak': isOnBreak,
        'expectedWorkSeconds': expectedWorkSeconds,
        'breakSegments': breakSegments,
      });
    } on PlatformException catch (_) {
      // Ignore if channel not implemented (e.g. unsupported platform)
    }
  }

  /// Removes the attendance notification (e.g. after check-out).
  Future<void> clearAttendanceNotification() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    try {
      await _channel.invokeMethod(_methodClear);
    } on PlatformException catch (_) {
      // Ignore
    }
  }
}
