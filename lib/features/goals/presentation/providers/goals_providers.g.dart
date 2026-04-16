// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goalsRepositoryHash() => r'abda782e1e3672ea41ab6d026855c67de9186541';

/// See also [goalsRepository].
@ProviderFor(goalsRepository)
final goalsRepositoryProvider = AutoDisposeProvider<GoalsRepository>.internal(
  goalsRepository,
  name: r'goalsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$goalsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoalsRepositoryRef = AutoDisposeProviderRef<GoalsRepository>;
String _$goalsStreamHash() => r'37283f0f6211ff80a73191d8605a0fa6a7a5092e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Stream de objetivos activos para un personaje concreto.
///
/// Copied from [goalsStream].
@ProviderFor(goalsStream)
const goalsStreamProvider = GoalsStreamFamily();

/// Stream de objetivos activos para un personaje concreto.
///
/// Copied from [goalsStream].
class GoalsStreamFamily extends Family<AsyncValue<List<Goal>>> {
  /// Stream de objetivos activos para un personaje concreto.
  ///
  /// Copied from [goalsStream].
  const GoalsStreamFamily();

  /// Stream de objetivos activos para un personaje concreto.
  ///
  /// Copied from [goalsStream].
  GoalsStreamProvider call({
    required String ownerUid,
    required String characterId,
  }) {
    return GoalsStreamProvider(ownerUid: ownerUid, characterId: characterId);
  }

  @override
  GoalsStreamProvider getProviderOverride(
    covariant GoalsStreamProvider provider,
  ) {
    return call(ownerUid: provider.ownerUid, characterId: provider.characterId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'goalsStreamProvider';
}

/// Stream de objetivos activos para un personaje concreto.
///
/// Copied from [goalsStream].
class GoalsStreamProvider extends AutoDisposeStreamProvider<List<Goal>> {
  /// Stream de objetivos activos para un personaje concreto.
  ///
  /// Copied from [goalsStream].
  GoalsStreamProvider({required String ownerUid, required String characterId})
    : this._internal(
        (ref) => goalsStream(
          ref as GoalsStreamRef,
          ownerUid: ownerUid,
          characterId: characterId,
        ),
        from: goalsStreamProvider,
        name: r'goalsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$goalsStreamHash,
        dependencies: GoalsStreamFamily._dependencies,
        allTransitiveDependencies: GoalsStreamFamily._allTransitiveDependencies,
        ownerUid: ownerUid,
        characterId: characterId,
      );

  GoalsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ownerUid,
    required this.characterId,
  }) : super.internal();

  final String ownerUid;
  final String characterId;

  @override
  Override overrideWith(
    Stream<List<Goal>> Function(GoalsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GoalsStreamProvider._internal(
        (ref) => create(ref as GoalsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ownerUid: ownerUid,
        characterId: characterId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Goal>> createElement() {
    return _GoalsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GoalsStreamProvider &&
        other.ownerUid == ownerUid &&
        other.characterId == characterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ownerUid.hashCode);
    hash = _SystemHash.combine(hash, characterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GoalsStreamRef on AutoDisposeStreamProviderRef<List<Goal>> {
  /// The parameter `ownerUid` of this provider.
  String get ownerUid;

  /// The parameter `characterId` of this provider.
  String get characterId;
}

class _GoalsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Goal>>
    with GoalsStreamRef {
  _GoalsStreamProviderElement(super.provider);

  @override
  String get ownerUid => (origin as GoalsStreamProvider).ownerUid;
  @override
  String get characterId => (origin as GoalsStreamProvider).characterId;
}

String _$goalDetailHash() => r'e56e69d34c8de811a58f1ed7e18b46b27d132373';

/// Carga puntual de un objetivo por ID. Devuelve null si no existe.
///
/// Copied from [goalDetail].
@ProviderFor(goalDetail)
const goalDetailProvider = GoalDetailFamily();

/// Carga puntual de un objetivo por ID. Devuelve null si no existe.
///
/// Copied from [goalDetail].
class GoalDetailFamily extends Family<AsyncValue<Goal?>> {
  /// Carga puntual de un objetivo por ID. Devuelve null si no existe.
  ///
  /// Copied from [goalDetail].
  const GoalDetailFamily();

  /// Carga puntual de un objetivo por ID. Devuelve null si no existe.
  ///
  /// Copied from [goalDetail].
  GoalDetailProvider call(String goalId) {
    return GoalDetailProvider(goalId);
  }

  @override
  GoalDetailProvider getProviderOverride(
    covariant GoalDetailProvider provider,
  ) {
    return call(provider.goalId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'goalDetailProvider';
}

/// Carga puntual de un objetivo por ID. Devuelve null si no existe.
///
/// Copied from [goalDetail].
class GoalDetailProvider extends AutoDisposeFutureProvider<Goal?> {
  /// Carga puntual de un objetivo por ID. Devuelve null si no existe.
  ///
  /// Copied from [goalDetail].
  GoalDetailProvider(String goalId)
    : this._internal(
        (ref) => goalDetail(ref as GoalDetailRef, goalId),
        from: goalDetailProvider,
        name: r'goalDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$goalDetailHash,
        dependencies: GoalDetailFamily._dependencies,
        allTransitiveDependencies: GoalDetailFamily._allTransitiveDependencies,
        goalId: goalId,
      );

  GoalDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.goalId,
  }) : super.internal();

  final String goalId;

  @override
  Override overrideWith(
    FutureOr<Goal?> Function(GoalDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GoalDetailProvider._internal(
        (ref) => create(ref as GoalDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        goalId: goalId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Goal?> createElement() {
    return _GoalDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GoalDetailProvider && other.goalId == goalId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, goalId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GoalDetailRef on AutoDisposeFutureProviderRef<Goal?> {
  /// The parameter `goalId` of this provider.
  String get goalId;
}

class _GoalDetailProviderElement extends AutoDisposeFutureProviderElement<Goal?>
    with GoalDetailRef {
  _GoalDetailProviderElement(super.provider);

  @override
  String get goalId => (origin as GoalDetailProvider).goalId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
