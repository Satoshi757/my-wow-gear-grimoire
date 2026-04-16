import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/catalogs/goal_priorities.dart';
import '../../../../core/catalogs/goal_statuses.dart';
import '../../../../core/catalogs/goal_types.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/models/goal.dart';
import '../dtos/goal_dto.dart';
import '../mappers/goal_mapper.dart';

class GoalsRepository {
  GoalsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<GoalDto> get _collection =>
      _firestore.collection('goals').withConverter<GoalDto>(
            fromFirestore: (snap, _) => GoalDto.fromJson(snap.data()!),
            toFirestore: (dto, _) => dto.toJson(),
          );

  /// Stream de objetivos activos de un personaje, ordenados por [updatedAt] desc.
  Stream<List<Goal>> watchByCharacter({
    required String ownerUid,
    required String characterId,
  }) {
    return _collection
        .where('ownerUid', isEqualTo: ownerUid)
        .where('characterId', isEqualTo: characterId)
        .where('isArchived', isEqualTo: false)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => GoalMapper.toDomain(doc.id, doc.data()))
              .toList(),
        )
        .handleError((Object error, StackTrace stack) {
          log(
            'Error en stream de objetivos',
            error: error,
            stackTrace: stack,
            name: 'GoalsRepository',
          );
          throw const FirestoreError('Error al cargar objetivos');
        });
  }

  /// Obtiene un objetivo por ID. Devuelve null si no existe.
  Future<Goal?> fetchById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return GoalMapper.toDomain(doc.id, doc.data()!);
    } on FirebaseException catch (e, stack) {
      log(
        'Error al obtener objetivo $id',
        error: e,
        stackTrace: stack,
        name: 'GoalsRepository',
      );
      throw const FirestoreError('Error al cargar el objetivo');
    }
  }

  /// Crea o actualiza un objetivo.
  /// Valida campos, catálogos y RB-09 antes de escribir.
  Future<String> save(Goal goal) async {
    _validate(goal);
    // RB-09: characterId debe apuntar a un personaje del mismo ownerUid.
    await _validateCharacterOwnership(goal.characterId, goal.ownerUid);

    try {
      final now = DateTime.now();
      if (goal.id.isEmpty) {
        final dto = GoalMapper.toDto(
          goal.copyWith(createdAt: now, updatedAt: now),
        );
        final ref = await _collection.add(dto);
        log('Objetivo creado: ${ref.id}', name: 'GoalsRepository');
        return ref.id;
      } else {
        final dto = GoalMapper.toDto(goal.copyWith(updatedAt: now));
        await _collection.doc(goal.id).set(dto);
        log('Objetivo actualizado: ${goal.id}', name: 'GoalsRepository');
        return goal.id;
      }
    } on FirebaseException catch (e, stack) {
      log(
        'Error al guardar objetivo',
        error: e,
        stackTrace: stack,
        name: 'GoalsRepository',
      );
      throw const FirestoreError('Error al guardar el objetivo');
    }
  }

  /// Valida campos obligatorios y valores de catálogo.
  /// Lanza [ValidationError] si alguno es inválido.
  void _validate(Goal goal) {
    if (goal.ownerUid.isEmpty) {
      throw const ValidationError('ownerUid es obligatorio');
    }
    if (goal.characterId.isEmpty) {
      throw const ValidationError('characterId es obligatorio');
    }
    if (goal.name.trim().isEmpty) {
      throw const ValidationError('El nombre del objetivo es obligatorio');
    }
    if (!goalTypes.contains(goal.type)) {
      throw ValidationError('type inválido: ${goal.type}');
    }
    if (!goalStatuses.contains(goal.status)) {
      throw ValidationError('status inválido: ${goal.status}');
    }
    if (!goalPriorities.contains(goal.priority)) {
      throw ValidationError('priority inválido: ${goal.priority}');
    }
  }

  /// Verifica que [characterId] pertenezca a [ownerUid] consultando Firestore.
  /// Lanza [ValidationError] si no se cumple.
  Future<void> _validateCharacterOwnership(
    String characterId,
    String ownerUid,
  ) async {
    try {
      final doc = await _firestore
          .collection('characters')
          .doc(characterId)
          .get();

      if (!doc.exists) {
        throw const ValidationError('El personaje no existe');
      }

      final data = doc.data();
      if (data == null || data['ownerUid'] != ownerUid) {
        throw const ValidationError(
          'El personaje no pertenece al usuario actual',
        );
      }
    } on ValidationError {
      rethrow;
    } on FirebaseException catch (e, stack) {
      log(
        'Error al validar ownership del personaje',
        error: e,
        stackTrace: stack,
        name: 'GoalsRepository',
      );
      throw const FirestoreError('Error al validar el personaje');
    }
  }
}
