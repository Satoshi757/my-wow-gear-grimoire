import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/characters_repository.dart';
import '../../domain/models/character.dart';

part 'characters_providers.g.dart';

@riverpod
CharactersRepository charactersRepository(CharactersRepositoryRef ref) {
  return CharactersRepository();
}

/// Stream de personajes del usuario autenticado.
/// Emite lista vacía si no hay sesión activa.
@riverpod
Stream<List<Character>> charactersStream(CharactersStreamRef ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return const Stream.empty();
  return ref.watch(charactersRepositoryProvider).watchAll(uid);
}

/// Carga puntual de un personaje por ID. Devuelve null si no existe.
@riverpod
Future<Character?> characterDetail(
  CharacterDetailRef ref,
  String characterId,
) {
  return ref.watch(charactersRepositoryProvider).fetchById(characterId);
}
