import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../attendance_module/domain/entities/attendance_entity.dart';
import '../../employee_track/domain/entities/break_record_entity.dart';
import '../../base_module/domain/entities/sync_queue_entity.dart';
import '../../base_module/domain/entities/working_hours_config.dart';
import '../../attendance_module/domain/repositories/attendance_repository.dart';
import '../../employee_track/domain/repositories/break_record_repository.dart';
import '../../base_module/domain/repositories/sync_queue_repository.dart';
import '../../base_module/domain/repositories/working_hours_repository.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc({
    required AttendanceRepository attendanceRepository,
    required BreakRecordRepository breakRecordRepository,
    required SyncQueueRepository syncQueueRepository,
    required WorkingHoursRepository workingHoursRepository,
    required String userId,
  })  : _attendance = attendanceRepository,
        _breakRecord = breakRecordRepository,
        _syncQueue = syncQueueRepository,
        _workingHours = workingHoursRepository,
        _userId = userId,
        super(AttendanceState.initial) {
    on<AttendanceLoadRequested>(_onLoadRequested);
    on<AttendanceCheckInRequested>(_onCheckInRequested);
    on<AttendanceCheckOutRequested>(_onCheckOutRequested);
    on<AttendanceBreakStartRequested>(_onBreakStartRequested);
    on<AttendanceBreakEndRequested>(_onBreakEndRequested);
    on<AttendanceHistoryRequested>(_onHistoryRequested);
  }

  final AttendanceRepository _attendance;
  final BreakRecordRepository _breakRecord;
  final SyncQueueRepository _syncQueue;
  final WorkingHoursRepository _workingHours;
  final String _userId;

  /// Effective auto-checkout time for a session that started on [checkInDateLocal] (midnight local).
  DateTime _effectiveAutoCheckOutTime(WorkingHoursConfig config, DateTime checkInDateLocal) {
    final startOfDay = DateTime(checkInDateLocal.year, checkInDateLocal.month, checkInDateLocal.day);
    if (config.endsNextDay) {
      final nextDay = startOfDay.add(const Duration(days: 1));
      return DateTime(
        nextDay.year,
        nextDay.month,
        nextDay.day,
        config.shiftEndHour,
        config.shiftEndMinute,
      );
    }
    return DateTime(
      startOfDay.year,
      startOfDay.month,
      startOfDay.day,
      config.shiftEndHour,
      config.shiftEndMinute,
    );
  }

  Future<void> _onLoadRequested(AttendanceLoadRequested event, Emitter<AttendanceState> emit) async {
    try {
      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);

      // Auto-checkout: if there is an open session from a previous day, close it at effective end time.
      final open = await _attendance.getOpenAttendance(_userId);
      if (open != null) {
        final checkInLocal = open.checkInAt.isUtc ? open.checkInAt.toLocal() : open.checkInAt;
        final checkInDay = DateTime(checkInLocal.year, checkInLocal.month, checkInLocal.day);
        if (checkInDay.isBefore(startOfToday)) {
          final config = await _workingHours.getWorkingHours();
          final effectiveEnd = _effectiveAutoCheckOutTime(config, checkInDay);
          if (!now.isBefore(effectiveEnd)) {
            final breaks = await _breakRecord.getByAttendanceId(open.id);
            final breakSeconds = _totalBreakSecondsFromRecords(breaks, effectiveEnd);
            final updated = open.copyWith(
              checkOutAt: effectiveEnd,
              breakSeconds: breakSeconds,
              isAutoCheckout: true,
              updatedAt: effectiveEnd,
            );
            await _attendance.saveAttendance(updated);
            await _syncQueue.enqueue(SyncQueueEntity(
              id: 'sync_out_${open.id}',
              entityType: SyncEntityType.checkOut,
              action: SyncAction.update,
              entityId: open.id,
              payloadJson: '{"attendanceId":"${open.id}"}',
              createdAt: now,
            ));
            // Continue to load state below (no open session from today yet).
          }
        }
      }

      final endOfToday = startOfToday.add(const Duration(days: 1));
      final todaySessionsRaw = await _attendance.getAttendancesByUser(
        _userId,
        from: startOfToday,
        to: endOfToday,
      );
      final todaySessions = List<AttendanceEntity>.from(todaySessionsRaw)
        ..sort((a, b) => a.checkInAt.compareTo(b.checkInAt));

      final today = await _attendance.getTodayCheckIn(_userId);
      if (today != null) {
        final breaks = await _breakRecord.getByAttendanceId(today.id);
        int breakSeconds = 0;
        for (final b in breaks) {
          if (b.endAt != null) {
            breakSeconds += b.endAt!.difference(b.startAt).inSeconds;
          } else {
            breakSeconds += DateTime.now().difference(b.startAt).inSeconds;
          }
        }
        emit(AttendanceState.checkedIn(today, breaks, breakSeconds, todaySessions: todaySessions));
      } else {
        final sessionBreaks = <String, List<BreakRecordEntity>>{};
        for (final session in todaySessions) {
          final breaks = await _breakRecord.getByAttendanceId(session.id);
          sessionBreaks[session.id] = breaks;
        }
        emit(AttendanceState.checkedOut(
          todaySessions: todaySessions,
          todaySessionBreaks: sessionBreaks,
        ));
      }
    } catch (e) {
      emit(AttendanceState.failure(e.toString()));
    }
  }

  Future<void> _onCheckInRequested(AttendanceCheckInRequested event, Emitter<AttendanceState> emit) async {
    try {
      final now = DateTime.now();
      final id = 'att_${_userId}_${now.millisecondsSinceEpoch}';
      final entity = AttendanceEntity(
        id: id,
        userId: _userId,
        checkInAt: now,
        checkInLat: event.lat,
        checkInLng: event.lng,
        checkInAddress: event.address,
        deviceInfo: event.deviceInfo,
        createdAt: now,
        updatedAt: now,
      );
      await _attendance.saveAttendance(entity);
      await _syncQueue.enqueue(SyncQueueEntity(
        id: 'sync_$id',
        entityType: SyncEntityType.checkIn,
        action: SyncAction.create,
        entityId: id,
        payloadJson: '{"id":"$id","attendanceId":"$id","checkInAt":"${now.toIso8601String()}"}',
        createdAt: now,
      ));
      add(AttendanceLoadRequested());
    } catch (e) {
      emit(AttendanceState.failure(e.toString()));
    }
  }

  /// Sum total break seconds from break records for an attendance (for persistence on attendance row).
  int _totalBreakSecondsFromRecords(List<BreakRecordEntity> breaks, DateTime now) {
    int sec = 0;
    for (final b in breaks) {
      if (b.endAt != null) {
        sec += b.endAt!.difference(b.startAt).inSeconds;
      } else {
        sec += now.difference(b.startAt).inSeconds;
      }
    }
    return sec;
  }

  Future<List<AttendanceEntity>> _enrichBreakSeconds(List<AttendanceEntity> list) async {
    final result = <AttendanceEntity>[];
    for (final a in list) {
      if (a.breakSeconds > 0) {
        result.add(a);
        continue;
      }
      final breaks = await _breakRecord.getByAttendanceId(a.id);
      if (breaks.isEmpty) {
        result.add(a);
        continue;
      }
      final endReference = a.checkOutAt ?? DateTime.now();
      final breakSeconds = _totalBreakSecondsFromRecords(breaks, endReference);
      result.add(a.copyWith(breakSeconds: breakSeconds));
    }
    return result;
  }

  Future<void> _onCheckOutRequested(AttendanceCheckOutRequested event, Emitter<AttendanceState> emit) async {
    try {
      final today = await _attendance.getTodayCheckIn(_userId);
      if (today == null) return;
      final now = DateTime.now();
      final breaks = await _breakRecord.getByAttendanceId(today.id);
      final breakSeconds = _totalBreakSecondsFromRecords(breaks, now);
      final updated = today.copyWith(
        checkOutAt: now,
        checkOutLat: event.lat,
        checkOutLng: event.lng,
        checkOutAddress: event.address,
        breakSeconds: breakSeconds,
        earlyCheckoutNote: event.earlyCheckoutNote,
        isEarlyCheckout: event.isEarlyCheckout,
        updatedAt: now,
      );
      await _attendance.saveAttendance(updated);
      await _syncQueue.enqueue(SyncQueueEntity(
        id: 'sync_out_${today.id}',
        entityType: SyncEntityType.checkOut,
        action: SyncAction.update,
        entityId: today.id,
        payloadJson: '{"attendanceId":"${today.id}"}',
        createdAt: now,
      ));
      add(AttendanceLoadRequested());
    } catch (e) {
      emit(AttendanceState.failure(e.toString()));
    }
  }

  Future<void> _onBreakStartRequested(AttendanceBreakStartRequested event, Emitter<AttendanceState> emit) async {
    try {
      final today = await _attendance.getTodayCheckIn(_userId);
      if (today == null) return;
      final breaks = await _breakRecord.getByAttendanceId(today.id);
      final hasActiveBreak = breaks.any((b) => b.endAt == null);
      if (hasActiveBreak) return;
      final now = DateTime.now();
      final id = 'break_${today.id}_${now.millisecondsSinceEpoch}';
      final record = BreakRecordEntity(
        id: id,
        attendanceId: today.id,
        userId: _userId,
        startAt: now,
        startAddress: today.checkInAddress,
        createdAt: now,
      );
      await _breakRecord.saveBreakRecord(record);
      await _syncQueue.enqueue(SyncQueueEntity(
        id: 'sync_$id',
        entityType: SyncEntityType.breakRecord,
        action: SyncAction.create,
        entityId: id,
        payloadJson: '{"id":"$id"}',
        createdAt: now,
      ));
      add(AttendanceLoadRequested());
    } catch (e) {
      emit(AttendanceState.failure(e.toString()));
    }
  }

  Future<void> _onBreakEndRequested(AttendanceBreakEndRequested event, Emitter<AttendanceState> emit) async {
    try {
      final today = await _attendance.getTodayCheckIn(_userId);
      if (today == null) return;
      final breaks = await _breakRecord.getByAttendanceId(today.id);
      final activeBreak = breaks.where((b) => b.endAt == null).firstOrNull;
      if (activeBreak == null) return;
      final now = DateTime.now();
      final updatedBreak = activeBreak.copyWith(
        endAt: now,
        endAddress: today.checkInAddress ?? activeBreak.startAddress,
      );
      await _breakRecord.updateBreakRecord(updatedBreak);
      final allBreaks = await _breakRecord.getByAttendanceId(today.id);
      final breakSeconds = _totalBreakSecondsFromRecords(allBreaks, now);
      final updatedAttendance = today.copyWith(breakSeconds: breakSeconds, updatedAt: now);
      await _attendance.saveAttendance(updatedAttendance);
      add(AttendanceLoadRequested());
    } catch (e) {
      emit(AttendanceState.failure(e.toString()));
    }
  }

  Future<void> _onHistoryRequested(AttendanceHistoryRequested event, Emitter<AttendanceState> emit) async {
    if (event.from == null || event.to == null) return;
    try {
      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      final endOfToday = startOfToday.add(const Duration(days: 1));
      final today = await _attendance.getTodayCheckIn(_userId);
      AttendanceEntity? todayAttendance;
      List<BreakRecordEntity> todayBreaks = const [];
      int todayBreakSeconds = 0;
      if (today != null) {
        todayBreaks = await _breakRecord.getByAttendanceId(today.id);
        for (final b in todayBreaks) {
          if (b.endAt != null) {
            todayBreakSeconds += b.endAt!.difference(b.startAt).inSeconds;
          } else {
            todayBreakSeconds += DateTime.now().difference(b.startAt).inSeconds;
          }
        }
        todayAttendance = today;
      }
      emit(AttendanceState.historyLoading(
        todayAttendance: todayAttendance,
        todayBreaks: todayBreaks,
        todayBreakSeconds: todayBreakSeconds,
        todaySessions: const [],
      ));
      // API-style fetch (mock or real) via repository
      var list = await _attendance.getAttendancesByUser(
        _userId,
        from: event.from,
        to: event.to,
      );
      list = await _enrichBreakSeconds(list);
      final todaySessions = List<AttendanceEntity>.from(
        list.where((a) => !a.checkInAt.isBefore(startOfToday) && a.checkInAt.isBefore(endOfToday)),
      )..sort((a, b) => a.checkInAt.compareTo(b.checkInAt));
      emit(AttendanceState.historyLoaded(
        list,
        todayAttendance: todayAttendance,
        todayBreaks: todayBreaks,
        todayBreakSeconds: todayBreakSeconds,
        todaySessions: todaySessions,
      ));
    } catch (e) {
      emit(AttendanceState.failure(e.toString()));
    }
  }
}
