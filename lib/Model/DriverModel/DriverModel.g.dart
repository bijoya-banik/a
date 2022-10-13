// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DriverModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverModel _$DriverModelFromJson(Map<String, dynamic> json) {
  return DriverModel(
    (json['driver'] as List)
        ?.map((e) =>
            e == null ? null : Driver.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DriverModelToJson(DriverModel instance) =>
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
    json['country_code'],
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
      'country_code': instance.country_code,
      'discount': instance.discount,
      'discountValidity': instance.discountValidity,
      'email_verified_at': instance.email_verified_at,
      'isDefaultDriver': instance.isDefaultDriver,
    };
