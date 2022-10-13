// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShippingCostModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingCostModel _$ShippingCostModelFromJson(Map<String, dynamic> json) {
  return ShippingCostModel(
    json['shiping'] == null
        ? null
        : Shiping.fromJson(json['shiping'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ShippingCostModelToJson(ShippingCostModel instance) =>
    <String, dynamic>{
      'shiping': instance.shiping,
    };

Shiping _$ShipingFromJson(Map<String, dynamic> json) {
  return Shiping(
    json['id'],
    json['price'],
  );
}

Map<String, dynamic> _$ShipingToJson(Shiping instance) => <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
    };
