// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShowVariationValueModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowVariationValueModel _$ShowVariationValueModelFromJson(
    Map<String, dynamic> json) {
  return ShowVariationValueModel(
    (json['productVariationValue'] as List)
        ?.map((e) => e == null
            ? null
            : ProductVariation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ShowVariationValueModelToJson(
        ShowVariationValueModel instance) =>
    <String, dynamic>{
      'productVariationValue': instance.productVariationValue,
    };

ProductVariation _$ProductVariationFromJson(Map<String, dynamic> json) {
  return ProductVariation(
    json['id'],
    json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    json['productId'],
    json['value'],
    json['variation'] == null
        ? null
        : Variation.fromJson(json['variation'] as Map<String, dynamic>),
    json['variationId'],
  );
}

Map<String, dynamic> _$ProductVariationToJson(ProductVariation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'variationId': instance.variationId,
      'value': instance.value,
      'product': instance.product,
      'variation': instance.variation,
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
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'price': instance.price,
      'stock': instance.stock,
      'categoryId': instance.categoryId,
      'subCategoryId': instance.subCategoryId,
      'isNew': instance.isNew,
      'isFeatured': instance.isFeatured,
      'totalSale': instance.totalSale,
      'warranty': instance.warranty,
    };

Variation _$VariationFromJson(Map<String, dynamic> json) {
  return Variation(
    json['id'],
    json['productId'],
    json['name'],
  );
}

Map<String, dynamic> _$VariationToJson(Variation instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'name': instance.name,
    };
