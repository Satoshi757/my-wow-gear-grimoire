import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_wow_gear_grimoire/core/errors/app_error.dart';
import 'package:my_wow_gear_grimoire/features/characters/data/repositories/characters_repository.dart';
import 'package:my_wow_gear_grimoire/features/characters/domain/models/character.dart';
import 'package:my_wow_gear_grimoire/features/goals/data/repositories/goals_repository.dart';
import 'package:my_wow_gear_grimoire/features/goals/domain/models/goal.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late CharactersRepository charactersRepo;
  late GoalsRepository goalsRepo;

  final now = DateTime(2026, 4, 16);

  Character makeCharacter({
    String ownerUid = 'uid_alice',
    String name = 'Aldariel',
  }) =>
      Character(
        id: '',
        ownerUid: ownerUid,
        name: name,
        classKey: 'priest',
        raceKey: 'draenei',
        factionKey: 'alliance',
        mainSpec: 'discipline',
        isArchived: false,
        createdAt: now,
        updatedAt: now,
      );

  Goal makeGoal({
    String id = '',
    String ownerUid = 'uid_alice',
    required String characterId,
    String type = 'gear',
    String name = 'Hauberk of the War Bringer',
    String status = 'pending',
    String priority = 'high',
    bool isArchived = false,
  }) =>
      Goal(
        id: id,
        ownerUid: ownerUid,
        characterId: characterId,
        type: type,
        name: name,
        status: status,
        priority: priority,
        isArchived: isArchived,
        createdAt: now,
        updatedAt: now,
      );

  setUp(() {
    // Misma instancia para que _validateCharacterOwnership encuentre el personaje.
    fakeFirestore = FakeFirebaseFirestore();
    charactersRepo = CharactersRepository(firestore: fakeFirestore);
    goalsRepo = GoalsRepository(firestore: fakeFirestore);
  });

  // ── save() ────────────────────────────────────────────────────────────────

  group('GoalsRepository.save() — éxito', () {
    test('crea un objetivo nuevo y devuelve ID no vacío', () async {
      final charId = await charactersRepo.save(makeCharacter());
      final goalId = await goalsRepo.save(makeGoal(characterId: charId));
      expect(goalId, isNotEmpty);
    });

    test('actualizar un objetivo existente devuelve el mismo ID', () async {
      final charId = await charactersRepo.save(makeCharacter());
      final goalId = await goalsRepo.save(makeGoal(characterId: charId));

      final updatedId = await goalsRepo.save(
        makeGoal(id: goalId, characterId: charId, name: 'Editado'),
      );
      expect(updatedId, equals(goalId));
    });
  });

  group('GoalsRepository.save() — validaciones de campos', () {
    late String charId;

    setUp(() async {
      charId = await charactersRepo.save(makeCharacter());
    });

    test('lanza ValidationError si name está vacío', () {
      expect(
        () => goalsRepo.save(makeGoal(characterId: charId, name: '')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si ownerUid está vacío', () {
      expect(
        () => goalsRepo.save(makeGoal(characterId: charId, ownerUid: '')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si characterId está vacío', () {
      expect(
        () => goalsRepo.save(makeGoal(characterId: '')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si type no está en el catálogo', () {
      expect(
        () => goalsRepo.save(makeGoal(characterId: charId, type: 'potion')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si status no está en el catálogo', () {
      expect(
        () => goalsRepo.save(makeGoal(characterId: charId, status: 'done')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si priority no está en el catálogo', () {
      expect(
        () => goalsRepo.save(makeGoal(characterId: charId, priority: 'urgent')),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  group('GoalsRepository.save() — RB-09 (ownership del personaje)', () {
    test('lanza ValidationError si characterId no existe en Firestore', () async {
      expect(
        () => goalsRepo.save(makeGoal(characterId: 'char_inexistente')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si el personaje pertenece a otro usuario', () async {
      // Personaje de Bob
      final bobCharId = await charactersRepo.save(
        makeCharacter(ownerUid: 'uid_bob'),
      );
      // Alice intenta crear un objetivo apuntando al personaje de Bob
      expect(
        () => goalsRepo.save(
          makeGoal(ownerUid: 'uid_alice', characterId: bobCharId),
        ),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  // ── fetchById() ───────────────────────────────────────────────────────────

  group('GoalsRepository.fetchById()', () {
    test('devuelve null para un ID inexistente', () async {
      final result = await goalsRepo.fetchById('id_que_no_existe');
      expect(result, isNull);
    });

    test('devuelve el objetivo correcto para un ID existente', () async {
      final charId = await charactersRepo.save(makeCharacter());
      final goalId = await goalsRepo.save(makeGoal(characterId: charId));
      final result = await goalsRepo.fetchById(goalId);

      expect(result, isNotNull);
      expect(result!.id, equals(goalId));
      expect(result.name, equals('Hauberk of the War Bringer'));
      expect(result.type, equals('gear'));
      expect(result.status, equals('pending'));
      expect(result.characterId, equals(charId));
    });
  });

  // ── watchByCharacter() ────────────────────────────────────────────────────

  group('GoalsRepository.watchByCharacter()', () {
    test('emite los objetivos del personaje indicado', () async {
      final charIdA = await charactersRepo.save(makeCharacter(name: 'Aldariel'));
      final charIdB = await charactersRepo.save(makeCharacter(name: 'Thornix'));

      await goalsRepo.save(makeGoal(characterId: charIdA, name: 'Objetivo A'));
      await goalsRepo.save(makeGoal(characterId: charIdB, name: 'Objetivo B'));

      final list = await goalsRepo
          .watchByCharacter(ownerUid: 'uid_alice', characterId: charIdA)
          .first;
      expect(list.length, equals(1));
      expect(list.first.name, equals('Objetivo A'));
    });

    test('no emite objetivos archivados', () async {
      final charId = await charactersRepo.save(makeCharacter());
      await goalsRepo.save(makeGoal(characterId: charId, name: 'Activo'));
      await goalsRepo.save(
        makeGoal(characterId: charId, name: 'Archivado', isArchived: true),
      );

      final list = await goalsRepo
          .watchByCharacter(ownerUid: 'uid_alice', characterId: charId)
          .first;
      expect(list.every((g) => !g.isArchived), isTrue);
    });

    test('devuelve lista vacía si no hay objetivos para el personaje', () async {
      final charId = await charactersRepo.save(makeCharacter());
      final list = await goalsRepo
          .watchByCharacter(ownerUid: 'uid_alice', characterId: charId)
          .first;
      expect(list, isEmpty);
    });
  });
}
