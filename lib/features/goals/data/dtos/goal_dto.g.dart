// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalDto _$GoalDtoFromJson(Map<String, dynamic> json) => GoalDto(
  ownerUid: json['ownerUid'] as String,
  characterId: json['characterId'] as String,
  type: json['type'] as String,
  name: json['name'] as String,
  status: json['status'] as String,
  priority: json['priority'] as String,
  slot: json['slot'] as String?,
  externalSource: json['externalSource'] as String?,
  externalSourceId: json['externalSourceId'] as String?,
  externalPayloadSnapshot:
      json['externalPayloadSnapshot'] as Map<String, dynamic>?,
  sourceText: json['sourceText'] as String?,
  note: json['note'] as String?,
  isArchived: json['isArchived'] as bool,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$GoalDtoToJson(GoalDto instance) => <String, dynamic>{
  'ownerUid': instance.ownerUid,
  'characterId': instance.characterId,
  'type': instance.type,
  'name': instance.name,
  'status': instance.status,
  'priority': instance.priority,
  'slot': instance.slot,
  'externalSource': instance.externalSource,
  'externalSourceId': instance.externalSourceId,
  'externalPayloadSnapshot': instance.externalPayloadSnapshot,
  'sourceText': instance.sourceText,
  'note': instance.note,
  'isArchived': instance.isArchived,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
