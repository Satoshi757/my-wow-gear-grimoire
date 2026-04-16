import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/catalogs/wow_classes.dart';
import '../../../../core/catalogs/wow_races.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/models/character.dart';
import '../dtos/character_dto.dart';
import '../mappers/character_mapper.dart';

class CharactersRepository {
  CharactersRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<CharacterDto> get _collection =>
      _firestore.collection('characters').withConverter<CharacterDto>(
            fromFirestore: (snap, _) => CharacterDto.fromJson(snap.data()!),
            toFirestore: (dto, _) => dto.toJson(),
          );

  /// Stream de personajes activos del usuario, ordenados por [updatedAt] desc.
  Stream<List<Character>> watchAll(String ownerUid) {
    return _collection
        .where('ownerUid', isEqualTo: ownerUid)
        .where('isArchived', isEqualTo: false)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => CharacterMapper.toDomain(doc.id, doc.data()))
              .toList(),
        )
        .handleError((Object error, StackTrace stack) {
          log(
            'Error en stream de personajes',
            error: error,
            stackTrace: stack,
            name: 'CharactersRepository',
          );
          throw const FirestoreError('Error al cargar personajes');
        });
  }

  /// Obtiene un personaje por ID. Devuelve null si no existe.
  Future<Character?> fetchById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return CharacterMapper.toDomain(doc.id, doc.data()!);
    } on FirebaseException catch (e, stack) {
      log(
        'Error al obtener personaje $id',
        error: e,
        stackTrace: stack,
        name: 'CharactersRepository',
      );
      throw const FirestoreError('Error al cargar el personaje');
    }
  }

  /// Crea o actualiza un personaje.
  /// Si [character.id] está vacío, crea y devuelve el ID generado.
  /// Si tiene ID, actualiza y devuelve el mismo ID.
  Future<String> save(Character character) async {
    _validate(character);
    try {
      final now = DateTime.now();
      if (character.id.isEmpty) {
        final dto = CharacterMapper.toDto(
          character.copyWith(createdAt: now, updatedAt: now),
        );
        final ref = await _collection.add(dto);
        log('Personaje creado: ${ref.id}', name: 'CharactersRepository');
        return ref.id;
      } else {
        final dto = CharacterMapper.toDto(character.copyWith(updatedAt: now));
        await _collection.doc(character.id).set(dto);
        log('Personaje actualizado: ${character.id}', name: 'CharactersRepository');
        return character.id;
      }
    } on FirebaseException catch (e, stack) {
      log(
        'Error al guardar personaje',
        error: e,
        stackTrace: stack,
        name: 'CharactersRepository',
      );
      throw const FirestoreError('Error al guardar el personaje');
    }
  }

  /// Valida los campos obligatorios y catálogos antes de escribir.
  /// Lanza [ValidationError] si alguno es inválido.
  void _validate(Character character) {
    if (character.ownerUid.isEmpty) {
      throw const ValidationError('ownerUid es obligatorio');
    }
    if (character.name.trim().isEmpty) {
      throw const ValidationError('El nombre del personaje es obligatorio');
    }
    if (!wowClasses.contains(character.classKey)) {
      throw ValidationError('classKey inválido: ${character.classKey}');
    }
    if (!wowRaces.contains(character.raceKey)) {
      throw ValidationError('raceKey inválido: ${character.raceKey}');
    }
    if (character.mainSpec.trim().isEmpty) {
      throw const ValidationError('La especialización principal es obligatoria');
    }
  }
}
