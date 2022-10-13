import 'package:json_annotation/json_annotation.dart';

part 'ShowVariationValueModel.g.dart';

@JsonSerializable()
class ShowVariationValueModel {
  List<ProductVariation> productVariationValue;

  ShowVariationValueModel(this.productVariationValue);

  factory ShowVariationValueModel.fromJson(Map<String, dynamic> json) =>
      _$ShowVariationValueModelFromJson(json);
}

@JsonSerializable()
class ProductVariation {
  dynamic id;
  dynamic productId;
  dynamic variationId;
  dynamic value;
  Product product;
  Variation variation;

  ProductVariation(this.id,this.product, this.productId,this.value, this.variation, this.variationId);

  factory ProductVariation.fromJson(Map<String, dynamic> json) =>
      _$ProductVariationFromJson(json);
}

@JsonSerializable()
class Product {
  dynamic id;
  dynamic name;
  dynamic description;
  dynamic image;
  dynamic price;
  dynamic stock;
  dynamic categoryId;
  dynamic subCategoryId;
  dynamic isNew;
  dynamic isFeatured;
  dynamic totalSale;
  dynamic warranty;

  Product(
      this.id,
      this.price,
      this.description,
      this.isFeatured,
      this.isNew,
      this.name,
      this.stock,
      this.totalSale,
      this.warranty,
      this.image,
      this.subCategoryId,
      this.categoryId);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@JsonSerializable()
class Variation {
  dynamic id;
  dynamic productId;
  dynamic name;
 

  Variation(
      this.id,this.productId, this.name
      );

  factory Variation.fromJson(Map<String, dynamic> json) =>
      _$VariationFromJson(json);
}

