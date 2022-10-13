// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShowProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowProductModel _$ShowProductModelFromJson(Map<String, dynamic> json) {
  return ShowProductModel(
    (json['product'] as List)
        ?.map((e) =>
            e == null ? null : Product.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ShowProductModelToJson(ShowProductModel instance) =>
    <String, dynamic>{
      'product': instance.product,
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    json['id'],
    json['size'],
    json['color'],
    json['cost'],
    json['description'],
    json['isFeatured'],
    json['isNew'],
    json['name'],
    (json['photo'] as List)
        ?.map(
            (e) => e == null ? null : Photo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['price'],
    json['stock'],
    json['totalSale'],
    json['discount'],
    json['warranty'],
  )
    ..category = json['category'] == null
        ? null
        : Category.fromJson(json['category'] as Map<String, dynamic>)
    ..subcategory = json['subcategory'] == null
        ? null
        : SubCategory.fromJson(json['subcategory'] as Map<String, dynamic>)
    ..videos = (json['videos'] as List)
        ?.map(
            (e) => e == null ? null : Video.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
      'size': instance.size,
      'price': instance.price,
      'cost': instance.cost,
      'stock': instance.stock,
      'isNew': instance.isNew,
      'isFeatured': instance.isFeatured,
      'totalSale': instance.totalSale,
      'discount': instance.discount,
      'warranty': instance.warranty,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'photo': instance.photo,
      'videos': instance.videos,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    json['id'],
    json['name'],
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
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

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo(
    json['id'],
    json['productId'],
    json['link'],
  );
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'link': instance.link,
    };

Video _$VideoFromJson(Map<String, dynamic> json) {
  return Video(
    json['id'],
    json['productId'],
    json['link'],
    json['type'],
  );
}

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'type': instance.type,
      'link': instance.link,
    };
