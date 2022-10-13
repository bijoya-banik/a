import 'package:json_annotation/json_annotation.dart';

part 'ShippingCostModel.g.dart';

@JsonSerializable()

class ShippingCostModel {

  Shiping shiping;

  ShippingCostModel(this.shiping);

  factory ShippingCostModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingCostModelFromJson(json);
}

@JsonSerializable()
class Shiping {
  dynamic id;
  dynamic price;



  Shiping(this.id,this.price);

  factory Shiping.fromJson(Map<String, dynamic> json) =>
      _$ShipingFromJson(json);
}

