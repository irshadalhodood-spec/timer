// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_queue_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SyncQueueEntity _$SyncQueueEntityFromJson(Map<String, dynamic> json) {
  return _SyncQueueEntity.fromJson(json);
}

/// @nodoc
mixin _$SyncQueueEntity {
  String get id => throw _privateConstructorUsedError;
  SyncEntityType get entityType => throw _privateConstructorUsedError;
  SyncAction get action => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  String get payloadJson => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;
  String? get lastError => throw _privateConstructorUsedError;
  DateTime? get lastAttemptAt => throw _privateConstructorUsedError;

  /// Serializes this SyncQueueEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncQueueEntityCopyWith<SyncQueueEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncQueueEntityCopyWith<$Res> {
  factory $SyncQueueEntityCopyWith(
    SyncQueueEntity value,
    $Res Function(SyncQueueEntity) then,
  ) = _$SyncQueueEntityCopyWithImpl<$Res, SyncQueueEntity>;
  @useResult
  $Res call({
    String id,
    SyncEntityType entityType,
    SyncAction action,
    String entityId,
    String payloadJson,
    DateTime createdAt,
    int retryCount,
    String? lastError,
    DateTime? lastAttemptAt,
  });
}

/// @nodoc
class _$SyncQueueEntityCopyWithImpl<$Res, $Val extends SyncQueueEntity>
    implements $SyncQueueEntityCopyWith<$Res> {
  _$SyncQueueEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? action = null,
    Object? entityId = null,
    Object? payloadJson = null,
    Object? createdAt = null,
    Object? retryCount = null,
    Object? lastError = freezed,
    Object? lastAttemptAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as SyncEntityType,
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as SyncAction,
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as String,
            payloadJson: null == payloadJson
                ? _value.payloadJson
                : payloadJson // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            retryCount: null == retryCount
                ? _value.retryCount
                : retryCount // ignore: cast_nullable_to_non_nullable
                      as int,
            lastError: freezed == lastError
                ? _value.lastError
                : lastError // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastAttemptAt: freezed == lastAttemptAt
                ? _value.lastAttemptAt
                : lastAttemptAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncQueueEntityImplCopyWith<$Res>
    implements $SyncQueueEntityCopyWith<$Res> {
  factory _$$SyncQueueEntityImplCopyWith(
    _$SyncQueueEntityImpl value,
    $Res Function(_$SyncQueueEntityImpl) then,
  ) = __$$SyncQueueEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    SyncEntityType entityType,
    SyncAction action,
    String entityId,
    String payloadJson,
    DateTime createdAt,
    int retryCount,
    String? lastError,
    DateTime? lastAttemptAt,
  });
}

/// @nodoc
class __$$SyncQueueEntityImplCopyWithImpl<$Res>
    extends _$SyncQueueEntityCopyWithImpl<$Res, _$SyncQueueEntityImpl>
    implements _$$SyncQueueEntityImplCopyWith<$Res> {
  __$$SyncQueueEntityImplCopyWithImpl(
    _$SyncQueueEntityImpl _value,
    $Res Function(_$SyncQueueEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? action = null,
    Object? entityId = null,
    Object? payloadJson = null,
    Object? createdAt = null,
    Object? retryCount = null,
    Object? lastError = freezed,
    Object? lastAttemptAt = freezed,
  }) {
    return _then(
      _$SyncQueueEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as SyncEntityType,
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as SyncAction,
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        payloadJson: null == payloadJson
            ? _value.payloadJson
            : payloadJson // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        retryCount: null == retryCount
            ? _value.retryCount
            : retryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        lastError: freezed == lastError
            ? _value.lastError
            : lastError // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastAttemptAt: freezed == lastAttemptAt
            ? _value.lastAttemptAt
            : lastAttemptAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncQueueEntityImpl implements _SyncQueueEntity {
  const _$SyncQueueEntityImpl({
    required this.id,
    required this.entityType,
    required this.action,
    required this.entityId,
    required this.payloadJson,
    required this.createdAt,
    this.retryCount = 0,
    this.lastError,
    this.lastAttemptAt,
  });

  factory _$SyncQueueEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncQueueEntityImplFromJson(json);

  @override
  final String id;
  @override
  final SyncEntityType entityType;
  @override
  final SyncAction action;
  @override
  final String entityId;
  @override
  final String payloadJson;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int retryCount;
  @override
  final String? lastError;
  @override
  final DateTime? lastAttemptAt;

  @override
  String toString() {
    return 'SyncQueueEntity(id: $id, entityType: $entityType, action: $action, entityId: $entityId, payloadJson: $payloadJson, createdAt: $createdAt, retryCount: $retryCount, lastError: $lastError, lastAttemptAt: $lastAttemptAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncQueueEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.payloadJson, payloadJson) ||
                other.payloadJson == payloadJson) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError) &&
            (identical(other.lastAttemptAt, lastAttemptAt) ||
                other.lastAttemptAt == lastAttemptAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    entityType,
    action,
    entityId,
    payloadJson,
    createdAt,
    retryCount,
    lastError,
    lastAttemptAt,
  );

  /// Create a copy of SyncQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncQueueEntityImplCopyWith<_$SyncQueueEntityImpl> get copyWith =>
      __$$SyncQueueEntityImplCopyWithImpl<_$SyncQueueEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncQueueEntityImplToJson(this);
  }
}

abstract class _SyncQueueEntity implements SyncQueueEntity {
  const factory _SyncQueueEntity({
    required final String id,
    required final SyncEntityType entityType,
    required final SyncAction action,
    required final String entityId,
    required final String payloadJson,
    required final DateTime createdAt,
    final int retryCount,
    final String? lastError,
    final DateTime? lastAttemptAt,
  }) = _$SyncQueueEntityImpl;

  factory _SyncQueueEntity.fromJson(Map<String, dynamic> json) =
      _$SyncQueueEntityImpl.fromJson;

  @override
  String get id;
  @override
  SyncEntityType get entityType;
  @override
  SyncAction get action;
  @override
  String get entityId;
  @override
  String get payloadJson;
  @override
  DateTime get createdAt;
  @override
  int get retryCount;
  @override
  String? get lastError;
  @override
  DateTime? get lastAttemptAt;

  /// Create a copy of SyncQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncQueueEntityImplCopyWith<_$SyncQueueEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
