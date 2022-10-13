import 'package:json_annotation/json_annotation.dart';

part 'ShowVariationModel.g.dart';

@JsonSerializable()
class ShowVariationModel {
  List<ProductVariation> productVariation;

  ShowVariationModel(this.productVariation);

  factory ShowVariationModel.fromJson(Map<String, dynamic> json) =>
      _$ShowVariationModelFromJson(json);
}

@JsonSerializable()
class ProductVariation {
  dynamic id;
  dynamic productId;
  dynamic name;
  Product product;

  ProductVariation(this.id, this.name, this.product, this.productId);

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
  dynamic cost;
  dynamic discount;
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
      this.discount, this.cost,
      this.subCategoryId,
      this.categoryId);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
