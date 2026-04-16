// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Character {
  /// ID del documento Firestore. Vacío ('') para personajes nuevos antes de guardar.
  String get id => throw _privateConstructorUsedError;
  String get ownerUid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get classKey => throw _privateConstructorUsedError;
  String get raceKey => throw _privateConstructorUsedError;

  /// Derivado de [raceKey]. Ver core/catalogs/race_to_faction.dart.
  String get factionKey => throw _privateConstructorUsedError;
  String get mainSpec => throw _privateConstructorUsedError;
  String? get secondarySpec => throw _privateConstructorUsedError;
  int? get level => throw _privateConstructorUsedError;
  String? get profession1 => throw _privateConstructorUsedError;
  String? get profession2 => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterCopyWith<Character> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCopyWith<$Res> {
  factory $CharacterCopyWith(Character value, $Res Function(Character) then) =
      _$CharacterCopyWithImpl<$Res, Character>;
  @useResult
  $Res call({
    String id,
    String ownerUid,
    String name,
    String classKey,
    String raceKey,
    String factionKey,
    String mainSpec,
    String? secondarySpec,
    int? level,
    String? profession1,
    String? profession2,
    String? notes,
    bool isArchived,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$CharacterCopyWithImpl<$Res, $Val extends Character>
    implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerUid = null,
    Object? name = null,
    Object? classKey = null,
    Object? raceKey = null,
    Object? factionKey = null,
    Object? mainSpec = null,
    Object? secondarySpec = freezed,
    Object? level = freezed,
    Object? profession1 = freezed,
    Object? profession2 = freezed,
    Object? notes = freezed,
    Object? isArchived = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerUid: null == ownerUid
                ? _value.ownerUid
                : ownerUid // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            classKey: null == classKey
                ? _value.classKey
                : classKey // ignore: cast_nullable_to_non_nullable
                      as String,
            raceKey: null == raceKey
                ? _value.raceKey
                : raceKey // ignore: cast_nullable_to_non_nullable
                      as String,
            factionKey: null == factionKey
                ? _value.factionKey
                : factionKey // ignore: cast_nullable_to_non_nullable
                      as String,
            mainSpec: null == mainSpec
                ? _value.mainSpec
                : mainSpec // ignore: cast_nullable_to_non_nullable
                      as String,
            secondarySpec: freezed == secondarySpec
                ? _value.secondarySpec
                : secondarySpec // ignore: cast_nullable_to_non_nullable
                      as String?,
            level: freezed == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int?,
            profession1: freezed == profession1
                ? _value.profession1
                : profession1 // ignore: cast_nullable_to_non_nullable
                      as String?,
            profession2: freezed == profession2
                ? _value.profession2
                : profession2 // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CharacterImplCopyWith<$Res>
    implements $CharacterCopyWith<$Res> {
  factory _$$CharacterImplCopyWith(
    _$CharacterImpl value,
    $Res Function(_$CharacterImpl) then,
  ) = __$$CharacterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ownerUid,
    String name,
    String classKey,
    String raceKey,
    String factionKey,
    String mainSpec,
    String? secondarySpec,
    int? level,
    String? profession1,
    String? profession2,
    String? notes,
    bool isArchived,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$CharacterImplCopyWithImpl<$Res>
    extends _$CharacterCopyWithImpl<$Res, _$CharacterImpl>
    implements _$$CharacterImplCopyWith<$Res> {
  __$$CharacterImplCopyWithImpl(
    _$CharacterImpl _value,
    $Res Function(_$CharacterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerUid = null,
    Object? name = null,
    Object? classKey = null,
    Object? raceKey = null,
    Object? factionKey = null,
    Object? mainSpec = null,
    Object? secondarySpec = freezed,
    Object? level = freezed,
    Object? profession1 = freezed,
    Object? profession2 = freezed,
    Object? notes = freezed,
    Object? isArchived = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$CharacterImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerUid: null == ownerUid
            ? _value.ownerUid
            : ownerUid // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        classKey: null == classKey
            ? _value.classKey
            : classKey // ignore: cast_nullable_to_non_nullable
                  as String,
        raceKey: null == raceKey
            ? _value.raceKey
            : raceKey // ignore: cast_nullable_to_non_nullable
                  as String,
        factionKey: null == factionKey
            ? _value.factionKey
            : factionKey // ignore: cast_nullable_to_non_nullable
                  as String,
        mainSpec: null == mainSpec
            ? _value.mainSpec
            : mainSpec // ignore: cast_nullable_to_non_nullable
                  as String,
        secondarySpec: freezed == secondarySpec
            ? _value.secondarySpec
            : secondarySpec // ignore: cast_nullable_to_non_nullable
                  as String?,
        level: freezed == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int?,
        profession1: freezed == profession1
            ? _value.profession1
            : profession1 // ignore: cast_nullable_to_non_nullable
                  as String?,
        profession2: freezed == profession2
            ? _value.profession2
            : profession2 // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$CharacterImpl implements _Character {
  const _$CharacterImpl({
    required this.id,
    required this.ownerUid,
    required this.name,
    required this.classKey,
    required this.raceKey,
    required this.factionKey,
    required this.mainSpec,
    this.secondarySpec,
    this.level,
    this.profession1,
    this.profession2,
    this.notes,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// ID del documento Firestore. Vacío ('') para personajes nuevos antes de guardar.
  @override
  final String id;
  @override
  final String ownerUid;
  @override
  final String name;
  @override
  final String classKey;
  @override
  final String raceKey;

  /// Derivado de [raceKey]. Ver core/catalogs/race_to_faction.dart.
  @override
  final String factionKey;
  @override
  final String mainSpec;
  @override
  final String? secondarySpec;
  @override
  final int? level;
  @override
  final String? profession1;
  @override
  final String? profession2;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Character(id: $id, ownerUid: $ownerUid, name: $name, classKey: $classKey, raceKey: $raceKey, factionKey: $factionKey, mainSpec: $mainSpec, secondarySpec: $secondarySpec, level: $level, profession1: $profession1, profession2: $profession2, notes: $notes, isArchived: $isArchived, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerUid, ownerUid) ||
                other.ownerUid == ownerUid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.classKey, classKey) ||
                other.classKey == classKey) &&
            (identical(other.raceKey, raceKey) || other.raceKey == raceKey) &&
            (identical(other.factionKey, factionKey) ||
                other.factionKey == factionKey) &&
            (identical(other.mainSpec, mainSpec) ||
                other.mainSpec == mainSpec) &&
            (identical(other.secondarySpec, secondarySpec) ||
                other.secondarySpec == secondarySpec) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.profession1, profession1) ||
                other.profession1 == profession1) &&
            (identical(other.profession2, profession2) ||
                other.profession2 == profession2) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ownerUid,
    name,
    classKey,
    raceKey,
    factionKey,
    mainSpec,
    secondarySpec,
    level,
    profession1,
    profession2,
    notes,
    isArchived,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      __$$CharacterImplCopyWithImpl<_$CharacterImpl>(this, _$identity);
}

abstract class _Character implements Character {
  const factory _Character({
    required final String id,
    required final String ownerUid,
    required final String name,
    required final String classKey,
    required final String raceKey,
    required final String factionKey,
    required final String mainSpec,
    final String? secondarySpec,
    final int? level,
    final String? profession1,
    final String? profession2,
    final String? notes,
    final bool isArchived,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$CharacterImpl;

  /// ID del documento Firestore. Vacío ('') para personajes nuevos antes de guardar.
  @override
  String get id;
  @override
  String get ownerUid;
  @override
  String get name;
  @override
  String get classKey;
  @override
  String get raceKey;

  /// Derivado de [raceKey]. Ver core/catalogs/race_to_faction.dart.
  @override
  String get factionKey;
  @override
  String get mainSpec;
  @override
  String? get secondarySpec;
  @override
  int? get level;
  @override
  String? get profession1;
  @override
  String? get profession2;
  @override
  String? get notes;
  @override
  bool get isArchived;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
