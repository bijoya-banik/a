// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AllVariationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllVariationModel _$AllVariationModelFromJson(Map<String, dynamic> json) {
  return AllVariationModel(
    (json['allVariation'] as List)
        ?.map((e) =>
            e == null ? null : AllVariation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AllVariationModelToJson(AllVariationModel instance) =>
    <String, dynamic>{
      'allVariation': instance.allVariation,
    };

AllVariation _$AllVariationFromJson(Map<String, dynamic> json) {
  return AllVariation(
    json['id'],
    json['name'],
  );
}

Map<String, dynamic> _$AllVariationToJson(AllVariation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
