import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/firestore_converters.dart';

part 'character_dto.g.dart';

/// DTO para la colección `characters` de Firestore.
/// No incluye `id` — el ID viene del documento Firestore (DocumentSnapshot.id).
@JsonSerializable()
class CharacterDto {
  const CharacterDto({
    required this.ownerUid,
    required this.name,
    required this.classKey,
    required this.raceKey,
    required this.factionKey,
    required this.mainSpec,
    this.secondarySpec,
    this.level,
    this.profession1,
    this.profession2,
    this.notes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  final String ownerUid;
  final String name;
  final String classKey;
  final String raceKey;
  final String factionKey;
  final String mainSpec;
  final String? secondarySpec;
  final int? level;
  final String? profession1;
  final String? profession2;
  final String? notes;
  final bool isArchived;

  @TimestampConverter()
  final DateTime createdAt;

  @TimestampConverter()
  final DateTime updatedAt;

  factory CharacterDto.fromJson(Map<String, dynamic> json) =>
      _$CharacterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterDtoToJson(this);
}
