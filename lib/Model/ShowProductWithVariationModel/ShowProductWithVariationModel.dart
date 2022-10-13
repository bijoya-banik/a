import 'package:json_annotation/json_annotation.dart';

part 'ShowProductWithVariationModel.g.dart';

@JsonSerializable()
class  ShowProductWithVariationModel {
  List<Product> product;

  ShowProductWithVariationModel(this.product);

  factory ShowProductWithVariationModel.fromJson(Map<String, dynamic> json) =>
      _$ShowProductWithVariationModelFromJson(json);
}

@JsonSerializable()
class Product {
  dynamic id;
  dynamic name;
  dynamic description;
  dynamic color;
  dynamic size;
  dynamic price;
  dynamic cost;
  dynamic stock;
  dynamic categoryId;
  dynamic subCategoryId;
  dynamic isNew;
  dynamic isFeatured;
  dynamic totalSale;
  dynamic discount;
  dynamic warranty;
  // Category category;
  // SubCategory subcategory;
  List<Photo> photo;
  List<ProductVC> product_vc;
  List<ProductVariable> product_variable;

  Product(
      this.id,
      this.size,
      this.color,
      this.cost,
      this.description,
      this.isFeatured,
      this.isNew,
      this.name,
      this.photo,
      this.price,
      this.stock,
      this.totalSale,
      this.discount,
      this.warranty);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@JsonSerializable()
class ProductVC {
  dynamic id;
  dynamic productId;
  dynamic combination;
  dynamic stock;

  ProductVC(this.id, this.productId, this.stock, this.combination);

  factory ProductVC.fromJson(Map<String, dynamic> json) =>
      _$ProductVCFromJson(json);
}

@JsonSerializable()
class ProductVariable {
  dynamic id;
  dynamic productId;
  dynamic name;
  bool isSelected;
  List<Values> values;

  ProductVariable(this.id, this.name, this.productId, this.values,this.isSelected);
  //: assert(isSelected != null,"bold cannot be null.");

  factory ProductVariable.fromJson(Map<String, dynamic> json) =>
      _$ProductVariableFromJson(json);
}

@JsonSerializable()
class Photo {
  dynamic id;
  dynamic productId;
  dynamic link;
  Photo(this.id, this.productId, this.link);
  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}


@JsonSerializable()
class Values {
  dynamic id;
  dynamic productId;
  dynamic variationId;
  dynamic value;
  bool isSelected;
  Values(this.id, this.productId, this.value, this.variationId, this.isSelected);
  factory Values.fromJson(Map<String, dynamic> json) => _$ValuesFromJson(json);
}