import 'package:json_annotation/json_annotation.dart';

part 'DefaultDriverModel.g.dart';

@JsonSerializable()
class DefaultDriverModel {
  Driver driver;

  DefaultDriverModel(this.driver);

  factory DefaultDriverModel.fromJson(Map<String, dynamic> json) =>
      _$DefaultDriverModelFromJson(json);
}

@JsonSerializable()
class Driver {
  dynamic id;
  dynamic firstName;
  dynamic lastName;
  dynamic email;
  dynamic profilepic;
  dynamic mobile;
  dynamic userType;
  dynamic house;
  dynamic street;
  dynamic road;
  dynamic block;
  dynamic area;
  dynamic city;
  dynamic state;
  dynamic country;
  dynamic discount;
  dynamic discountValidity;
  dynamic email_verified_at;
  dynamic isDefaultDriver;

  Driver(
      this.id,
      this.firstName,
      this.lastName,
      this.discount,
      this.discountValidity,
      this.isDefaultDriver,
      this.mobile,
      this.area,
      this.block,
      this.city,
      this.country,
      this.email,
      this.email_verified_at,
      this.house,
      this.profilepic,
      this.road,
      this.state,
      this.street,
      this.userType);

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
}
