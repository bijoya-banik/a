// // To parse this JSON data, do
// //
// //     final userModel = userModelFromJson(jsonString);

// import 'dart:convert';

// UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

// String userModelToJson(UserModel data) => json.encode(data.toJson());

// class UserModel {
//     UserModel({
//         this.user,
//         this.success,
//     });

//     List<User> user;
//     bool success;

//     factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//         user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
//         success: json["success"],
//     );

//     Map<String, dynamic> toJson() => {
//         "user": List<dynamic>.from(user.map((x) => x.toJson())),
//         "success": success,
//     };
// }

// class User {
//     User({
//         this.id,
//         this.firstName,
//         this.lastName,
//         this.email,
//         this.profilepic,
//         this.mobile,
//         this.countryCode,
//         this.userType,
//         this.house,
//         this.street,
//         this.road,
//         this.block,
//         this.area,
//         this.city,
//         this.state,
//         this.country,
//         this.discount,
//         this.discountValidity,
//         this.emailVerifiedAt,
//         this.isDefaultDriver,
//         this.appToken,
//         this.isVarified,
//         this.activationCode,
//         this.createdAt,
//         this.updatedAt,
//         this.deleveryAddress,
//     });

//     int id;
//     String firstName;
//     String lastName;
//     String email;
//     dynamic profilepic;
//     String mobile;
//     String countryCode;
//     String userType;
//     dynamic house;
//     dynamic street;
//     dynamic road;
//     dynamic block;
//     dynamic area;
//     dynamic city;
//     dynamic state;
//     String country;
//     String discount;
//     dynamic discountValidity;
//     dynamic emailVerifiedAt;
//     int isDefaultDriver;
//     String appToken;
//     int isVarified;
//     dynamic activationCode;
//     DateTime createdAt;
//     DateTime updatedAt;
//     List<DeleveryAddress> deleveryAddress;

//     factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["id"],
//         firstName: json["firstName"],
//         lastName: json["lastName"],
//         email: json["email"],
//         profilepic: json["profilepic"],
//         mobile: json["mobile"],
//         countryCode: json["country_code"],
//         userType: json["userType"],
//         house: json["house"],
//         street: json["street"],
//         road: json["road"],
//         block: json["block"],
//         area: json["area"],
//         city: json["city"],
//         state: json["state"],
//         country: json["country"],
//         discount: json["discount"],
//         discountValidity: json["discountValidity"],
//         emailVerifiedAt: json["email_verified_at"],
//         isDefaultDriver: json["isDefaultDriver"],
//         appToken: json["app_Token"],
//         isVarified: json["isVarified"],
//         activationCode: json["activation_code"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         deleveryAddress: List<DeleveryAddress>.from(json["delevery_address"].map((x) => DeleveryAddress.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "firstName": firstName,
//         "lastName": lastName,
//         "email": email,
//         "profilepic": profilepic,
//         "mobile": mobile,
//         "country_code": countryCode,
//         "userType": userType,
//         "house": house,
//         "street": street,
//         "road": road,
//         "block": block,
//         "area": area,
//         "city": city,
//         "state": state,
//         "country": country,
//         "discount": discount,
//         "discountValidity": discountValidity,
//         "email_verified_at": emailVerifiedAt,
//         "isDefaultDriver": isDefaultDriver,
//         "app_Token": appToken,
//         "isVarified": isVarified,
//         "activation_code": activationCode,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "delevery_address": List<dynamic>.from(deleveryAddress.map((x) => x.toJson())),
//     };
// }

// class DeleveryAddress {
//     DeleveryAddress({
//         this.id,
//         this.userId,
//         this.name,
//         this.mobile,
//         this.countryCode,
//         this.area,
//         this.house,
//         this.road,
//         this.block,
//         this.city,
//         this.state,
//         this.country,
//         this.createdAt,
//         this.updatedAt,
//     });

//     int id;
//     int userId;
//     String name;
//     String mobile;
//     String countryCode;
//     String area;
//     String house;
//     String road;
//     String block;
//     String city;
//     String state;
//     String country;
//     DateTime createdAt;
//     DateTime updatedAt;

//     factory DeleveryAddress.fromJson(Map<String, dynamic> json) => DeleveryAddress(
//         id: json["id"],
//         userId: json["userId"],
//         name: json["name"],
//         mobile: json["mobile"],
//         countryCode: json["country_code"],
//         area: json["area"],
//         house: json["house"],
//         road: json["road"],
//         block: json["block"],
//         city: json["city"],
//         state: json["state"],
//         country: json["country"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "userId": userId,
//         "name": name,
//         "mobile": mobile,
//         "country_code": countryCode,
//         "area": area,
//         "house": house,
//         "road": road,
//         "block": block,
//         "city": city,
//         "state": state,
//         "country": country,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//     };
// }



import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel {
  List<User> user;

  UserModel(this.user);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@JsonSerializable()
class User {
  dynamic id;
  dynamic firstName;
  dynamic lastName;
  dynamic email;
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
  dynamic mobile;
  dynamic country_code;
  dynamic isDefaultDriver;
  List delevery_address;

  User(
      this.id,
      this.area,
      this.block,
      this.city,
      this.country,
      this.firstName,
      this.house,
      this.lastName,
      this.road,
      this.state,
      this.street,
      this.email,
      this.userType,
      this.discount,
      this.discountValidity,
      this.isDefaultDriver,
      this.mobile,
      this.country_code,
      this.delevery_address);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// @JsonSerializable()
// class DeliveryAddreess {
 
//  dynamic id;
//  dynamic userId;
//  dynamic name;
//  dynamic mobile;
//  dynamic country_code;
//  dynamic area;
//  dynamic house;
//  dynamic road;
//  dynamic block;
//  dynamic city;
//  dynamic state;
//  dynamic country;

//   DeliveryAddreess(this.id, this.userId, this.country_code, this.area, this.block, this.city, this.country, 
//   this.house, this.mobile, this.name, this.road, this.state);


//   factory DeliveryAddreess.fromJson(Map<String, dynamic> json) =>
//       _$DeliveryAddreessFromJson(json);
// }
