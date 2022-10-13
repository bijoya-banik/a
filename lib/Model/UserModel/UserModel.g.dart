// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    (json['user'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'user': instance.user,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'],
    json['area'],
    json['block'],
    json['city'],
    json['country'],
    json['firstName'],
    json['house'],
    json['lastName'],
    json['road'],
    json['state'],
    json['street'],
    json['email'],
    json['userType'],
    json['discount'],
    json['discountValidity'],
    json['isDefaultDriver'],
    json['mobile'],
    json['country_code'],
    json['delevery_address'],
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
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
      'mobile': instance.mobile,
      'country_code': instance.country_code,
      'isDefaultDriver': instance.isDefaultDriver,
      'delevery_address': instance.delevery_address,
    };
