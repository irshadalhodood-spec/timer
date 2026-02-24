// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DepartmentEntity _$DepartmentEntityFromJson(Map<String, dynamic> json) {
  return _DepartmentEntity.fromJson(json);
}

/// @nodoc
mixin _$DepartmentEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get employeeCount => throw _privateConstructorUsedError;

  /// Serializes this DepartmentEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DepartmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DepartmentEntityCopyWith<DepartmentEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DepartmentEntityCopyWith<$Res> {
  factory $DepartmentEntityCopyWith(
    DepartmentEntity value,
    $Res Function(DepartmentEntity) then,
  ) = _$DepartmentEntityCopyWithImpl<$Res, DepartmentEntity>;
  @useResult
  $Res call({String id, String name, int? employeeCount});
}

/// @nodoc
class _$DepartmentEntityCopyWithImpl<$Res, $Val extends DepartmentEntity>
    implements $DepartmentEntityCopyWith<$Res> {
  _$DepartmentEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DepartmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? employeeCount = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            employeeCount: freezed == employeeCount
                ? _value.employeeCount
                : employeeCount // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DepartmentEntityImplCopyWith<$Res>
    implements $DepartmentEntityCopyWith<$Res> {
  factory _$$DepartmentEntityImplCopyWith(
    _$DepartmentEntityImpl value,
    $Res Function(_$DepartmentEntityImpl) then,
  ) = __$$DepartmentEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, int? employeeCount});
}

/// @nodoc
class __$$DepartmentEntityImplCopyWithImpl<$Res>
    extends _$DepartmentEntityCopyWithImpl<$Res, _$DepartmentEntityImpl>
    implements _$$DepartmentEntityImplCopyWith<$Res> {
  __$$DepartmentEntityImplCopyWithImpl(
    _$DepartmentEntityImpl _value,
    $Res Function(_$DepartmentEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DepartmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? employeeCount = freezed,
  }) {
    return _then(
      _$DepartmentEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeCount: freezed == employeeCount
            ? _value.employeeCount
            : employeeCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DepartmentEntityImpl implements _DepartmentEntity {
  const _$DepartmentEntityImpl({
    required this.id,
    required this.name,
    this.employeeCount,
  });

  factory _$DepartmentEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$DepartmentEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int? employeeCount;

  @override
  String toString() {
    return 'DepartmentEntity(id: $id, name: $name, employeeCount: $employeeCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DepartmentEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.employeeCount, employeeCount) ||
                other.employeeCount == employeeCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, employeeCount);

  /// Create a copy of DepartmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DepartmentEntityImplCopyWith<_$DepartmentEntityImpl> get copyWith =>
      __$$DepartmentEntityImplCopyWithImpl<_$DepartmentEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DepartmentEntityImplToJson(this);
  }
}

abstract class _DepartmentEntity implements DepartmentEntity {
  const factory _DepartmentEntity({
    required final String id,
    required final String name,
    final int? employeeCount,
  }) = _$DepartmentEntityImpl;

  factory _DepartmentEntity.fromJson(Map<String, dynamic> json) =
      _$DepartmentEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int? get employeeCount;

  /// Create a copy of DepartmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DepartmentEntityImplCopyWith<_$DepartmentEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrganizationEntity _$OrganizationEntityFromJson(Map<String, dynamic> json) {
  return _OrganizationEntity.fromJson(json);
}

/// @nodoc
mixin _$OrganizationEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get industry => throw _privateConstructorUsedError;
  String? get registeredAddress => throw _privateConstructorUsedError;
  int? get totalHeadcount => throw _privateConstructorUsedError;
  List<DepartmentEntity> get departments => throw _privateConstructorUsedError;

  /// Serializes this OrganizationEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrganizationEntityCopyWith<OrganizationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationEntityCopyWith<$Res> {
  factory $OrganizationEntityCopyWith(
    OrganizationEntity value,
    $Res Function(OrganizationEntity) then,
  ) = _$OrganizationEntityCopyWithImpl<$Res, OrganizationEntity>;
  @useResult
  $Res call({
    String id,
    String name,
    String? logoUrl,
    String? industry,
    String? registeredAddress,
    int? totalHeadcount,
    List<DepartmentEntity> departments,
  });
}

/// @nodoc
class _$OrganizationEntityCopyWithImpl<$Res, $Val extends OrganizationEntity>
    implements $OrganizationEntityCopyWith<$Res> {
  _$OrganizationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? industry = freezed,
    Object? registeredAddress = freezed,
    Object? totalHeadcount = freezed,
    Object? departments = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            industry: freezed == industry
                ? _value.industry
                : industry // ignore: cast_nullable_to_non_nullable
                      as String?,
            registeredAddress: freezed == registeredAddress
                ? _value.registeredAddress
                : registeredAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalHeadcount: freezed == totalHeadcount
                ? _value.totalHeadcount
                : totalHeadcount // ignore: cast_nullable_to_non_nullable
                      as int?,
            departments: null == departments
                ? _value.departments
                : departments // ignore: cast_nullable_to_non_nullable
                      as List<DepartmentEntity>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrganizationEntityImplCopyWith<$Res>
    implements $OrganizationEntityCopyWith<$Res> {
  factory _$$OrganizationEntityImplCopyWith(
    _$OrganizationEntityImpl value,
    $Res Function(_$OrganizationEntityImpl) then,
  ) = __$$OrganizationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? logoUrl,
    String? industry,
    String? registeredAddress,
    int? totalHeadcount,
    List<DepartmentEntity> departments,
  });
}

/// @nodoc
class __$$OrganizationEntityImplCopyWithImpl<$Res>
    extends _$OrganizationEntityCopyWithImpl<$Res, _$OrganizationEntityImpl>
    implements _$$OrganizationEntityImplCopyWith<$Res> {
  __$$OrganizationEntityImplCopyWithImpl(
    _$OrganizationEntityImpl _value,
    $Res Function(_$OrganizationEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? industry = freezed,
    Object? registeredAddress = freezed,
    Object? totalHeadcount = freezed,
    Object? departments = null,
  }) {
    return _then(
      _$OrganizationEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        industry: freezed == industry
            ? _value.industry
            : industry // ignore: cast_nullable_to_non_nullable
                  as String?,
        registeredAddress: freezed == registeredAddress
            ? _value.registeredAddress
            : registeredAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalHeadcount: freezed == totalHeadcount
            ? _value.totalHeadcount
            : totalHeadcount // ignore: cast_nullable_to_non_nullable
                  as int?,
        departments: null == departments
            ? _value._departments
            : departments // ignore: cast_nullable_to_non_nullable
                  as List<DepartmentEntity>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizationEntityImpl implements _OrganizationEntity {
  const _$OrganizationEntityImpl({
    required this.id,
    required this.name,
    this.logoUrl,
    this.industry,
    this.registeredAddress,
    this.totalHeadcount,
    final List<DepartmentEntity> departments = const [],
  }) : _departments = departments;

  factory _$OrganizationEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? logoUrl;
  @override
  final String? industry;
  @override
  final String? registeredAddress;
  @override
  final int? totalHeadcount;
  final List<DepartmentEntity> _departments;
  @override
  @JsonKey()
  List<DepartmentEntity> get departments {
    if (_departments is EqualUnmodifiableListView) return _departments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_departments);
  }

  @override
  String toString() {
    return 'OrganizationEntity(id: $id, name: $name, logoUrl: $logoUrl, industry: $industry, registeredAddress: $registeredAddress, totalHeadcount: $totalHeadcount, departments: $departments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.industry, industry) ||
                other.industry == industry) &&
            (identical(other.registeredAddress, registeredAddress) ||
                other.registeredAddress == registeredAddress) &&
            (identical(other.totalHeadcount, totalHeadcount) ||
                other.totalHeadcount == totalHeadcount) &&
            const DeepCollectionEquality().equals(
              other._departments,
              _departments,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    logoUrl,
    industry,
    registeredAddress,
    totalHeadcount,
    const DeepCollectionEquality().hash(_departments),
  );

  /// Create a copy of OrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationEntityImplCopyWith<_$OrganizationEntityImpl> get copyWith =>
      __$$OrganizationEntityImplCopyWithImpl<_$OrganizationEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizationEntityImplToJson(this);
  }
}

abstract class _OrganizationEntity implements OrganizationEntity {
  const factory _OrganizationEntity({
    required final String id,
    required final String name,
    final String? logoUrl,
    final String? industry,
    final String? registeredAddress,
    final int? totalHeadcount,
    final List<DepartmentEntity> departments,
  }) = _$OrganizationEntityImpl;

  factory _OrganizationEntity.fromJson(Map<String, dynamic> json) =
      _$OrganizationEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get logoUrl;
  @override
  String? get industry;
  @override
  String? get registeredAddress;
  @override
  int? get totalHeadcount;
  @override
  List<DepartmentEntity> get departments;

  /// Create a copy of OrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrganizationEntityImplCopyWith<_$OrganizationEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
