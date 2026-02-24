import 'package:freezed_annotation/freezed_annotation.dart';

part 'break_record_entity.freezed.dart';
part 'break_record_entity.g.dart';

@freezed
class BreakRecordEntity with _$BreakRecordEntity {
  const factory BreakRecordEntity({
    required String id,
    required String attendanceId,
    required String userId,
    required DateTime startAt,
    DateTime? endAt,
    String? startAddress,
    String? endAddress,
    @Default(false) bool synced,
    DateTime? syncedAt,
    DateTime? createdAt,
  }) = _BreakRecordEntity;

  factory BreakRecordEntity.fromJson(Map<String, dynamic> json) =>
      _$BreakRecordEntityFromJson(json);
}
