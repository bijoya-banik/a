// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VariationCombinationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VariationCombinationModel _$VariationCombinationModelFromJson(
    Map<String, dynamic> json) {
  return VariationCombinationModel(
    (json['productVariationCombination'] as List)
        ?.map((e) => e == null
            ? null
            : ProductVariation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$VariationCombinationModelToJson(
        VariationCombinationModel instance) =>
    <String, dynamic>{
      'productVariationCombination': instance.productVariationCombination,
    };

ProductVariation _$ProductVariationFromJson(Map<String, dynamic> json) {
  return ProductVariation(
    json['id'],
    json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    json['productId'],
    json['stock'],
    json['combination'],
  );
}

Map<String, dynamic> _$ProductVariationToJson(ProductVariation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'combination': instance.combination,
      'stock': instance.stock,
      'product': instance.product,
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    json['id'],
    json['price'],
    json['description'],
    json['isFeatured'],
    json['isNew'],
    json['name'],
    json['stock'],
    json['totalSale'],
    json['warranty'],
    json['image'],
    json['subCategoryId'],
    json['categoryId'],
    json['cost'],
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'price': instance.price,
      'cost': instance.cost,
      'stock': instance.stock,
      'categoryId': instance.categoryId,
      'subCategoryId': instance.subCategoryId,
      'isNew': instance.isNew,
      'isFeatured': instance.isFeatured,
      'totalSale': instance.totalSale,
      'warranty': instance.warranty,
    };
