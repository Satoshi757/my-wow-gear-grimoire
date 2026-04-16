import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_wow_gear_grimoire/core/errors/app_error.dart';
import 'package:my_wow_gear_grimoire/features/characters/data/repositories/characters_repository.dart';
import 'package:my_wow_gear_grimoire/features/characters/domain/models/character.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late CharactersRepository repo;

  final now = DateTime(2026, 4, 16);

  Character makeCharacter({
    String id = '',
    String ownerUid = 'uid_alice',
    String name = 'Aldariel',
    String classKey = 'priest',
    String raceKey = 'draenei',
    String mainSpec = 'discipline',
    bool isArchived = false,
  }) =>
      Character(
        id: id,
        ownerUid: ownerUid,
        name: name,
        classKey: classKey,
        raceKey: raceKey,
        factionKey: 'alliance',
        mainSpec: mainSpec,
        isArchived: isArchived,
        createdAt: now,
        updatedAt: now,
      );

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repo = CharactersRepository(firestore: fakeFirestore);
  });

  // ── save() ────────────────────────────────────────────────────────────────

  group('CharactersRepository.save()', () {
    test('crea un personaje nuevo y devuelve ID no vacío', () async {
      final id = await repo.save(makeCharacter());
      expect(id, isNotEmpty);
    });

    test('actualizar un personaje existente devuelve el mismo ID', () async {
      final id = await repo.save(makeCharacter());
      final updatedId = await repo.save(
        makeCharacter(id: id, name: 'Aldariel Editado'),
      );
      expect(updatedId, equals(id));
    });

    test('lanza ValidationError si name está vacío', () {
      expect(
        () => repo.save(makeCharacter(name: '')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si name es solo espacios', () {
      expect(
        () => repo.save(makeCharacter(name: '   ')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si ownerUid está vacío', () {
      expect(
        () => repo.save(makeCharacter(ownerUid: '')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si classKey no está en el catálogo', () {
      expect(
        () => repo.save(makeCharacter(classKey: 'death_knight')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si raceKey no está en el catálogo', () {
      expect(
        () => repo.save(makeCharacter(raceKey: 'worgen')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lanza ValidationError si mainSpec está vacío', () {
      expect(
        () => repo.save(makeCharacter(mainSpec: '')),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  // ── fetchById() ───────────────────────────────────────────────────────────

  group('CharactersRepository.fetchById()', () {
    test('devuelve null para un ID inexistente', () async {
      final result = await repo.fetchById('id_que_no_existe');
      expect(result, isNull);
    });

    test('devuelve el personaje correcto para un ID existente', () async {
      final id = await repo.save(makeCharacter());
      final result = await repo.fetchById(id);

      expect(result, isNotNull);
      expect(result!.id, equals(id));
      expect(result.name, equals('Aldariel'));
      expect(result.classKey, equals('priest'));
      expect(result.raceKey, equals('draenei'));
      expect(result.ownerUid, equals('uid_alice'));
    });
  });

  // ── watchAll() ────────────────────────────────────────────────────────────

  group('CharactersRepository.watchAll()', () {
    test('emite los personajes del ownerUid indicado', () async {
      await repo.save(makeCharacter(ownerUid: 'uid_alice', name: 'Aldariel'));
      await repo.save(makeCharacter(ownerUid: 'uid_bob', name: 'Thornix'));

      final list = await repo.watchAll('uid_alice').first;
      expect(list.length, equals(1));
      expect(list.first.name, equals('Aldariel'));
    });

    test('no emite personajes de otros usuarios', () async {
      await repo.save(makeCharacter(ownerUid: 'uid_alice'));
      await repo.save(makeCharacter(ownerUid: 'uid_bob'));

      final list = await repo.watchAll('uid_alice').first;
      expect(list.every((c) => c.ownerUid == 'uid_alice'), isTrue);
    });

    test('no emite personajes archivados', () async {
      await repo.save(makeCharacter(name: 'Activo'));
      await repo.save(makeCharacter(name: 'Archivado', isArchived: true));

      final list = await repo.watchAll('uid_alice').first;
      expect(list.every((c) => !c.isArchived), isTrue);
    });

    test('devuelve lista vacía si no hay personajes para el uid', () async {
      final list = await repo.watchAll('uid_sin_personajes').first;
      expect(list, isEmpty);
    });
  });
}
