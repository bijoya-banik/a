import 'package:json_annotation/json_annotation.dart';

part 'AllVariationModel.g.dart';

@JsonSerializable()
class AllVariationModel {
  List<AllVariation> allVariation;

  AllVariationModel(this.allVariation);

  factory AllVariationModel.fromJson(Map<String, dynamic> json) =>
      _$AllVariationModelFromJson(json);
}


@JsonSerializable()
class AllVariation {

    dynamic id;
    dynamic name;

  AllVariation(this.id, this.name);

  factory AllVariation.fromJson(Map<String, dynamic> json) =>
      _$AllVariationFromJson(json);
}