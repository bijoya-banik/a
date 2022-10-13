// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StatusModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) {
  return StatusModel(
    (json['statuses'] as List)
        ?.map((e) =>
            e == null ? null : Status.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$StatusModelToJson(StatusModel instance) =>
    <String, dynamic>{
      'statuses': instance.statuses,
    };

Status _$StatusFromJson(Map<String, dynamic> json) {
  return Status(
    json['id'],
    json['name'],
    json['userType'],
  );
}

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userType': instance.userType,
    };
