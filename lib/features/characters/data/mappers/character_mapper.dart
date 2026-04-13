import '../../domain/models/character.dart';
import '../dtos/character_dto.dart';

abstract final class CharacterMapper {
  /// Convierte un [CharacterDto] + el [id] del documento a un [Character] de dominio.
  static Character toDomain(String id, CharacterDto dto) => Character(
        id: id,
        ownerUid: dto.ownerUid,
        name: dto.name,
        classKey: dto.classKey,
        raceKey: dto.raceKey,
        factionKey: dto.factionKey,
        mainSpec: dto.mainSpec,
        secondarySpec: dto.secondarySpec,
        level: dto.level,
        profession1: dto.profession1,
        profession2: dto.profession2,
        notes: dto.notes,
        isArchived: dto.isArchived,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
      );

  /// Convierte un [Character] de dominio a [CharacterDto] para escribir en Firestore.
  static CharacterDto toDto(Character character) => CharacterDto(
        ownerUid: character.ownerUid,
        name: character.name,
        classKey: character.classKey,
        raceKey: character.raceKey,
        factionKey: character.factionKey,
        mainSpec: character.mainSpec,
        secondarySpec: character.secondarySpec,
        level: character.level,
        profession1: character.profession1,
        profession2: character.profession2,
        notes: character.notes,
        isArchived: character.isArchived,
        createdAt: character.createdAt,
        updatedAt: character.updatedAt,
      );
}
