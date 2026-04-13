import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';

@freezed
class Character with _$Character {
  const factory Character({
    /// ID del documento Firestore. Vacío ('') para personajes nuevos antes de guardar.
    required String id,
    required String ownerUid,
    required String name,
    required String classKey,
    required String raceKey,

    /// Derivado de [raceKey]. Ver core/catalogs/race_to_faction.dart.
    required String factionKey,
    required String mainSpec,
    String? secondarySpec,
    int? level,
    String? profession1,
    String? profession2,
    String? notes,
    @Default(false) bool isArchived,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Character;
}
