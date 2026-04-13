// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterDto _$CharacterDtoFromJson(Map<String, dynamic> json) => CharacterDto(
  ownerUid: json['ownerUid'] as String,
  name: json['name'] as String,
  classKey: json['classKey'] as String,
  raceKey: json['raceKey'] as String,
  factionKey: json['factionKey'] as String,
  mainSpec: json['mainSpec'] as String,
  secondarySpec: json['secondarySpec'] as String?,
  level: (json['level'] as num?)?.toInt(),
  profession1: json['profession1'] as String?,
  profession2: json['profession2'] as String?,
  notes: json['notes'] as String?,
  isArchived: json['isArchived'] as bool,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$CharacterDtoToJson(CharacterDto instance) =>
    <String, dynamic>{
      'ownerUid': instance.ownerUid,
      'name': instance.name,
      'classKey': instance.classKey,
      'raceKey': instance.raceKey,
      'factionKey': instance.factionKey,
      'mainSpec': instance.mainSpec,
      'secondarySpec': instance.secondarySpec,
      'level': instance.level,
      'profession1': instance.profession1,
      'profession2': instance.profession2,
      'notes': instance.notes,
      'isArchived': instance.isArchived,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
