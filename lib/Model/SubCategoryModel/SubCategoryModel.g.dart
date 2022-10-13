// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubCategoryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategoryModel _$SubCategoryModelFromJson(Map<String, dynamic> json) {
  return SubCategoryModel(
    (json['subCategoryforProduct'] as List)
        ?.map((e) =>
            e == null ? null : SubCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SubCategoryModelToJson(SubCategoryModel instance) =>
    <String, dynamic>{
      'subCategoryforProduct': instance.subCategoryforProduct,
    };

SubCategory _$SubCategoryFromJson(Map<String, dynamic> json) {
  return SubCategory(
    json['id'],
    json['name'],
    json['categoryId'],
  );
}

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'name': instance.name,
    };
