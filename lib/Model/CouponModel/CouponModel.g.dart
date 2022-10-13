// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CouponModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponModel _$CouponModelFromJson(Map<String, dynamic> json) {
  return CouponModel(
    (json['coupon'] as List)
        ?.map((e) =>
            e == null ? null : Coupon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CouponModelToJson(CouponModel instance) =>
    <String, dynamic>{
      'coupon': instance.coupon,
    };

Coupon _$CouponFromJson(Map<String, dynamic> json) {
  return Coupon(
    json['id'],
    json['code'],
    json['discount'],
    json['type'],
    json['counter'],
    json['validity'],
  );
}

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'discount': instance.discount,
      'type': instance.type,
      'counter': instance.counter,
      'validity': instance.validity,
    };
