import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';

@freezed
class Goal with _$Goal {
  const factory Goal({
    /// ID del documento Firestore. Vacío ('') para objetivos nuevos antes de guardar.
    required String id,
    required String ownerUid,
    required String characterId,
    required String type,
    required String name,
    required String status,
    required String priority,
    String? slot,
    String? externalSource,
    String? externalSourceId,
    Map<String, dynamic>? externalPayloadSnapshot,
    String? sourceText,
    String? note,
    @Default(false) bool isArchived,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Goal;
}
