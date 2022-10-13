// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NewFeatureModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewFeatureModel _$NewFeatureModelFromJson(Map<String, dynamic> json) {
  return NewFeatureModel(
    (json['product'] as List)
        ?.map((e) =>
            e == null ? null : Product.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NewFeatureModelToJson(NewFeatureModel instance) =>
    <String, dynamic>{
      'product': instance.product,
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    json['id'],
    json['cost'],
    json['description'],
    json['isFeatured'],
    json['isNew'],
    json['name'],
    json['price'],
    json['stock'],
    json['totalSale'],
    json['image'],
    json['warranty'],
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'cost': instance.cost,
      'stock': instance.stock,
      'isNew': instance.isNew,
      'isFeatured': instance.isFeatured,
      'totalSale': instance.totalSale,
      'warranty': instance.warranty,
      'image': instance.image,
    };
