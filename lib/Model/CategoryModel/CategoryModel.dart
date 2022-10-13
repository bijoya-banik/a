import 'package:json_annotation/json_annotation.dart';

part 'CategoryModel.g.dart';

@JsonSerializable()
class CategoryModel {
  List<Category> category;

  CategoryModel(this.category);

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}


@JsonSerializable()
class Category {
 
 dynamic id;
 dynamic name;

  Category(this.id, this.name);

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}