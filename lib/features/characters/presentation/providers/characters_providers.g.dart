// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'characters_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$charactersRepositoryHash() =>
    r'ca0343879654d9c78bd021e551c7fc85dba95234';

/// See also [charactersRepository].
@ProviderFor(charactersRepository)
final charactersRepositoryProvider =
    AutoDisposeProvider<CharactersRepository>.internal(
      charactersRepository,
      name: r'charactersRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$charactersRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CharactersRepositoryRef = AutoDisposeProviderRef<CharactersRepository>;
String _$charactersStreamHash() => r'9e28763afa60478f7ae73cd8ee46843ad8f6c4fc';

/// Stream de personajes del usuario autenticado.
/// Emite lista vacía si no hay sesión activa.
///
/// Copied from [charactersStream].
@ProviderFor(charactersStream)
final charactersStreamProvider =
    AutoDisposeStreamProvider<List<Character>>.internal(
      charactersStream,
      name: r'charactersStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$charactersStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CharactersStreamRef = AutoDisposeStreamProviderRef<List<Character>>;
String _$characterDetailHash() => r'032e7862c88266319d28b62d10a9a760c74ee9af';

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

/// Carga puntual de un personaje por ID. Devuelve null si no existe.
///
/// Copied from [characterDetail].
@ProviderFor(characterDetail)
const characterDetailProvider = CharacterDetailFamily();

/// Carga puntual de un personaje por ID. Devuelve null si no existe.
///
/// Copied from [characterDetail].
class CharacterDetailFamily extends Family<AsyncValue<Character?>> {
  /// Carga puntual de un personaje por ID. Devuelve null si no existe.
  ///
  /// Copied from [characterDetail].
  const CharacterDetailFamily();

  /// Carga puntual de un personaje por ID. Devuelve null si no existe.
  ///
  /// Copied from [characterDetail].
  CharacterDetailProvider call(String characterId) {
    return CharacterDetailProvider(characterId);
  }

  @override
  CharacterDetailProvider getProviderOverride(
    covariant CharacterDetailProvider provider,
  ) {
    return call(provider.characterId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'characterDetailProvider';
}

/// Carga puntual de un personaje por ID. Devuelve null si no existe.
///
/// Copied from [characterDetail].
class CharacterDetailProvider extends AutoDisposeFutureProvider<Character?> {
  /// Carga puntual de un personaje por ID. Devuelve null si no existe.
  ///
  /// Copied from [characterDetail].
  CharacterDetailProvider(String characterId)
    : this._internal(
        (ref) => characterDetail(ref as CharacterDetailRef, characterId),
        from: characterDetailProvider,
        name: r'characterDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$characterDetailHash,
        dependencies: CharacterDetailFamily._dependencies,
        allTransitiveDependencies:
            CharacterDetailFamily._allTransitiveDependencies,
        characterId: characterId,
      );

  CharacterDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.characterId,
  }) : super.internal();

  final String characterId;

  @override
  Override overrideWith(
    FutureOr<Character?> Function(CharacterDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CharacterDetailProvider._internal(
        (ref) => create(ref as CharacterDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        characterId: characterId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Character?> createElement() {
    return _CharacterDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CharacterDetailProvider && other.characterId == characterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, characterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CharacterDetailRef on AutoDisposeFutureProviderRef<Character?> {
  /// The parameter `characterId` of this provider.
  String get characterId;
}

class _CharacterDetailProviderElement
    extends AutoDisposeFutureProviderElement<Character?>
    with CharacterDetailRef {
  _CharacterDetailProviderElement(super.provider);

  @override
  String get characterId => (origin as CharacterDetailProvider).characterId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
