part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
  @override
  List<Object?> get props => [];
}

class AttendanceLoadRequested extends AttendanceEvent {
  const AttendanceLoadRequested();
}

class AttendanceCheckInRequested extends AttendanceEvent {
  const AttendanceCheckInRequested({
    this.lat,
    this.lng,
    this.address,
    this.deviceInfo,
  });
  final double? lat;
  final double? lng;
  final String? address;
  final String? deviceInfo;
  @override
  List<Object?> get props => [lat, lng, address, deviceInfo];
}

class AttendanceCheckOutRequested extends AttendanceEvent {
  const AttendanceCheckOutRequested({
    this.lat,
    this.lng,
    this.address,
    this.earlyCheckoutNote,
    this.isEarlyCheckout = false,
  });
  final double? lat;
  final double? lng;
  final String? address;
  final String? earlyCheckoutNote;
  final bool isEarlyCheckout;
  @override
  List<Object?> get props => [lat, lng, address, earlyCheckoutNote, isEarlyCheckout];
}

class AttendanceBreakStartRequested extends AttendanceEvent {
  const AttendanceBreakStartRequested();
}

class AttendanceBreakEndRequested extends AttendanceEvent {
  const AttendanceBreakEndRequested();
}

class AttendanceHistoryRequested extends AttendanceEvent {
  const AttendanceHistoryRequested({this.from, this.to});
  final DateTime? from;
  final DateTime? to;
  @override
  List<Object?> get props => [from, to];
}
