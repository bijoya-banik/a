import 'package:json_annotation/json_annotation.dart';

part 'ShowOrderModel.g.dart';

@JsonSerializable()
class ShowOrderModel {
  List<Order> order;

  ShowOrderModel(this.order);

  factory ShowOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ShowOrderModelFromJson(json);
}

@JsonSerializable()
class Order {
  dynamic id;
  dynamic firstName;
  dynamic lastName;
  dynamic mobile1;
  dynamic mobile2;
  dynamic status;
  dynamic date;
  dynamic discount;
  dynamic customerId;
  dynamic driverId;
  dynamic subTotal;
  dynamic paymentType;
  dynamic grandTotal;
  dynamic shippingPrice;
  dynamic house;
  dynamic street;
  dynamic road;
  dynamic block;
  dynamic area;
  dynamic city;
  dynamic state;
  dynamic note;
  dynamic country;
  dynamic tax;
  dynamic status_updated_at;
  dynamic created_at;
  Driver driver;
  List<Orderdetails> details;
  UsedVoucher used_vaoucher;
  Customer customer;
  bool isClick;

  Order(
      this.id,
      this.date,
      this.area,
      this.block,
      this.city,
      this.country,
      this.customerId,
      this.discount,
      this.driverId,
      this.firstName,
      this.grandTotal,
      this.house,
      this.lastName,
      this.mobile1,
      this.mobile2,
      this.paymentType,
      this.road,
      this.shippingPrice,
      this.state,
      this.status,
      this.street,
      this.subTotal,
      this.details,
      this.note,
      this.status_updated_at,
      this.created_at,
      this.driver,
      this.isClick,
      this.tax,
      this.customer,this.used_vaoucher);

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@JsonSerializable()
class Orderdetails {
  dynamic id;
  dynamic combinationId;
  dynamic productId;
  dynamic price;
  dynamic combination;
  dynamic quantity;
  dynamic totalPrice;
  dynamic orderId;
  List<Photo> photo;
  Variation variation;
  List<ProductVC> product_vc;
  List<ProductVariable> product_variable;
  Product product;
  Orderdetails(
      this.id,
      this.product,
      this.price,
      this.combination,
      this.productId,
      this.orderId,
      this.quantity,
      this.totalPrice,
      this.combinationId,
      this.photo,
      this.product_variable,
      this.product_vc);

  factory Orderdetails.fromJson(Map<String, dynamic> json) =>
      _$OrderdetailsFromJson(json);
}

@JsonSerializable()
class Product {
  dynamic id;
  dynamic name;
  
  dynamic description;
  dynamic color;
  dynamic size;
  dynamic price;
  dynamic cost;
  dynamic stock;
  dynamic isNew;
  dynamic isFeatured;
  dynamic totalSale;
  dynamic warranty;

  Product(
      this.id,
      this.price,
     
      this.color,
      this.cost,
      this.description,
      this.isFeatured,
      this.isNew,
      this.name,
      this.size,
      this.stock,
      this.totalSale,
      this.warranty);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@JsonSerializable()
class ProductVC {
  dynamic id;
  dynamic productId;
  dynamic combination;
  dynamic stock;

  ProductVC(this.id, this.productId, this.stock, this.combination);

  factory ProductVC.fromJson(Map<String, dynamic> json) =>
      _$ProductVCFromJson(json);
}

@JsonSerializable()
class Variation {
  dynamic id;
  dynamic productId;
  dynamic combination;
  dynamic stock;

  Variation(this.id, this.productId, this.stock, this.combination);

  factory Variation.fromJson(Map<String, dynamic> json) =>
      _$VariationFromJson(json);
}

@JsonSerializable()
class ProductVariable {
  dynamic id;
  dynamic productId;
  dynamic name;
  bool isSelected;
  List<Values> values;

  ProductVariable(
      this.id, this.name, this.productId, this.values, this.isSelected);
  //: assert(isSelected != null,"bold cannot be null.");

  factory ProductVariable.fromJson(Map<String, dynamic> json) =>
      _$ProductVariableFromJson(json);
}

@JsonSerializable()
class Photo {
  dynamic id;
  dynamic productId;
  dynamic link;
  Photo(this.id, this.productId, this.link);
  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}

@JsonSerializable()
class Values {
  dynamic id;
  dynamic productId;
  dynamic variationId;
  dynamic value;
  bool isSelected;
  Values(
      this.id, this.productId, this.value, this.variationId, this.isSelected);
  factory Values.fromJson(Map<String, dynamic> json) => _$ValuesFromJson(json);
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

@JsonSerializable()
class UsedVoucher {
  dynamic id;
  dynamic userId;
  dynamic voucherId;
  dynamic orderId;
  Voucher voucher;
  UsedVoucher(
    this.id,
    this.orderId, this.userId, this.voucher, this.voucherId
  );
  factory UsedVoucher.fromJson(Map<String, dynamic> json) =>
      _$UsedVoucherFromJson(json);
}

@JsonSerializable()
class Voucher {
  dynamic id;
  dynamic code;
  dynamic discount;
  dynamic type;
  dynamic counter;
  dynamic validity;
  Voucher(
    this.id,
   this.type, this.code, this.counter, this.discount, this.validity
  );
  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);
}

@JsonSerializable()
class Customer{
  dynamic id;
  dynamic email;
  dynamic discount;

  Customer(
    this.id,
  this.discount, this.email
  );
  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

