// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShowOrderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowOrderModel _$ShowOrderModelFromJson(Map<String, dynamic> json) {
  return ShowOrderModel(
    (json['order'] as List)
        ?.map(
            (e) => e == null ? null : Order.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ShowOrderModelToJson(ShowOrderModel instance) =>
    <String, dynamic>{
      'order': instance.order,
    };

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    json['id'],
    json['date'],
    json['area'],
    json['block'],
    json['city'],
    json['country'],
    json['customerId'],
    json['discount'],
    json['driverId'],
    json['firstName'],
    json['grandTotal'],
    json['house'],
    json['lastName'],
    json['mobile1'],
    json['mobile2'],
    json['paymentType'],
    json['road'],
    json['shippingPrice'],
    json['state'],
    json['status'],
    json['street'],
    json['subTotal'],
    (json['details'] as List)
        ?.map((e) =>
            e == null ? null : Orderdetails.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['note'],
    json['status_updated_at'],
    json['created_at'],
    json['driver'] == null
        ? null
        : Driver.fromJson(json['driver'] as Map<String, dynamic>),
    json['isClick'] as bool,
    json['tax'],
    json['customer'] == null
        ? null
        : Customer.fromJson(json['customer'] as Map<String, dynamic>),
    json['used_vaoucher'] == null
        ? null
        : UsedVoucher.fromJson(json['used_vaoucher'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'mobile1': instance.mobile1,
      'mobile2': instance.mobile2,
      'status': instance.status,
      'date': instance.date,
      'discount': instance.discount,
      'customerId': instance.customerId,
      'driverId': instance.driverId,
      'subTotal': instance.subTotal,
      'paymentType': instance.paymentType,
      'grandTotal': instance.grandTotal,
      'shippingPrice': instance.shippingPrice,
      'house': instance.house,
      'street': instance.street,
      'road': instance.road,
      'block': instance.block,
      'area': instance.area,
      'city': instance.city,
      'state': instance.state,
      'note': instance.note,
      'country': instance.country,
      'tax': instance.tax,
      'status_updated_at': instance.status_updated_at,
      'created_at': instance.created_at,
      'driver': instance.driver,
      'details': instance.details,
      'used_vaoucher': instance.used_vaoucher,
      'customer': instance.customer,
      'isClick': instance.isClick,
    };

Orderdetails _$OrderdetailsFromJson(Map<String, dynamic> json) {
  return Orderdetails(
    json['id'],
    json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    json['price'],
    json['combination'],
    json['productId'],
    json['orderId'],
    json['quantity'],
    json['totalPrice'],
    json['combinationId'],
    (json['photo'] as List)
        ?.map(
            (e) => e == null ? null : Photo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['product_variable'] as List)
        ?.map((e) => e == null
            ? null
            : ProductVariable.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['product_vc'] as List)
        ?.map((e) =>
            e == null ? null : ProductVC.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..variation = json['variation'] == null
      ? null
      : Variation.fromJson(json['variation'] as Map<String, dynamic>);
}

Map<String, dynamic> _$OrderdetailsToJson(Orderdetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'combinationId': instance.combinationId,
      'productId': instance.productId,
      'price': instance.price,
      'combination': instance.combination,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
      'orderId': instance.orderId,
      'photo': instance.photo,
      'variation': instance.variation,
      'product_vc': instance.product_vc,
      'product_variable': instance.product_variable,
      'product': instance.product,
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    json['id'],
    json['price'],
    json['color'],
    json['cost'],
    json['description'],
    json['isFeatured'],
    json['isNew'],
    json['name'],
    json['size'],
    json['stock'],
    json['totalSale'],
    json['warranty'],
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
      'size': instance.size,
      'price': instance.price,
      'cost': instance.cost,
      'stock': instance.stock,
      'isNew': instance.isNew,
      'isFeatured': instance.isFeatured,
      'totalSale': instance.totalSale,
      'warranty': instance.warranty,
    };

ProductVC _$ProductVCFromJson(Map<String, dynamic> json) {
  return ProductVC(
    json['id'],
    json['productId'],
    json['stock'],
    json['combination'],
  );
}

Map<String, dynamic> _$ProductVCToJson(ProductVC instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'combination': instance.combination,
      'stock': instance.stock,
    };

Variation _$VariationFromJson(Map<String, dynamic> json) {
  return Variation(
    json['id'],
    json['productId'],
    json['stock'],
    json['combination'],
  );
}

Map<String, dynamic> _$VariationToJson(Variation instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'combination': instance.combination,
      'stock': instance.stock,
    };

ProductVariable _$ProductVariableFromJson(Map<String, dynamic> json) {
  return ProductVariable(
    json['id'],
    json['name'],
    json['productId'],
    (json['values'] as List)
        ?.map((e) =>
            e == null ? null : Values.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['isSelected'] as bool,
  );
}

Map<String, dynamic> _$ProductVariableToJson(ProductVariable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'name': instance.name,
      'isSelected': instance.isSelected,
      'values': instance.values,
    };

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo(
    json['id'],
    json['productId'],
    json['link'],
  );
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'link': instance.link,
    };

Values _$ValuesFromJson(Map<String, dynamic> json) {
  return Values(
    json['id'],
    json['productId'],
    json['value'],
    json['variationId'],
    json['isSelected'] as bool,
  );
}

Map<String, dynamic> _$ValuesToJson(Values instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'variationId': instance.variationId,
      'value': instance.value,
      'isSelected': instance.isSelected,
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

UsedVoucher _$UsedVoucherFromJson(Map<String, dynamic> json) {
  return UsedVoucher(
    json['id'],
    json['orderId'],
    json['userId'],
    json['voucher'] == null
        ? null
        : Voucher.fromJson(json['voucher'] as Map<String, dynamic>),
    json['voucherId'],
  );
}

Map<String, dynamic> _$UsedVoucherToJson(UsedVoucher instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'voucherId': instance.voucherId,
      'orderId': instance.orderId,
      'voucher': instance.voucher,
    };

Voucher _$VoucherFromJson(Map<String, dynamic> json) {
  return Voucher(
    json['id'],
    json['type'],
    json['code'],
    json['counter'],
    json['discount'],
    json['validity'],
  );
}

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'discount': instance.discount,
      'type': instance.type,
      'counter': instance.counter,
      'validity': instance.validity,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    json['id'],
    json['discount'],
    json['email'],
  );
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'discount': instance.discount,
    };
