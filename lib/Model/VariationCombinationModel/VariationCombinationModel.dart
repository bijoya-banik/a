import 'package:json_annotation/json_annotation.dart';

part 'VariationCombinationModel.g.dart';

@JsonSerializable()
class VariationCombinationModel {
  List<ProductVariation> productVariationCombination;

  VariationCombinationModel(this.productVariationCombination);

  factory VariationCombinationModel.fromJson(Map<String, dynamic> json) =>
      _$VariationCombinationModelFromJson(json);
}

@JsonSerializable()
class ProductVariation {
  dynamic id;
  dynamic productId;
  dynamic combination;
  dynamic stock;
  Product product;

  ProductVariation(this.id,this.product, this.productId, this.stock, this.combination);

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
  dynamic cost;
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
      this.categoryId,this.cost);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}


