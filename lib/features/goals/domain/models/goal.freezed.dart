// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Goal {
  /// ID del documento Firestore. Vacío ('') para objetivos nuevos antes de guardar.
  String get id => throw _privateConstructorUsedError;
  String get ownerUid => throw _privateConstructorUsedError;
  String get characterId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String? get slot => throw _privateConstructorUsedError;
  String? get externalSource => throw _privateConstructorUsedError;
  String? get externalSourceId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get externalPayloadSnapshot =>
      throw _privateConstructorUsedError;
  String? get sourceText => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalCopyWith<Goal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) then) =
      _$GoalCopyWithImpl<$Res, Goal>;
  @useResult
  $Res call({
    String id,
    String ownerUid,
    String characterId,
    String type,
    String name,
    String status,
    String priority,
    String? slot,
    String? externalSource,
    String? externalSourceId,
    Map<String, dynamic>? externalPayloadSnapshot,
    String? sourceText,
    String? note,
    bool isArchived,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$GoalCopyWithImpl<$Res, $Val extends Goal>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerUid = null,
    Object? characterId = null,
    Object? type = null,
    Object? name = null,
    Object? status = null,
    Object? priority = null,
    Object? slot = freezed,
    Object? externalSource = freezed,
    Object? externalSourceId = freezed,
    Object? externalPayloadSnapshot = freezed,
    Object? sourceText = freezed,
    Object? note = freezed,
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
            characterId: null == characterId
                ? _value.characterId
                : characterId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
            slot: freezed == slot
                ? _value.slot
                : slot // ignore: cast_nullable_to_non_nullable
                      as String?,
            externalSource: freezed == externalSource
                ? _value.externalSource
                : externalSource // ignore: cast_nullable_to_non_nullable
                      as String?,
            externalSourceId: freezed == externalSourceId
                ? _value.externalSourceId
                : externalSourceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            externalPayloadSnapshot: freezed == externalPayloadSnapshot
                ? _value.externalPayloadSnapshot
                : externalPayloadSnapshot // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            sourceText: freezed == sourceText
                ? _value.sourceText
                : sourceText // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
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
abstract class _$$GoalImplCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$$GoalImplCopyWith(
    _$GoalImpl value,
    $Res Function(_$GoalImpl) then,
  ) = __$$GoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ownerUid,
    String characterId,
    String type,
    String name,
    String status,
    String priority,
    String? slot,
    String? externalSource,
    String? externalSourceId,
    Map<String, dynamic>? externalPayloadSnapshot,
    String? sourceText,
    String? note,
    bool isArchived,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$GoalImplCopyWithImpl<$Res>
    extends _$GoalCopyWithImpl<$Res, _$GoalImpl>
    implements _$$GoalImplCopyWith<$Res> {
  __$$GoalImplCopyWithImpl(_$GoalImpl _value, $Res Function(_$GoalImpl) _then)
    : super(_value, _then);

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerUid = null,
    Object? characterId = null,
    Object? type = null,
    Object? name = null,
    Object? status = null,
    Object? priority = null,
    Object? slot = freezed,
    Object? externalSource = freezed,
    Object? externalSourceId = freezed,
    Object? externalPayloadSnapshot = freezed,
    Object? sourceText = freezed,
    Object? note = freezed,
    Object? isArchived = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$GoalImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerUid: null == ownerUid
            ? _value.ownerUid
            : ownerUid // ignore: cast_nullable_to_non_nullable
                  as String,
        characterId: null == characterId
            ? _value.characterId
            : characterId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        slot: freezed == slot
            ? _value.slot
            : slot // ignore: cast_nullable_to_non_nullable
                  as String?,
        externalSource: freezed == externalSource
            ? _value.externalSource
            : externalSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        externalSourceId: freezed == externalSourceId
            ? _value.externalSourceId
            : externalSourceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        externalPayloadSnapshot: freezed == externalPayloadSnapshot
            ? _value._externalPayloadSnapshot
            : externalPayloadSnapshot // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        sourceText: freezed == sourceText
            ? _value.sourceText
            : sourceText // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
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

class _$GoalImpl implements _Goal {
  const _$GoalImpl({
    required this.id,
    required this.ownerUid,
    required this.characterId,
    required this.type,
    required this.name,
    required this.status,
    required this.priority,
    this.slot,
    this.externalSource,
    this.externalSourceId,
    final Map<String, dynamic>? externalPayloadSnapshot,
    this.sourceText,
    this.note,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  }) : _externalPayloadSnapshot = externalPayloadSnapshot;

  /// ID del documento Firestore. Vacío ('') para objetivos nuevos antes de guardar.
  @override
  final String id;
  @override
  final String ownerUid;
  @override
  final String characterId;
  @override
  final String type;
  @override
  final String name;
  @override
  final String status;
  @override
  final String priority;
  @override
  final String? slot;
  @override
  final String? externalSource;
  @override
  final String? externalSourceId;
  final Map<String, dynamic>? _externalPayloadSnapshot;
  @override
  Map<String, dynamic>? get externalPayloadSnapshot {
    final value = _externalPayloadSnapshot;
    if (value == null) return null;
    if (_externalPayloadSnapshot is EqualUnmodifiableMapView)
      return _externalPayloadSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? sourceText;
  @override
  final String? note;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Goal(id: $id, ownerUid: $ownerUid, characterId: $characterId, type: $type, name: $name, status: $status, priority: $priority, slot: $slot, externalSource: $externalSource, externalSourceId: $externalSourceId, externalPayloadSnapshot: $externalPayloadSnapshot, sourceText: $sourceText, note: $note, isArchived: $isArchived, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerUid, ownerUid) ||
                other.ownerUid == ownerUid) &&
            (identical(other.characterId, characterId) ||
                other.characterId == characterId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.slot, slot) || other.slot == slot) &&
            (identical(other.externalSource, externalSource) ||
                other.externalSource == externalSource) &&
            (identical(other.externalSourceId, externalSourceId) ||
                other.externalSourceId == externalSourceId) &&
            const DeepCollectionEquality().equals(
              other._externalPayloadSnapshot,
              _externalPayloadSnapshot,
            ) &&
            (identical(other.sourceText, sourceText) ||
                other.sourceText == sourceText) &&
            (identical(other.note, note) || other.note == note) &&
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
    characterId,
    type,
    name,
    status,
    priority,
    slot,
    externalSource,
    externalSourceId,
    const DeepCollectionEquality().hash(_externalPayloadSnapshot),
    sourceText,
    note,
    isArchived,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      __$$GoalImplCopyWithImpl<_$GoalImpl>(this, _$identity);
}

abstract class _Goal implements Goal {
  const factory _Goal({
    required final String id,
    required final String ownerUid,
    required final String characterId,
    required final String type,
    required final String name,
    required final String status,
    required final String priority,
    final String? slot,
    final String? externalSource,
    final String? externalSourceId,
    final Map<String, dynamic>? externalPayloadSnapshot,
    final String? sourceText,
    final String? note,
    final bool isArchived,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$GoalImpl;

  /// ID del documento Firestore. Vacío ('') para objetivos nuevos antes de guardar.
  @override
  String get id;
  @override
  String get ownerUid;
  @override
  String get characterId;
  @override
  String get type;
  @override
  String get name;
  @override
  String get status;
  @override
  String get priority;
  @override
  String? get slot;
  @override
  String? get externalSource;
  @override
  String? get externalSourceId;
  @override
  Map<String, dynamic>? get externalPayloadSnapshot;
  @override
  String? get sourceText;
  @override
  String? get note;
  @override
  bool get isArchived;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
