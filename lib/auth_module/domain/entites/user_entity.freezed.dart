// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return _UserEntity.fromJson(json);
}

/// @nodoc
mixin _$UserEntity {
  @JsonKey(name: "user_id")
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get profilePhotoUrl => throw _privateConstructorUsedError;
  String? get jobTitle => throw _privateConstructorUsedError;
  String? get departmentId => throw _privateConstructorUsedError;
  String? get departmentName => throw _privateConstructorUsedError;
  String? get reportingManagerId => throw _privateConstructorUsedError;
  DateTime? get joinDate => throw _privateConstructorUsedError;
  @JsonKey(name: "admin_user")
  bool? get adminUser => throw _privateConstructorUsedError;

  /// Serializes this UserEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserEntityCopyWith<UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEntityCopyWith<$Res> {
  factory $UserEntityCopyWith(
    UserEntity value,
    $Res Function(UserEntity) then,
  ) = _$UserEntityCopyWithImpl<$Res, UserEntity>;
  @useResult
  $Res call({
    @JsonKey(name: "user_id") String userId,
    String username,
    String? email,
    String? phone,
    String? fullName,
    String? profilePhotoUrl,
    String? jobTitle,
    String? departmentId,
    String? departmentName,
    String? reportingManagerId,
    DateTime? joinDate,
    @JsonKey(name: "admin_user") bool? adminUser,
  });
}

/// @nodoc
class _$UserEntityCopyWithImpl<$Res, $Val extends UserEntity>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? fullName = freezed,
    Object? profilePhotoUrl = freezed,
    Object? jobTitle = freezed,
    Object? departmentId = freezed,
    Object? departmentName = freezed,
    Object? reportingManagerId = freezed,
    Object? joinDate = freezed,
    Object? adminUser = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            fullName: freezed == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePhotoUrl: freezed == profilePhotoUrl
                ? _value.profilePhotoUrl
                : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            jobTitle: freezed == jobTitle
                ? _value.jobTitle
                : jobTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            departmentId: freezed == departmentId
                ? _value.departmentId
                : departmentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            departmentName: freezed == departmentName
                ? _value.departmentName
                : departmentName // ignore: cast_nullable_to_non_nullable
                      as String?,
            reportingManagerId: freezed == reportingManagerId
                ? _value.reportingManagerId
                : reportingManagerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            joinDate: freezed == joinDate
                ? _value.joinDate
                : joinDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            adminUser: freezed == adminUser
                ? _value.adminUser
                : adminUser // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserEntityImplCopyWith<$Res>
    implements $UserEntityCopyWith<$Res> {
  factory _$$UserEntityImplCopyWith(
    _$UserEntityImpl value,
    $Res Function(_$UserEntityImpl) then,
  ) = __$$UserEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: "user_id") String userId,
    String username,
    String? email,
    String? phone,
    String? fullName,
    String? profilePhotoUrl,
    String? jobTitle,
    String? departmentId,
    String? departmentName,
    String? reportingManagerId,
    DateTime? joinDate,
    @JsonKey(name: "admin_user") bool? adminUser,
  });
}

/// @nodoc
class __$$UserEntityImplCopyWithImpl<$Res>
    extends _$UserEntityCopyWithImpl<$Res, _$UserEntityImpl>
    implements _$$UserEntityImplCopyWith<$Res> {
  __$$UserEntityImplCopyWithImpl(
    _$UserEntityImpl _value,
    $Res Function(_$UserEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? fullName = freezed,
    Object? profilePhotoUrl = freezed,
    Object? jobTitle = freezed,
    Object? departmentId = freezed,
    Object? departmentName = freezed,
    Object? reportingManagerId = freezed,
    Object? joinDate = freezed,
    Object? adminUser = freezed,
  }) {
    return _then(
      _$UserEntityImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        fullName: freezed == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePhotoUrl: freezed == profilePhotoUrl
            ? _value.profilePhotoUrl
            : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        jobTitle: freezed == jobTitle
            ? _value.jobTitle
            : jobTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        departmentId: freezed == departmentId
            ? _value.departmentId
            : departmentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        departmentName: freezed == departmentName
            ? _value.departmentName
            : departmentName // ignore: cast_nullable_to_non_nullable
                  as String?,
        reportingManagerId: freezed == reportingManagerId
            ? _value.reportingManagerId
            : reportingManagerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        joinDate: freezed == joinDate
            ? _value.joinDate
            : joinDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        adminUser: freezed == adminUser
            ? _value.adminUser
            : adminUser // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserEntityImpl implements _UserEntity {
  const _$UserEntityImpl({
    @JsonKey(name: "user_id") required this.userId,
    required this.username,
    this.email,
    this.phone,
    this.fullName,
    this.profilePhotoUrl,
    this.jobTitle,
    this.departmentId,
    this.departmentName,
    this.reportingManagerId,
    this.joinDate,
    @JsonKey(name: "admin_user") this.adminUser,
  });

  factory _$UserEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserEntityImplFromJson(json);

  @override
  @JsonKey(name: "user_id")
  final String userId;
  @override
  final String username;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? fullName;
  @override
  final String? profilePhotoUrl;
  @override
  final String? jobTitle;
  @override
  final String? departmentId;
  @override
  final String? departmentName;
  @override
  final String? reportingManagerId;
  @override
  final DateTime? joinDate;
  @override
  @JsonKey(name: "admin_user")
  final bool? adminUser;

  @override
  String toString() {
    return 'UserEntity(userId: $userId, username: $username, email: $email, phone: $phone, fullName: $fullName, profilePhotoUrl: $profilePhotoUrl, jobTitle: $jobTitle, departmentId: $departmentId, departmentName: $departmentName, reportingManagerId: $reportingManagerId, joinDate: $joinDate, adminUser: $adminUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserEntityImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.departmentName, departmentName) ||
                other.departmentName == departmentName) &&
            (identical(other.reportingManagerId, reportingManagerId) ||
                other.reportingManagerId == reportingManagerId) &&
            (identical(other.joinDate, joinDate) ||
                other.joinDate == joinDate) &&
            (identical(other.adminUser, adminUser) ||
                other.adminUser == adminUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    username,
    email,
    phone,
    fullName,
    profilePhotoUrl,
    jobTitle,
    departmentId,
    departmentName,
    reportingManagerId,
    joinDate,
    adminUser,
  );

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      __$$UserEntityImplCopyWithImpl<_$UserEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserEntityImplToJson(this);
  }
}

abstract class _UserEntity implements UserEntity {
  const factory _UserEntity({
    @JsonKey(name: "user_id") required final String userId,
    required final String username,
    final String? email,
    final String? phone,
    final String? fullName,
    final String? profilePhotoUrl,
    final String? jobTitle,
    final String? departmentId,
    final String? departmentName,
    final String? reportingManagerId,
    final DateTime? joinDate,
    @JsonKey(name: "admin_user") final bool? adminUser,
  }) = _$UserEntityImpl;

  factory _UserEntity.fromJson(Map<String, dynamic> json) =
      _$UserEntityImpl.fromJson;

  @override
  @JsonKey(name: "user_id")
  String get userId;
  @override
  String get username;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get fullName;
  @override
  String? get profilePhotoUrl;
  @override
  String? get jobTitle;
  @override
  String? get departmentId;
  @override
  String? get departmentName;
  @override
  String? get reportingManagerId;
  @override
  DateTime? get joinDate;
  @override
  @JsonKey(name: "admin_user")
  bool? get adminUser;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
