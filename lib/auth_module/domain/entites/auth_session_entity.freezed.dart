// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthSessionEntity _$AuthSessionEntityFromJson(Map<String, dynamic> json) {
  return _AuthSessionEntity.fromJson(json);
}

/// @nodoc
mixin _$AuthSessionEntity {
  String get accessToken => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;
  UserEntity get user => throw _privateConstructorUsedError;
  String? get organizationId => throw _privateConstructorUsedError;
  String? get organizationInviteUrl => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this AuthSessionEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthSessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthSessionEntityCopyWith<AuthSessionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthSessionEntityCopyWith<$Res> {
  factory $AuthSessionEntityCopyWith(
    AuthSessionEntity value,
    $Res Function(AuthSessionEntity) then,
  ) = _$AuthSessionEntityCopyWithImpl<$Res, AuthSessionEntity>;
  @useResult
  $Res call({
    String accessToken,
    String? refreshToken,
    UserEntity user,
    String? organizationId,
    String? organizationInviteUrl,
    DateTime? expiresAt,
  });

  $UserEntityCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthSessionEntityCopyWithImpl<$Res, $Val extends AuthSessionEntity>
    implements $AuthSessionEntityCopyWith<$Res> {
  _$AuthSessionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthSessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = freezed,
    Object? user = null,
    Object? organizationId = freezed,
    Object? organizationInviteUrl = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: freezed == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserEntity,
            organizationId: freezed == organizationId
                ? _value.organizationId
                : organizationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            organizationInviteUrl: freezed == organizationInviteUrl
                ? _value.organizationInviteUrl
                : organizationInviteUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthSessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<$Res> get user {
    return $UserEntityCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthSessionEntityImplCopyWith<$Res>
    implements $AuthSessionEntityCopyWith<$Res> {
  factory _$$AuthSessionEntityImplCopyWith(
    _$AuthSessionEntityImpl value,
    $Res Function(_$AuthSessionEntityImpl) then,
  ) = __$$AuthSessionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String accessToken,
    String? refreshToken,
    UserEntity user,
    String? organizationId,
    String? organizationInviteUrl,
    DateTime? expiresAt,
  });

  @override
  $UserEntityCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthSessionEntityImplCopyWithImpl<$Res>
    extends _$AuthSessionEntityCopyWithImpl<$Res, _$AuthSessionEntityImpl>
    implements _$$AuthSessionEntityImplCopyWith<$Res> {
  __$$AuthSessionEntityImplCopyWithImpl(
    _$AuthSessionEntityImpl _value,
    $Res Function(_$AuthSessionEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthSessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = freezed,
    Object? user = null,
    Object? organizationId = freezed,
    Object? organizationInviteUrl = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _$AuthSessionEntityImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: freezed == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserEntity,
        organizationId: freezed == organizationId
            ? _value.organizationId
            : organizationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        organizationInviteUrl: freezed == organizationInviteUrl
            ? _value.organizationInviteUrl
            : organizationInviteUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthSessionEntityImpl implements _AuthSessionEntity {
  const _$AuthSessionEntityImpl({
    required this.accessToken,
    this.refreshToken,
    required this.user,
    this.organizationId,
    this.organizationInviteUrl,
    this.expiresAt,
  });

  factory _$AuthSessionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthSessionEntityImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String? refreshToken;
  @override
  final UserEntity user;
  @override
  final String? organizationId;
  @override
  final String? organizationInviteUrl;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'AuthSessionEntity(accessToken: $accessToken, refreshToken: $refreshToken, user: $user, organizationId: $organizationId, organizationInviteUrl: $organizationInviteUrl, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSessionEntityImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.organizationInviteUrl, organizationInviteUrl) ||
                other.organizationInviteUrl == organizationInviteUrl) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accessToken,
    refreshToken,
    user,
    organizationId,
    organizationInviteUrl,
    expiresAt,
  );

  /// Create a copy of AuthSessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSessionEntityImplCopyWith<_$AuthSessionEntityImpl> get copyWith =>
      __$$AuthSessionEntityImplCopyWithImpl<_$AuthSessionEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthSessionEntityImplToJson(this);
  }
}

abstract class _AuthSessionEntity implements AuthSessionEntity {
  const factory _AuthSessionEntity({
    required final String accessToken,
    final String? refreshToken,
    required final UserEntity user,
    final String? organizationId,
    final String? organizationInviteUrl,
    final DateTime? expiresAt,
  }) = _$AuthSessionEntityImpl;

  factory _AuthSessionEntity.fromJson(Map<String, dynamic> json) =
      _$AuthSessionEntityImpl.fromJson;

  @override
  String get accessToken;
  @override
  String? get refreshToken;
  @override
  UserEntity get user;
  @override
  String? get organizationId;
  @override
  String? get organizationInviteUrl;
  @override
  DateTime? get expiresAt;

  /// Create a copy of AuthSessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthSessionEntityImplCopyWith<_$AuthSessionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
