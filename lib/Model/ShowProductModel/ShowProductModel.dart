
import 'package:json_annotation/json_annotation.dart';


part 'ShowProductModel.g.dart';



@JsonSerializable()
class ShowProductModel {
  List <Product> product;

  ShowProductModel(this.product);

  factory ShowProductModel.fromJson(Map<String, dynamic> json) =>
      _$ShowProductModelFromJson(json);
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
  dynamic isNew;
  dynamic isFeatured;
  dynamic totalSale;
  dynamic discount;
  dynamic warranty;
  Category category;
  SubCategory subcategory;
  List<Photo> photo;
  List<Video> videos;


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
class Category {
 
 dynamic id;
 dynamic name;

  Category(this.id, this.name);

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@JsonSerializable()
class SubCategory {
 
 dynamic id;
 dynamic categoryId;
 dynamic name;
 //Category category;

  SubCategory(this.id, this.name,this.categoryId);

  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);
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
class Video {
  dynamic id;
  dynamic productId;
  dynamic type;
  dynamic link;
  Video(this.id, this.productId, this.link,this.type);
  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}
