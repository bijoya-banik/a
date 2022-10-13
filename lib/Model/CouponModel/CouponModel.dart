import 'package:json_annotation/json_annotation.dart';

part 'CouponModel.g.dart';

@JsonSerializable()
class CouponModel {
  List<Coupon> coupon;

  CouponModel(this.coupon);

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);
}

@JsonSerializable()
class Coupon {
  dynamic id;

  dynamic code;
  dynamic discount;
  dynamic type;
  dynamic counter;
  dynamic validity;

  Coupon(
    this.id,
    this.code,
    this.discount,
    this.type,
    this.counter,
    this.validity,
  );

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
}
