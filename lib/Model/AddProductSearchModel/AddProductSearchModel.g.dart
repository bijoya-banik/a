// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AddProductSearchModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProductSearchModel _$AddProductSearchModelFromJson(
    Map<String, dynamic> json) {
  return AddProductSearchModel(
    json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AddProductSearchModelToJson(
        AddProductSearchModel instance) =>
    <String, dynamic>{
      'product': instance.product,
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['total'],
    json['current_page'],
    json['first_page_url'],
    json['from'],
    json['last_page'],
    json['last_page_url'],
    json['next_page_url'],
    json['path'],
    json['per_page'],
    json['prev_page_url'],
    json['to'],
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'current_page': instance.current_page,
      'data': instance.data,
      'first_page_url': instance.first_page_url,
      'from': instance.from,
      'last_page': instance.last_page,
      'last_page_url': instance.last_page_url,
      'next_page_url': instance.next_page_url,
      'path': instance.path,
      'per_page': instance.per_page,
      'prev_page_url': instance.prev_page_url,
      'to': instance.to,
      'total': instance.total,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['id'],
    json['category'] == null
        ? null
        : Category.fromJson(json['category'] as Map<String, dynamic>),
    json['categoryId'],
    json['description'],
    json['discount'],
    json['isFeatured'],
    json['isNew'],
    (json['photo'] as List)
        ?.map(
            (e) => e == null ? null : Photo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['price'],
    json['stock'],
    json['totalSale'],
    json['warranty'],
    json['image'],
    json['name'],
    json['subcategory'] == null
        ? null
        : SubCategory.fromJson(json['subcategory'] as Map<String, dynamic>),
    json['subCategoryId'],
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
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
      'discount': instance.discount,
      'warranty': instance.warranty,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'photo': instance.photo,
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
