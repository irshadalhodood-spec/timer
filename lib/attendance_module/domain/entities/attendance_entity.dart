import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_entity.freezed.dart';
part 'attendance_entity.g.dart';

@freezed
class AttendanceEntity with _$AttendanceEntity {
  const factory AttendanceEntity({
    required String id,
    required String userId,
    required DateTime checkInAt,
    DateTime? checkOutAt,
    double? checkInLat,
    double? checkInLng,
    String? checkInAddress,
    double? checkOutLat,
    double? checkOutLng,
    String? checkOutAddress,
    @Default(0) int breakSeconds,
    String? earlyCheckoutNote,
    @Default(false) bool isEarlyCheckout,
    String? deviceInfo,
    @Default(false) bool synced,
    DateTime? syncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AttendanceEntity;

  factory AttendanceEntity.fromJson(Map<String, dynamic> json) =>
      _$AttendanceEntityFromJson(json);
}
