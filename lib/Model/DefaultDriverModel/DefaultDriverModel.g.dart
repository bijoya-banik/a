// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DefaultDriverModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultDriverModel _$DefaultDriverModelFromJson(Map<String, dynamic> json) {
  return DefaultDriverModel(
    json['driver'] == null
        ? null
        : Driver.fromJson(json['driver'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DefaultDriverModelToJson(DefaultDriverModel instance) =>
    <String, dynamic>{
      'driver': instance.driver,
    };

Driver _$DriverFromJson(Map<String, dynamic> json) {
  return Driver(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['discount'],
    json['discountValidity'],
    json['isDefaultDriver'],
    json['mobile'],
    json['area'],
    json['block'],
    json['city'],
    json['country'],
    json['email'],
    json['email_verified_at'],
    json['house'],
    json['profilepic'],
    json['road'],
    json['state'],
    json['street'],
    json['userType'],
  );
}

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'profilepic': instance.profilepic,
      'mobile': instance.mobile,
      'userType': instance.userType,
      'house': instance.house,
      'street': instance.street,
      'road': instance.road,
      'block': instance.block,
      'area': instance.area,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'discount': instance.discount,
      'discountValidity': instance.discountValidity,
      'email_verified_at': instance.email_verified_at,
      'isDefaultDriver': instance.isDefaultDriver,
    };
