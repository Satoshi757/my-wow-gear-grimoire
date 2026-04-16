import 'package:flutter_test/flutter_test.dart';
import 'package:my_wow_gear_grimoire/features/goals/data/dtos/goal_dto.dart';
import 'package:my_wow_gear_grimoire/features/goals/data/mappers/goal_mapper.dart';
import 'package:my_wow_gear_grimoire/features/goals/domain/models/goal.dart';

void main() {
  final now = DateTime(2026, 4, 16);

  final testDto = GoalDto(
    ownerUid: 'uid_test',
    characterId: 'char_001',
    type: 'enchant',
    name: 'Enchant Cloak - Spell Penetration',
    status: 'pending',
    priority: 'high',
    slot: 'back',
    externalSource: 'blizzard_game_data',
    externalSourceId: '25086',
    externalPayloadSnapshot: {'name': 'Enchant Cloak', 'quality': 'common'},
    sourceText: 'Vendor in Shattrath',
    note: 'Importante para arena',
    isArchived: false,
    createdAt: now,
    updatedAt: now,
  );

  final testGoal = Goal(
    id: 'goal_001',
    ownerUid: 'uid_test',
    characterId: 'char_001',
    type: 'enchant',
    name: 'Enchant Cloak - Spell Penetration',
    status: 'pending',
    priority: 'high',
    slot: 'back',
    externalSource: 'blizzard_game_data',
    externalSourceId: '25086',
    externalPayloadSnapshot: {'name': 'Enchant Cloak', 'quality': 'common'},
    sourceText: 'Vendor in Shattrath',
    note: 'Importante para arena',
    isArchived: false,
    createdAt: now,
    updatedAt: now,
  );

  group('GoalMapper.toDomain', () {
    test('mapea todos los campos correctamente', () {
      final result = GoalMapper.toDomain('goal_001', testDto);
      expect(result, testGoal);
    });

    test('id viene del parámetro, no del DTO', () {
      final result = GoalMapper.toDomain('otro_id', testDto);
      expect(result.id, 'otro_id');
    });

    test('campos opcionales nulos se preservan', () {
      final dtoMinimo = GoalDto(
        ownerUid: 'uid',
        characterId: 'char',
        type: 'free_note',
        name: 'Nota',
        status: 'pending',
        priority: 'low',
        isArchived: false,
        createdAt: now,
        updatedAt: now,
      );
      final result = GoalMapper.toDomain('id', dtoMinimo);
      expect(result.slot, isNull);
      expect(result.externalSource, isNull);
      expect(result.externalPayloadSnapshot, isNull);
      expect(result.sourceText, isNull);
      expect(result.note, isNull);
    });
  });

  group('GoalMapper.toDto', () {
    test('mapea todos los campos correctamente', () {
      final result = GoalMapper.toDto(testGoal);
      expect(result.ownerUid, testDto.ownerUid);
      expect(result.characterId, testDto.characterId);
      expect(result.type, testDto.type);
      expect(result.name, testDto.name);
      expect(result.status, testDto.status);
      expect(result.priority, testDto.priority);
      expect(result.slot, testDto.slot);
      expect(result.note, testDto.note);
      expect(result.isArchived, testDto.isArchived);
    });

    test('no incluye id en el DTO', () {
      final result = GoalMapper.toDto(testGoal);
      final json = result.toJson();
      expect(json.containsKey('id'), isFalse);
    });
  });

  group('round-trip toDomain → toDto', () {
    test('preserva todos los campos', () {
      final dto = GoalMapper.toDto(testGoal);
      final back = GoalMapper.toDomain('goal_001', dto);
      expect(back, testGoal);
    });
  });
}
