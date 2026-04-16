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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
