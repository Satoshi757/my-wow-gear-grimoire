import '../../domain/models/goal.dart';
import '../dtos/goal_dto.dart';

abstract final class GoalMapper {
  /// Convierte un [GoalDto] + el [id] del documento a un [Goal] de dominio.
  static Goal toDomain(String id, GoalDto dto) => Goal(
        id: id,
        ownerUid: dto.ownerUid,
        characterId: dto.characterId,
        type: dto.type,
        name: dto.name,
        status: dto.status,
        priority: dto.priority,
        slot: dto.slot,
        externalSource: dto.externalSource,
        externalSourceId: dto.externalSourceId,
        externalPayloadSnapshot: dto.externalPayloadSnapshot,
        sourceText: dto.sourceText,
        note: dto.note,
        isArchived: dto.isArchived,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
      );

  /// Convierte un [Goal] de dominio a [GoalDto] para escribir en Firestore.
  static GoalDto toDto(Goal goal) => GoalDto(
        ownerUid: goal.ownerUid,
        characterId: goal.characterId,
        type: goal.type,
        name: goal.name,
        status: goal.status,
        priority: goal.priority,
        slot: goal.slot,
        externalSource: goal.externalSource,
        externalSourceId: goal.externalSourceId,
        externalPayloadSnapshot: goal.externalPayloadSnapshot,
        sourceText: goal.sourceText,
        note: goal.note,
        isArchived: goal.isArchived,
        createdAt: goal.createdAt,
        updatedAt: goal.updatedAt,
      );
}
