import 'package:json_annotation/json_annotation.dart';

part 'AddProductSearchModel.g.dart';

@JsonSerializable()
class AddProductSearchModel {
 Product product;

  AddProductSearchModel(this.product);

  factory AddProductSearchModel.fromJson(Map<String, dynamic> json) =>
      _$AddProductSearchModelFromJson(json);
}

@JsonSerializable()
class Product {
  
  dynamic current_page;
  List <Data> data;
  dynamic first_page_url;
  dynamic from;
  dynamic last_page;
  dynamic last_page_url;
  dynamic next_page_url;
  dynamic path;
  dynamic per_page;
  dynamic prev_page_url;
  dynamic to;
  dynamic total;

  Product(this.data, this.total, this.current_page, this.first_page_url,this.from, this.last_page, this.last_page_url, this.next_page_url, this.path, this.per_page, this.prev_page_url, this.to);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@JsonSerializable()
class Data {

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
  dynamic discount;
  dynamic warranty;

   Category category;
  SubCategory subcategory;
  List<Photo> photo;

  Data(this.id, this.category, this.categoryId, this.description, this.discount, this.isFeatured, this.isNew, this.photo, this.price, this.stock, this.totalSale, this.warranty, this.image, this.name, this.subcategory, this.subCategoryId);

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);
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

