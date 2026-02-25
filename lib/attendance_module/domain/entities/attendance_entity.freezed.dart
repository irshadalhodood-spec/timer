// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AttendanceEntity _$AttendanceEntityFromJson(Map<String, dynamic> json) {
  return _AttendanceEntity.fromJson(json);
}

/// @nodoc
mixin _$AttendanceEntity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get checkInAt => throw _privateConstructorUsedError;
  DateTime? get checkOutAt => throw _privateConstructorUsedError;
  double? get checkInLat => throw _privateConstructorUsedError;
  double? get checkInLng => throw _privateConstructorUsedError;
  String? get checkInAddress => throw _privateConstructorUsedError;
  double? get checkOutLat => throw _privateConstructorUsedError;
  double? get checkOutLng => throw _privateConstructorUsedError;
  String? get checkOutAddress => throw _privateConstructorUsedError;
  int get breakSeconds => throw _privateConstructorUsedError;
  String? get earlyCheckoutNote => throw _privateConstructorUsedError;
  bool get isEarlyCheckout => throw _privateConstructorUsedError;
  bool get isAutoCheckout => throw _privateConstructorUsedError;
  String? get deviceInfo => throw _privateConstructorUsedError;
  bool get synced => throw _privateConstructorUsedError;
  DateTime? get syncedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AttendanceEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceEntityCopyWith<AttendanceEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceEntityCopyWith<$Res> {
  factory $AttendanceEntityCopyWith(
    AttendanceEntity value,
    $Res Function(AttendanceEntity) then,
  ) = _$AttendanceEntityCopyWithImpl<$Res, AttendanceEntity>;
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime checkInAt,
    DateTime? checkOutAt,
    double? checkInLat,
    double? checkInLng,
    String? checkInAddress,
    double? checkOutLat,
    double? checkOutLng,
    String? checkOutAddress,
    int breakSeconds,
    String? earlyCheckoutNote,
    bool isEarlyCheckout,
    bool isAutoCheckout,
    String? deviceInfo,
    bool synced,
    DateTime? syncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$AttendanceEntityCopyWithImpl<$Res, $Val extends AttendanceEntity>
    implements $AttendanceEntityCopyWith<$Res> {
  _$AttendanceEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? checkInAt = null,
    Object? checkOutAt = freezed,
    Object? checkInLat = freezed,
    Object? checkInLng = freezed,
    Object? checkInAddress = freezed,
    Object? checkOutLat = freezed,
    Object? checkOutLng = freezed,
    Object? checkOutAddress = freezed,
    Object? breakSeconds = null,
    Object? earlyCheckoutNote = freezed,
    Object? isEarlyCheckout = null,
    Object? isAutoCheckout = null,
    Object? deviceInfo = freezed,
    Object? synced = null,
    Object? syncedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            checkInAt: null == checkInAt
                ? _value.checkInAt
                : checkInAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            checkOutAt: freezed == checkOutAt
                ? _value.checkOutAt
                : checkOutAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            checkInLat: freezed == checkInLat
                ? _value.checkInLat
                : checkInLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            checkInLng: freezed == checkInLng
                ? _value.checkInLng
                : checkInLng // ignore: cast_nullable_to_non_nullable
                      as double?,
            checkInAddress: freezed == checkInAddress
                ? _value.checkInAddress
                : checkInAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkOutLat: freezed == checkOutLat
                ? _value.checkOutLat
                : checkOutLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            checkOutLng: freezed == checkOutLng
                ? _value.checkOutLng
                : checkOutLng // ignore: cast_nullable_to_non_nullable
                      as double?,
            checkOutAddress: freezed == checkOutAddress
                ? _value.checkOutAddress
                : checkOutAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            breakSeconds: null == breakSeconds
                ? _value.breakSeconds
                : breakSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            earlyCheckoutNote: freezed == earlyCheckoutNote
                ? _value.earlyCheckoutNote
                : earlyCheckoutNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            isEarlyCheckout: null == isEarlyCheckout
                ? _value.isEarlyCheckout
                : isEarlyCheckout // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAutoCheckout: null == isAutoCheckout
                ? _value.isAutoCheckout
                : isAutoCheckout // ignore: cast_nullable_to_non_nullable
                      as bool,
            deviceInfo: freezed == deviceInfo
                ? _value.deviceInfo
                : deviceInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
            synced: null == synced
                ? _value.synced
                : synced // ignore: cast_nullable_to_non_nullable
                      as bool,
            syncedAt: freezed == syncedAt
                ? _value.syncedAt
                : syncedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttendanceEntityImplCopyWith<$Res>
    implements $AttendanceEntityCopyWith<$Res> {
  factory _$$AttendanceEntityImplCopyWith(
    _$AttendanceEntityImpl value,
    $Res Function(_$AttendanceEntityImpl) then,
  ) = __$$AttendanceEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime checkInAt,
    DateTime? checkOutAt,
    double? checkInLat,
    double? checkInLng,
    String? checkInAddress,
    double? checkOutLat,
    double? checkOutLng,
    String? checkOutAddress,
    int breakSeconds,
    String? earlyCheckoutNote,
    bool isEarlyCheckout,
    bool isAutoCheckout,
    String? deviceInfo,
    bool synced,
    DateTime? syncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$AttendanceEntityImplCopyWithImpl<$Res>
    extends _$AttendanceEntityCopyWithImpl<$Res, _$AttendanceEntityImpl>
    implements _$$AttendanceEntityImplCopyWith<$Res> {
  __$$AttendanceEntityImplCopyWithImpl(
    _$AttendanceEntityImpl _value,
    $Res Function(_$AttendanceEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttendanceEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? checkInAt = null,
    Object? checkOutAt = freezed,
    Object? checkInLat = freezed,
    Object? checkInLng = freezed,
    Object? checkInAddress = freezed,
    Object? checkOutLat = freezed,
    Object? checkOutLng = freezed,
    Object? checkOutAddress = freezed,
    Object? breakSeconds = null,
    Object? earlyCheckoutNote = freezed,
    Object? isEarlyCheckout = null,
    Object? isAutoCheckout = null,
    Object? deviceInfo = freezed,
    Object? synced = null,
    Object? syncedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$AttendanceEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        checkInAt: null == checkInAt
            ? _value.checkInAt
            : checkInAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        checkOutAt: freezed == checkOutAt
            ? _value.checkOutAt
            : checkOutAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        checkInLat: freezed == checkInLat
            ? _value.checkInLat
            : checkInLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        checkInLng: freezed == checkInLng
            ? _value.checkInLng
            : checkInLng // ignore: cast_nullable_to_non_nullable
                  as double?,
        checkInAddress: freezed == checkInAddress
            ? _value.checkInAddress
            : checkInAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkOutLat: freezed == checkOutLat
            ? _value.checkOutLat
            : checkOutLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        checkOutLng: freezed == checkOutLng
            ? _value.checkOutLng
            : checkOutLng // ignore: cast_nullable_to_non_nullable
                  as double?,
        checkOutAddress: freezed == checkOutAddress
            ? _value.checkOutAddress
            : checkOutAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        breakSeconds: null == breakSeconds
            ? _value.breakSeconds
            : breakSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        earlyCheckoutNote: freezed == earlyCheckoutNote
            ? _value.earlyCheckoutNote
            : earlyCheckoutNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        isEarlyCheckout: null == isEarlyCheckout
            ? _value.isEarlyCheckout
            : isEarlyCheckout // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAutoCheckout: null == isAutoCheckout
            ? _value.isAutoCheckout
            : isAutoCheckout // ignore: cast_nullable_to_non_nullable
                  as bool,
        deviceInfo: freezed == deviceInfo
            ? _value.deviceInfo
            : deviceInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
        synced: null == synced
            ? _value.synced
            : synced // ignore: cast_nullable_to_non_nullable
                  as bool,
        syncedAt: freezed == syncedAt
            ? _value.syncedAt
            : syncedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceEntityImpl implements _AttendanceEntity {
  const _$AttendanceEntityImpl({
    required this.id,
    required this.userId,
    required this.checkInAt,
    this.checkOutAt,
    this.checkInLat,
    this.checkInLng,
    this.checkInAddress,
    this.checkOutLat,
    this.checkOutLng,
    this.checkOutAddress,
    this.breakSeconds = 0,
    this.earlyCheckoutNote,
    this.isEarlyCheckout = false,
    this.isAutoCheckout = false,
    this.deviceInfo,
    this.synced = false,
    this.syncedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory _$AttendanceEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime checkInAt;
  @override
  final DateTime? checkOutAt;
  @override
  final double? checkInLat;
  @override
  final double? checkInLng;
  @override
  final String? checkInAddress;
  @override
  final double? checkOutLat;
  @override
  final double? checkOutLng;
  @override
  final String? checkOutAddress;
  @override
  @JsonKey()
  final int breakSeconds;
  @override
  final String? earlyCheckoutNote;
  @override
  @JsonKey()
  final bool isEarlyCheckout;
  @override
  @JsonKey()
  final bool isAutoCheckout;
  @override
  final String? deviceInfo;
  @override
  @JsonKey()
  final bool synced;
  @override
  final DateTime? syncedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AttendanceEntity(id: $id, userId: $userId, checkInAt: $checkInAt, checkOutAt: $checkOutAt, checkInLat: $checkInLat, checkInLng: $checkInLng, checkInAddress: $checkInAddress, checkOutLat: $checkOutLat, checkOutLng: $checkOutLng, checkOutAddress: $checkOutAddress, breakSeconds: $breakSeconds, earlyCheckoutNote: $earlyCheckoutNote, isEarlyCheckout: $isEarlyCheckout, isAutoCheckout: $isAutoCheckout, deviceInfo: $deviceInfo, synced: $synced, syncedAt: $syncedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.checkInAt, checkInAt) ||
                other.checkInAt == checkInAt) &&
            (identical(other.checkOutAt, checkOutAt) ||
                other.checkOutAt == checkOutAt) &&
            (identical(other.checkInLat, checkInLat) ||
                other.checkInLat == checkInLat) &&
            (identical(other.checkInLng, checkInLng) ||
                other.checkInLng == checkInLng) &&
            (identical(other.checkInAddress, checkInAddress) ||
                other.checkInAddress == checkInAddress) &&
            (identical(other.checkOutLat, checkOutLat) ||
                other.checkOutLat == checkOutLat) &&
            (identical(other.checkOutLng, checkOutLng) ||
                other.checkOutLng == checkOutLng) &&
            (identical(other.checkOutAddress, checkOutAddress) ||
                other.checkOutAddress == checkOutAddress) &&
            (identical(other.breakSeconds, breakSeconds) ||
                other.breakSeconds == breakSeconds) &&
            (identical(other.earlyCheckoutNote, earlyCheckoutNote) ||
                other.earlyCheckoutNote == earlyCheckoutNote) &&
            (identical(other.isEarlyCheckout, isEarlyCheckout) ||
                other.isEarlyCheckout == isEarlyCheckout) &&
            (identical(other.isAutoCheckout, isAutoCheckout) ||
                other.isAutoCheckout == isAutoCheckout) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo) &&
            (identical(other.synced, synced) || other.synced == synced) &&
            (identical(other.syncedAt, syncedAt) ||
                other.syncedAt == syncedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    checkInAt,
    checkOutAt,
    checkInLat,
    checkInLng,
    checkInAddress,
    checkOutLat,
    checkOutLng,
    checkOutAddress,
    breakSeconds,
    earlyCheckoutNote,
    isEarlyCheckout,
    isAutoCheckout,
    deviceInfo,
    synced,
    syncedAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of AttendanceEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceEntityImplCopyWith<_$AttendanceEntityImpl> get copyWith =>
      __$$AttendanceEntityImplCopyWithImpl<_$AttendanceEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceEntityImplToJson(this);
  }
}

abstract class _AttendanceEntity implements AttendanceEntity {
  const factory _AttendanceEntity({
    required final String id,
    required final String userId,
    required final DateTime checkInAt,
    final DateTime? checkOutAt,
    final double? checkInLat,
    final double? checkInLng,
    final String? checkInAddress,
    final double? checkOutLat,
    final double? checkOutLng,
    final String? checkOutAddress,
    final int breakSeconds,
    final String? earlyCheckoutNote,
    final bool isEarlyCheckout,
    final bool isAutoCheckout,
    final String? deviceInfo,
    final bool synced,
    final DateTime? syncedAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$AttendanceEntityImpl;

  factory _AttendanceEntity.fromJson(Map<String, dynamic> json) =
      _$AttendanceEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get checkInAt;
  @override
  DateTime? get checkOutAt;
  @override
  double? get checkInLat;
  @override
  double? get checkInLng;
  @override
  String? get checkInAddress;
  @override
  double? get checkOutLat;
  @override
  double? get checkOutLng;
  @override
  String? get checkOutAddress;
  @override
  int get breakSeconds;
  @override
  String? get earlyCheckoutNote;
  @override
  bool get isEarlyCheckout;
  @override
  bool get isAutoCheckout;
  @override
  String? get deviceInfo;
  @override
  bool get synced;
  @override
  DateTime? get syncedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of AttendanceEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceEntityImplCopyWith<_$AttendanceEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
