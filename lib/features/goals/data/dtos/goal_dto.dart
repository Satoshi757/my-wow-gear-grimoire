import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/firestore_converters.dart';

part 'goal_dto.g.dart';

/// DTO para la colección `goals` de Firestore.
/// No incluye `id` — el ID viene del documento Firestore (DocumentSnapshot.id).
@JsonSerializable()
class GoalDto {
  const GoalDto({
    required this.ownerUid,
    required this.characterId,
    required this.type,
    required this.name,
    required this.status,
    required this.priority,
    this.slot,
    this.externalSource,
    this.externalSourceId,
    this.externalPayloadSnapshot,
    this.sourceText,
    this.note,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  final String ownerUid;
  final String characterId;
  final String type;
  final String name;
  final String status;
  final String priority;
  final String? slot;
  final String? externalSource;
  final String? externalSourceId;
  final Map<String, dynamic>? externalPayloadSnapshot;
  final String? sourceText;
  final String? note;
  final bool isArchived;

  @TimestampConverter()
  final DateTime createdAt;

  @TimestampConverter()
  final DateTime updatedAt;

  factory GoalDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GoalDtoToJson(this);
}
