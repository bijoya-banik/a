
import 'package:json_annotation/json_annotation.dart';


part 'NewFeatureModel.g.dart';



@JsonSerializable()
class NewFeatureModel {
  List <Product> product;

  NewFeatureModel(this.product);

  factory NewFeatureModel.fromJson(Map<String, dynamic> json) =>
      _$NewFeatureModelFromJson(json);
}


@JsonSerializable()
class Product {
 

  dynamic id;
  dynamic name;
  dynamic description;
  dynamic price;
  dynamic cost;
  dynamic stock;
  dynamic isNew;
  dynamic isFeatured;
  dynamic totalSale;
  dynamic warranty;
  dynamic image;



    Product(
      this.id,
      this.cost,
      this.description,
      this.isFeatured,
      this.isNew,
      this.name,
      this.price,
      this.stock,
      this.totalSale,
      this.image,
      this.warranty);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}



