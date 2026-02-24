// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EmployeeEntity _$EmployeeEntityFromJson(Map<String, dynamic> json) {
  return _EmployeeEntity.fromJson(json);
}

/// @nodoc
mixin _$EmployeeEntity {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get jobTitle => throw _privateConstructorUsedError;
  String? get departmentId => throw _privateConstructorUsedError;
  String? get departmentName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get profilePhotoUrl => throw _privateConstructorUsedError;
  DateTime? get joinDate => throw _privateConstructorUsedError;
  String? get reportingManagerId => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  EmployeeEntity? get reportingManager => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;

  /// Serializes this EmployeeEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeEntityCopyWith<EmployeeEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeEntityCopyWith<$Res> {
  factory $EmployeeEntityCopyWith(
    EmployeeEntity value,
    $Res Function(EmployeeEntity) then,
  ) = _$EmployeeEntityCopyWithImpl<$Res, EmployeeEntity>;
  @useResult
  $Res call({
    String id,
    String fullName,
    String? jobTitle,
    String? departmentId,
    String? departmentName,
    String? email,
    String? phone,
    String? profilePhotoUrl,
    DateTime? joinDate,
    String? reportingManagerId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    EmployeeEntity? reportingManager,
    bool isOnline,
  });

  $EmployeeEntityCopyWith<$Res>? get reportingManager;
}

/// @nodoc
class _$EmployeeEntityCopyWithImpl<$Res, $Val extends EmployeeEntity>
    implements $EmployeeEntityCopyWith<$Res> {
  _$EmployeeEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? jobTitle = freezed,
    Object? departmentId = freezed,
    Object? departmentName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? profilePhotoUrl = freezed,
    Object? joinDate = freezed,
    Object? reportingManagerId = freezed,
    Object? reportingManager = freezed,
    Object? isOnline = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
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
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePhotoUrl: freezed == profilePhotoUrl
                ? _value.profilePhotoUrl
                : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            joinDate: freezed == joinDate
                ? _value.joinDate
                : joinDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reportingManagerId: freezed == reportingManagerId
                ? _value.reportingManagerId
                : reportingManagerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            reportingManager: freezed == reportingManager
                ? _value.reportingManager
                : reportingManager // ignore: cast_nullable_to_non_nullable
                      as EmployeeEntity?,
            isOnline: null == isOnline
                ? _value.isOnline
                : isOnline // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmployeeEntityCopyWith<$Res>? get reportingManager {
    if (_value.reportingManager == null) {
      return null;
    }

    return $EmployeeEntityCopyWith<$Res>(_value.reportingManager!, (value) {
      return _then(_value.copyWith(reportingManager: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EmployeeEntityImplCopyWith<$Res>
    implements $EmployeeEntityCopyWith<$Res> {
  factory _$$EmployeeEntityImplCopyWith(
    _$EmployeeEntityImpl value,
    $Res Function(_$EmployeeEntityImpl) then,
  ) = __$$EmployeeEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fullName,
    String? jobTitle,
    String? departmentId,
    String? departmentName,
    String? email,
    String? phone,
    String? profilePhotoUrl,
    DateTime? joinDate,
    String? reportingManagerId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    EmployeeEntity? reportingManager,
    bool isOnline,
  });

  @override
  $EmployeeEntityCopyWith<$Res>? get reportingManager;
}

/// @nodoc
class __$$EmployeeEntityImplCopyWithImpl<$Res>
    extends _$EmployeeEntityCopyWithImpl<$Res, _$EmployeeEntityImpl>
    implements _$$EmployeeEntityImplCopyWith<$Res> {
  __$$EmployeeEntityImplCopyWithImpl(
    _$EmployeeEntityImpl _value,
    $Res Function(_$EmployeeEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? jobTitle = freezed,
    Object? departmentId = freezed,
    Object? departmentName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? profilePhotoUrl = freezed,
    Object? joinDate = freezed,
    Object? reportingManagerId = freezed,
    Object? reportingManager = freezed,
    Object? isOnline = null,
  }) {
    return _then(
      _$EmployeeEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
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
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePhotoUrl: freezed == profilePhotoUrl
            ? _value.profilePhotoUrl
            : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        joinDate: freezed == joinDate
            ? _value.joinDate
            : joinDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reportingManagerId: freezed == reportingManagerId
            ? _value.reportingManagerId
            : reportingManagerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reportingManager: freezed == reportingManager
            ? _value.reportingManager
            : reportingManager // ignore: cast_nullable_to_non_nullable
                  as EmployeeEntity?,
        isOnline: null == isOnline
            ? _value.isOnline
            : isOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeEntityImpl implements _EmployeeEntity {
  const _$EmployeeEntityImpl({
    required this.id,
    required this.fullName,
    this.jobTitle,
    this.departmentId,
    this.departmentName,
    this.email,
    this.phone,
    this.profilePhotoUrl,
    this.joinDate,
    this.reportingManagerId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    this.reportingManager,
    this.isOnline = false,
  });

  factory _$EmployeeEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String? jobTitle;
  @override
  final String? departmentId;
  @override
  final String? departmentName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? profilePhotoUrl;
  @override
  final DateTime? joinDate;
  @override
  final String? reportingManagerId;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final EmployeeEntity? reportingManager;
  @override
  @JsonKey()
  final bool isOnline;

  @override
  String toString() {
    return 'EmployeeEntity(id: $id, fullName: $fullName, jobTitle: $jobTitle, departmentId: $departmentId, departmentName: $departmentName, email: $email, phone: $phone, profilePhotoUrl: $profilePhotoUrl, joinDate: $joinDate, reportingManagerId: $reportingManagerId, reportingManager: $reportingManager, isOnline: $isOnline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.departmentName, departmentName) ||
                other.departmentName == departmentName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            (identical(other.joinDate, joinDate) ||
                other.joinDate == joinDate) &&
            (identical(other.reportingManagerId, reportingManagerId) ||
                other.reportingManagerId == reportingManagerId) &&
            (identical(other.reportingManager, reportingManager) ||
                other.reportingManager == reportingManager) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fullName,
    jobTitle,
    departmentId,
    departmentName,
    email,
    phone,
    profilePhotoUrl,
    joinDate,
    reportingManagerId,
    reportingManager,
    isOnline,
  );

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeEntityImplCopyWith<_$EmployeeEntityImpl> get copyWith =>
      __$$EmployeeEntityImplCopyWithImpl<_$EmployeeEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeEntityImplToJson(this);
  }
}

abstract class _EmployeeEntity implements EmployeeEntity {
  const factory _EmployeeEntity({
    required final String id,
    required final String fullName,
    final String? jobTitle,
    final String? departmentId,
    final String? departmentName,
    final String? email,
    final String? phone,
    final String? profilePhotoUrl,
    final DateTime? joinDate,
    final String? reportingManagerId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final EmployeeEntity? reportingManager,
    final bool isOnline,
  }) = _$EmployeeEntityImpl;

  factory _EmployeeEntity.fromJson(Map<String, dynamic> json) =
      _$EmployeeEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String? get jobTitle;
  @override
  String? get departmentId;
  @override
  String? get departmentName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get profilePhotoUrl;
  @override
  DateTime? get joinDate;
  @override
  String? get reportingManagerId;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  EmployeeEntity? get reportingManager;
  @override
  bool get isOnline;

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeEntityImplCopyWith<_$EmployeeEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
