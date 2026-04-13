import 'package:flutter_test/flutter_test.dart';
import 'package:my_wow_gear_grimoire/features/characters/data/dtos/character_dto.dart';
import 'package:my_wow_gear_grimoire/features/characters/data/mappers/character_mapper.dart';
import 'package:my_wow_gear_grimoire/features/characters/domain/models/character.dart';

void main() {
  final now = DateTime(2026, 4, 12);

  final testDto = CharacterDto(
    ownerUid: 'uid_test',
    name: 'Aldariel',
    classKey: 'priest',
    raceKey: 'draenei',
    factionKey: 'alliance',
    mainSpec: 'discipline',
    secondarySpec: 'holy',
    level: 70,
    profession1: 'tailoring',
    profession2: 'enchanting',
    notes: 'Main healer arena',
    isArchived: false,
    createdAt: now,
    updatedAt: now,
  );

  final testCharacter = Character(
    id: 'char_001',
    ownerUid: 'uid_test',
    name: 'Aldariel',
    classKey: 'priest',
    raceKey: 'draenei',
    factionKey: 'alliance',
    mainSpec: 'discipline',
    secondarySpec: 'holy',
    level: 70,
    profession1: 'tailoring',
    profession2: 'enchanting',
    notes: 'Main healer arena',
    isArchived: false,
    createdAt: now,
    updatedAt: now,
  );

  group('CharacterMapper.toDomain', () {
    test('mapea todos los campos correctamente', () {
      final result = CharacterMapper.toDomain('char_001', testDto);
      expect(result, testCharacter);
    });

    test('id viene del parámetro, no del DTO', () {
      final result = CharacterMapper.toDomain('otro_id', testDto);
      expect(result.id, 'otro_id');
    });

    test('campos opcionales nulos se preservan', () {
      final dtoSinOpcionales = CharacterDto(
        ownerUid: 'uid',
        name: 'Char',
        classKey: 'warrior',
        raceKey: 'human',
        factionKey: 'alliance',
        mainSpec: 'arms',
        isArchived: false,
        createdAt: now,
        updatedAt: now,
      );
      final result = CharacterMapper.toDomain('id', dtoSinOpcionales);
      expect(result.secondarySpec, isNull);
      expect(result.level, isNull);
      expect(result.profession1, isNull);
      expect(result.profession2, isNull);
      expect(result.notes, isNull);
    });
  });

  group('CharacterMapper.toDto', () {
    test('mapea todos los campos correctamente', () {
      final result = CharacterMapper.toDto(testCharacter);
      expect(result.ownerUid, testDto.ownerUid);
      expect(result.name, testDto.name);
      expect(result.classKey, testDto.classKey);
      expect(result.raceKey, testDto.raceKey);
      expect(result.factionKey, testDto.factionKey);
      expect(result.mainSpec, testDto.mainSpec);
      expect(result.secondarySpec, testDto.secondarySpec);
      expect(result.level, testDto.level);
      expect(result.profession1, testDto.profession1);
      expect(result.profession2, testDto.profession2);
      expect(result.notes, testDto.notes);
      expect(result.isArchived, testDto.isArchived);
      expect(result.createdAt, testDto.createdAt);
      expect(result.updatedAt, testDto.updatedAt);
    });

    test('no incluye id (es el documento Firestore, no un campo)', () {
      // CharacterDto no tiene campo id — verificamos que el tipo no lo exponga
      final result = CharacterMapper.toDto(testCharacter);
      final json = result.toJson();
      expect(json.containsKey('id'), isFalse);
    });
  });

  group('round-trip toDomain → toDto', () {
    test('preserva todos los campos', () {
      final dto = CharacterMapper.toDto(testCharacter);
      final backToDomain = CharacterMapper.toDomain('char_001', dto);
      expect(backToDomain, testCharacter);
    });
  });
}
