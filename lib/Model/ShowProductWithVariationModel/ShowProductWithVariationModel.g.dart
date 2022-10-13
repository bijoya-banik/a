// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShowProductWithVariationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowProductWithVariationModel _$ShowProductWithVariationModelFromJson(
    Map<String, dynamic> json) {
  return ShowProductWithVariationModel(
    (json['product'] as List)
        ?.map((e) =>
            e == null ? null : Product.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ShowProductWithVariationModelToJson(
        ShowProductWithVariationModel instance) =>
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
    ..categoryId = json['categoryId']
    ..subCategoryId = json['subCategoryId']
    ..product_vc = (json['product_vc'] as List)
        ?.map((e) =>
            e == null ? null : ProductVC.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..product_variable = (json['product_variable'] as List)
        ?.map((e) => e == null
            ? null
            : ProductVariable.fromJson(e as Map<String, dynamic>))
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
      'categoryId': instance.categoryId,
      'subCategoryId': instance.subCategoryId,
      'isNew': instance.isNew,
      'isFeatured': instance.isFeatured,
      'totalSale': instance.totalSale,
      'discount': instance.discount,
      'warranty': instance.warranty,
      'photo': instance.photo,
      'product_vc': instance.product_vc,
      'product_variable': instance.product_variable,
    };

ProductVC _$ProductVCFromJson(Map<String, dynamic> json) {
  return ProductVC(
    json['id'],
    json['productId'],
    json['stock'],
    json['combination'],
  );
}

Map<String, dynamic> _$ProductVCToJson(ProductVC instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'combination': instance.combination,
      'stock': instance.stock,
    };

ProductVariable _$ProductVariableFromJson(Map<String, dynamic> json) {
  return ProductVariable(
    json['id'],
    json['name'],
    json['productId'],
    (json['values'] as List)
        ?.map((e) =>
            e == null ? null : Values.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['isSelected'] as bool,
  );
}

Map<String, dynamic> _$ProductVariableToJson(ProductVariable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'name': instance.name,
      'isSelected': instance.isSelected,
      'values': instance.values,
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

Values _$ValuesFromJson(Map<String, dynamic> json) {
  return Values(
    json['id'],
    json['productId'],
    json['value'],
    json['variationId'],
    json['isSelected'] as bool,
  );
}

Map<String, dynamic> _$ValuesToJson(Values instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'variationId': instance.variationId,
      'value': instance.value,
      'isSelected': instance.isSelected,
    };
