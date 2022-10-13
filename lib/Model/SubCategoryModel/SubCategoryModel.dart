import 'package:json_annotation/json_annotation.dart';

part 'SubCategoryModel.g.dart';

@JsonSerializable()
class SubCategoryModel {
  List<SubCategory> subCategoryforProduct;

  SubCategoryModel(this.subCategoryforProduct);

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryModelFromJson(json);
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

// @JsonSerializable()
// class Category {
 
//  dynamic id;
//  dynamic name;

//   Category(this.id, this.name);

//   factory Category.fromJson(Map<String, dynamic> json) =>
//       _$CategoryFromJson(json);
// }