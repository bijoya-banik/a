// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShowVariationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowVariationModel _$ShowVariationModelFromJson(Map<String, dynamic> json) {
  return ShowVariationModel(
    (json['productVariation'] as List)
        ?.map((e) => e == null
            ? null
            : ProductVariation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ShowVariationModelToJson(ShowVariationModel instance) =>
    <String, dynamic>{
      'productVariation': instance.productVariation,
    };

ProductVariation _$ProductVariationFromJson(Map<String, dynamic> json) {
  return ProductVariation(
    json['id'],
    json['name'],
    json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    json['productId'],
  );
}

Map<String, dynamic> _$ProductVariationToJson(ProductVariation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'name': instance.name,
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
    json['discount'],
    json['cost'],
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
      'cost': instance.cost,
      'discount': instance.discount,
      'categoryId': instance.categoryId,
      'subCategoryId': instance.subCategoryId,
      'isNew': instance.isNew,
      'isFeatured': instance.isFeatured,
      'totalSale': instance.totalSale,
      'warranty': instance.warranty,
    };
