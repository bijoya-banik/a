import 'dart:convert';
import 'dart:io';

import 'package:bahrain_admin/Model/UserModel/UserModel.dart';
import 'package:bahrain_admin/ProductOrder/ProductOrder.dart';
import 'package:bahrain_admin/Screen/OrderPage/OrderList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:bahrain_admin/main.dart' as prefix0;
import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PhotoCrop {
  free,
  picked,
  cropped,
}

class AddOrderGuestForm extends StatefulWidget {
  @override
  _AddOrderGuestFormState createState() => _AddOrderGuestFormState();
}

class _AddOrderGuestFormState extends State<AddOrderGuestForm> {
  TextEditingController customerIdController = new TextEditingController();
  TextEditingController firstController = new TextEditingController();
  TextEditingController lastController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController mobile1Controller = new TextEditingController();
  TextEditingController mobile2Controller = new TextEditingController();
  TextEditingController houseController = new TextEditingController();
  TextEditingController streetController = new TextEditingController();
  TextEditingController roadController = new TextEditingController();
  TextEditingController blockController = new TextEditingController();
  TextEditingController areaController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController payTypeController = new TextEditingController();
  TextEditingController discountController = new TextEditingController();
  TextEditingController shippingCostController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();

  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  ////////// Image Picker//////
  PhotoCrop state;
  File imageFile;
  String image;
  var imagePath;
  bool _product = false;
  bool _isSearch = false;
  String date = "";

  DateTime selectedDate = DateTime.now();
  var format;
  var userData;
  bool _products = false;
  bool _buyer = false;
  List cartData = [];
  var body;
  double total = 0;
  double subTotal = 0;
  double shipping = 0;
  double discount = 0;
  bool _isLoading = false;
  var customerId;

  Container addUserCon(String label, String hint, TextEditingController control, TextInputType type) {
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 10, bottom: 8),
                child: Text(label, textAlign: TextAlign.left, style: TextStyle(color: appColor, fontSize: 13))),
            Container(
                margin: EdgeInsets.only(left: 8, top: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.grey[100],
                    border: Border.all(width: 0.2, color: Colors.grey)),
                child: TextField(
                  cursorColor: Colors.grey,
                  controller: control,
                  keyboardType: type,
                  style: TextStyle(color: Colors.grey[600]),
                  decoration: InputDecoration(
                    hintText: hint,
                    contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                    border: InputBorder.none,
                  ),
                )),
          ],
        ));
  }

  Container addOrderCon(String label, String hint, TextEditingController control, TextInputType type) {
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 10, bottom: 8),
                child: Text(label, textAlign: TextAlign.left, style: TextStyle(color: appColor, fontSize: 13))),
            Container(
                margin: EdgeInsets.only(left: 8, top: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.grey[100],
                    border: Border.all(width: 0.2, color: Colors.grey)),
                child: TextField(
                  cursorColor: Colors.grey,
                  controller: control,
                  keyboardType: type,
                  onChanged: (val) {
                    if (!mounted) return;
                    setState(() {});
                  },
                  // autofocus: true,
                  style: TextStyle(color: Colors.grey[600]),
                  decoration: InputDecoration(
                    hintText: hint,
                    // labelText: label,
                    // labelStyle: TextStyle(color: appColor),
                    contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                    border: InputBorder.none,
                  ),
                )),
          ],
        ));
  }

  @override
  void initState() {
    state = PhotoCrop.free;
    format = DateFormat("yyyy-MM-dd").format(selectedDate);

    _showCart();
    super.initState();
  }
  //////////////// get  user start ///////////////

  Future _getLocalBestProductsData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localbestProductsData = localStorage.getString(key);
    if (localbestProductsData != null) {
      body = json.decode(localbestProductsData);
      _bestProductsState();
    }
  }

  void _bestProductsState() {
    setState(() {
      _isLoading = true;
    });
    var users = UserModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      userData = users.user;
      _isLoading = false;
      _isSearch = true;
      _product = false;
    });

    print(userData);

    //  for(var d in userData){

    //    firstController.text = d.firstName==null?"":d.firstName;
    //    lastController.text = d.lastName==null?"":d.lastName;
    //    mobile1Controller.text = d.email==null?"":d.email;
    //    houseController.text = d.house==null?"":d.house;
    //    streetController.text = d.street==null?"":d.street;
    //    roadController.text = d.road==null?"":d.road;
    //    blockController.text = d.block==null?"":d.block.toString();
    //    areaController.text = d.area==null?"":d.area;
    //    stateController.text = d.city==null?"":d.city;
    //    cityController.text = d.state==null?"":d.state;
    //    countryController.text = d.country==null?"":d.country;
    //    discountController.text = d.discount==null?"":d.discount;
    //    //firstController.text = d.firstName==null?"":d.firstName;

    //  };
  }

  Future<void> _showUser() async {
    var key = 'user-list';
    await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/getAllCoustomers?name=${customerIdController.text}');
    body = json.decode(res.body);

    //   print(body);

    if (res.statusCode == 200) {
      _bestProductsState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  //////////////// get  user end ///////////////

  Future _showCart() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localbestProductsData = localStorage.getString('cartList');
    if (localbestProductsData != null) {
      setState(() {
        subTotal = 0;
        total = 0;
        cartData = json.decode(localbestProductsData);
        for (int i = 0; i < cartData.length; i++) {
          subTotal = subTotal + cartData[i]['quantity'] * (cartData[i]['price']);
        }

        total = subTotal + shipping - discount;
      });
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        //  locale: Locale("yyyy-MM-dd"),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = "${DateFormat("yyyy-MM-dd").format(selectedDate)}";
      });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 25, bottom: 10),
                  //   child: Text(
                  //     "Order Information ",
                  //     textAlign: TextAlign.left,
                  //     style: TextStyle(
                  //         color: appColor,
                  //         fontFamily: "DINPro",
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),

                  // Divider(
                  //   color: Colors.grey[900],
                  // ),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, FadeRoute(page: ProductOrder()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.add_box,
                                color: appColor,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Add Product",
                                  style: TextStyle(color: appColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// products/////
                      cartData.length == 0
                          ? Container()
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Column(
                                        children: List.generate(cartData.length, (index) {
                                      //  total = 0;
                                      // shippingCostController.text = '0';
                                      // discountController.text ='0';
                                      // subTotal = 0;

                                      shippingCostController.text == "" ? shipping = 0 : shipping = double.parse(shippingCostController.text);

                                      discountController.text == "" ? discount = 0 : discount = double.parse(discountController.text);

                                      discount = discount / 100;

                                      //  subTotal =subTotal+( cartData[index]['quantity']*double.parse( cartData[index]['price']));
                                      discount = (subTotal * discount).toDouble();

                                      total = subTotal + shipping - discount;

                                      return Container(
                                        padding: EdgeInsets.only(bottom: 7),
                                        decoration: BoxDecoration(
                                            //color: Colors.red,
                                            border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        )),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 10, top: 20),
                                              // color: Colors.teal,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                //crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  cartData[index]['img'] == ""
                                                      ? ClipOval(
                                                          child: Image.asset(
                                                          'assets/images/placeholder-image.png',
                                                          height: 50,
                                                          width: 50,
                                                          fit: BoxFit.cover,
                                                        ))
                                                      :
                                                      // ClipOval(
                                                      //       child: Image.asset(
                                                      //     'assets/images/placeholder-image.png',
                                                      //     height: 50,
                                                      //     width: 50,
                                                      //     fit: BoxFit.cover,
                                                      //   )),

                                                      ClipOval(
                                                          child: Image.network(
                                                            cartData[index]['img'],
                                                            height: 50,
                                                            width: 50,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                  Container(
                                                    margin: EdgeInsets.only(right: 10, left: 10),
                                                    decoration: BoxDecoration(
                                                        //  color: Colors.red
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                        ),
                                                        borderRadius: BorderRadius.circular(5)),
                                                    child: Container(
                                                      padding: EdgeInsets.all(3),
                                                      child: Column(
                                                        //mainAxisAlignment: MainAxisAlignment.start,
                                                        children: <Widget>[
                                                          GestureDetector(
                                                            onTap: () {
                                                              //   _getDiscount();

                                                              // subTotal = 0;
                                                              // discount = 0;
                                                              if (cartData[index]['quantity'] <= cartData[index]['stock']) {
                                                                setState(() {
                                                                  cartData[index]['quantity'] = cartData[index]['quantity'] + 1;
                                                                  cartData[index]['total'] =
                                                                      cartData[index]['quantity'] * int.parse(cartData[index]['price']);

                                                                  subTotal = subTotal + cartData[index]['total'];
                                                                  // total = subTotal+shipping-discount;
                                                                });
                                                              }

                                                              _dataCrud(cartData[index], index);
                                                            },
                                                            child: Container(
                                                              child: Icon(
                                                                Icons.add,
                                                                color: appColor,
                                                                //size: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              cartData[index]['quantity'].toString(),
                                                              //  "\$${(d.item.price * d.quantity).toStringAsFixed(2)}",
                                                              // textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "sourcesanspro",
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              if (cartData[index]['quantity'] == 1) {
                                                              } else {
                                                                setState(() {
                                                                  cartData[index]['quantity'] = cartData[index]['quantity'] - 1;
                                                                  cartData[index]['total'] = cartData[index]['quantity'] * cartData[index]['price'];
                                                                  // d['total'] = d_total.toString();

                                                                  // print( d['total']);
                                                                  subTotal = subTotal - cartData[index]['total'];
                                                                  //  total = subTotal+shipping-discount;
                                                                });
                                                              }

                                                              _dataCrud(cartData[index], index);
                                                            },
                                                            child: Container(
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: appColor,
                                                                //size: 13,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: MediaQuery.of(context).size.width / 3,
                                                        padding: EdgeInsets.only(top: 8, bottom: 3),
                                                        child: Text(
                                                          cartData[index]['name'],
                                                          // "${d.quantity}x ${d.item.name}",
                                                          textAlign: TextAlign.left,
                                                          // overflow:
                                                          //     TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontFamily: "sourcesanspro",
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.normal),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        padding: EdgeInsets.only(top: 2),
                                                        child: Text(
                                                          "\$" + cartData[index]['total'].toString(),
                                                          //  "\$${(d.item.price * d.quantity).toStringAsFixed(2)}",
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              color: appColor,
                                                              fontFamily: "sourcesanspro",
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.normal),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(right: 20),
                                              //width: 120,
                                              //  color: Colors.red,
                                              alignment: Alignment.topRight,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    alignment: Alignment.topRight,
                                                    child: GestureDetector(
                                                      child: Icon(
                                                        Icons.close,
                                                        color: appColor,
                                                      ),
                                                      onTap: () {
                                                        //   print(i);
                                                        _deleteCart(cartData[index], index);
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.topRight,
                                                    //  child: GestureDetector(
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                    // onTap: () {
                                                    //   // _deleteCart(d);
                                                    // },
                                                    // ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.topRight,
                                                    //  child: GestureDetector(
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                    // onTap: () {
                                                    //   // _deleteCart(d);
                                                    // },
                                                    // ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    })),
                                  ),

                                  /////////////  Subtotal  start ////////////

                                  Container(
                                    color: Colors.grey[350],
                                    padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Subtotal",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black, fontFamily: "sourcesanspro", fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            // "\$ 78",
                                            "\$${(subTotal).toStringAsFixed(2)}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black, fontFamily: "sourcesanspro", fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  /////////////  Subtotal end ////////////

                                  ////////////////   Total Start   ////////////

                                  Container(
                                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      top: BorderSide(
                                        color: Colors.grey,
                                        width: 1.5,
                                      ),
                                    )),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Total",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black, fontFamily: "sourcesanspro", fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            //"\$ 5678",
                                            "\$${(total).toStringAsFixed(2)}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black, fontFamily: "sourcesanspro", fontSize: 17, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  /////////////  Total End  ////////////
                                  ///
                                  ///
                                  addUserCon("Payment Type", "", payTypeController, TextInputType.text),
                                  addOrderCon("Shipping Cost", "", shippingCostController, TextInputType.number),

                                  ////////////   warrenty end

                                  SizedBox(height: 15),

                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 25, bottom: 10),
                                  //   child: Text(
                                  //     "Buyer Information ",
                                  //     textAlign: TextAlign.left,
                                  //     style: TextStyle(
                                  //         color: appColor,
                                  //         fontFamily: "DINPro",
                                  //         fontSize: 18,
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),

                                  // Divider(
                                  //   color: Colors.grey[900],
                                  // ),
                                  // SizedBox(
                                  //   height: 15,
                                  // ),

                                  //   Column(
                                  //     children: <Widget>[
                                  //       Column(
                                  //         children: <Widget>[

                                  //               Container(
                                  // padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                  // child: Column(
                                  //   children: <Widget>[
                                  //     Container(
                                  //         alignment: Alignment.topLeft,
                                  //         margin: EdgeInsets.only(left: 10, bottom: 8),
                                  //         child: Text("Customer Id",
                                  //             textAlign: TextAlign.left,
                                  //             style: TextStyle(color: appColor, fontSize: 13))),
                                  //     Container(
                                  //         margin: EdgeInsets.only(left: 8, top: 0),
                                  //         decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  //             color: Colors.grey[100],
                                  //             border: Border.all(width: 0.2, color: Colors.grey)),
                                  //         child: TextField(
                                  //           cursorColor: Colors.grey,
                                  //           controller: customerIdController,
                                  //           keyboardType: TextInputType.text,
                                  //           style: TextStyle(color: Colors.grey[600]),
                                  //           decoration: InputDecoration(
                                  //             contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                                  //             border: InputBorder.none,
                                  //           ),
                                  //            onChanged: (val) {
                                  //             if (!mounted) return;
                                  //             setState(() {

                                  //               _showUser();
                                  //             });
                                  //           },
                                  //         )),
                                  //   ],
                                  // )),

                                  //  _isSearch
                                  //         ? Column(
                                  //             mainAxisAlignment: MainAxisAlignment.start,
                                  //             children: _showProductsList())
                                  //         : Container(),

                                  //      addOrderCon("Discount", "", discountController,
                                  //                       TextInputType.number),
                                  //           // addUserCon(
                                  //           //     "First Name", "", firstController, TextInputType.text),
                                  //           // addUserCon("Last Name", "", lastController,
                                  //           //     TextInputType.text),
                                  //           addUserCon("Mobile Number", "", mobile1Controller,
                                  //               TextInputType.number),
                                  //           // addUserCon("Mobile Number 2", "", mobile2Controller,
                                  //           //     TextInputType.number),
                                  //           addUserCon(
                                  //               "House", "", houseController, TextInputType.text),
                                  //           // addUserCon(
                                  //           //     "Street", "", streetController, TextInputType.text),
                                  //           addUserCon(
                                  //               "Road", "", roadController, TextInputType.text),
                                  //           addUserCon(
                                  //               "Block", "", blockController, TextInputType.text),
                                  //           addUserCon(
                                  //               "Area", "", areaController, TextInputType.text),
                                  //           // addUserCon(
                                  //           //     "State", "", stateController, TextInputType.text),
                                  //           // addUserCon(
                                  //           //     "City", "", cityController, TextInputType.text),
                                  //           // addUserCon(
                                  //           //     "Country", "", countryController, TextInputType.text),

                                  //               //   Column(
                                  //               //       children: <Widget>[
                                  //               //         Container(
                                  //               //             alignment: Alignment.topLeft,
                                  //               //             margin: EdgeInsets.only(
                                  //               //                 left: 25, top: 5, bottom: 8),
                                  //               //             child: Text("Date",
                                  //               //                 textAlign: TextAlign.left,
                                  //               //                 style: TextStyle(
                                  //               //                     color: appColor, fontSize: 13))),
                                  //               //         Container(
                                  //               //           margin: EdgeInsets.only(left: 20, right: 20),
                                  //               //           decoration: BoxDecoration(
                                  //               //               borderRadius:
                                  //               //                   BorderRadius.all(Radius.circular(5.0)),
                                  //               //               color: Colors.grey[100],
                                  //               //               border: Border.all(
                                  //               //                   width: 0.2, color: Colors.grey)),
                                  //               //           child: Row(
                                  //               //             mainAxisAlignment:
                                  //               //                 MainAxisAlignment.spaceBetween,
                                  //               //             children: <Widget>[
                                  //               //               Container(
                                  //               //                 padding: EdgeInsets.only(left: 20),
                                  //               //                 child: Text(
                                  //               //                   date.toString(),
                                  //               //                   textAlign: TextAlign.right,
                                  //               //                   style:
                                  //               //                       TextStyle(color: Colors.grey[600]),
                                  //               //                 ),
                                  //               //               ),
                                  //               //               IconButton(
                                  //               //                 onPressed: () {
                                  //               //                   _selectDate(context);
                                  //               //                 },
                                  //               //                 icon: Icon(Icons.calendar_today),
                                  //               //               )
                                  //               //             ],
                                  //               //           ),
                                  //               //         ),
                                  //               //       ],
                                  //               //     ),

                                  addUserCon("Note", "", noteController, TextInputType.text),
                                  //         ],
                                  //       )
                                  //     ],
                                  //   ),

                                  GestureDetector(
                                    onTap: () {
                                      _isLoading ? null : _storeOrder();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 25, right: 15, bottom: 20, top: 25),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          color: appColor.withOpacity(0.9),
                                          border: Border.all(width: 0.2, color: Colors.grey)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.create_new_folder,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(_isLoading ? "Processing..." : "Place Order",
                                                  style: TextStyle(color: Colors.white, fontSize: 17)))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),

                  /////////////////   profile editing save start ///////////////

                  /////////////////   profile editing save end ///////////////
                ],
              ),
            ),
          );
  }

  void _storeOrder() async {
   
    if (mobile1Controller.text.isEmpty) {
      return _showMsg("Mobile is empty");
    } else if (houseController.text.isEmpty) {
      return _showMsg("House is empty");
    }
    else if (roadController.text.isEmpty) {
      return _showMsg("Road is empty");
    } else if (blockController.text.isEmpty) {
      return _showMsg("Block is empty");
    } else if (areaController.text.isEmpty) {
      return _showMsg("Area is empty");
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      'firstName': firstController.text,
      'lastName': lastController.text,
      'mobile1': mobile1Controller.text,
      'mobile2': mobile2Controller.text,
      'date': date,
      'discount': discountController.text,
      'customerId': customerId,
      'subTotal': subTotal,
      'paymentType': payTypeController.text,
      'grandTotal': total,
      'shippingPrice': shippingCostController.text,
      'house': houseController.text,
      'street': streetController.text,
      'road': roadController.text,
      'block': blockController.text,
      'area': areaController.text,
      'city': cityController.text,
      'state': stateController.text,
      'country': countryController.text,
      'cartProducts': cartData,
      'note': noteController.text
    };

    var res = await CallApi().postData(data, '/app/storeOrder');

    var body = json.decode(res.body);

    print(body);


    if (res.statusCode == 200) {
      productData = [];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('cartList', json.encode(productData));

      Navigator.push(context, FadeRoute(page: OrderList()));
    } else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _deleteCart(d, int i) async {

    productData.removeAt(i);

    setState(() {
      total = subTotal + shipping - discount;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('cartList', json.encode(productData));
    _showCart();
  }

  void _dataCrud(var d, int i) async {
    productData.removeAt(i);
    productData.insert(i, d);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('cartList', json.encode(productData));
    _showCart();
  }

  List<Widget> _showProductsList() {
    List<Widget> list = [];
    for (var d in userData) {
      list.add(GestureDetector(
        onTap: () {
          setState(() {
            customerId = d.id == null ? "" : d.id;
            customerIdController.text = d.firstName + " " + d.lastName;
            firstController.text = d.firstName == null ? "" : d.firstName;
            lastController.text = d.lastName == null ? "" : d.lastName;
            mobile1Controller.text = d.email == null ? "" : d.email;
            houseController.text = d.house == null ? "" : d.house;
            streetController.text = d.street == null ? "" : d.street;
            roadController.text = d.road == null ? "" : d.road;
            blockController.text = d.block == null ? "" : d.block.toString();
            areaController.text = d.area == null ? "" : d.area;
            stateController.text = d.city == null ? "" : d.city;
            cityController.text = d.state == null ? "" : d.state;
            countryController.text = d.country == null ? "" : d.country;
            discountController.text = d.discount == null ? "" : d.discount;
            // productId = d.id;
            _product = true;
          });

          //  Navigator.push(context, SlideLeftRoute(page: ProductVariablePage(d)));
        },
        child: _product
            ? Container()
            : Card(
                margin: EdgeInsets.only(left: 15, right: 15, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        // width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(12.0),
                        child: Text('${d.firstName}' " " '${d.lastName}'),
                      ),
                    ),

                    //  Icon(

                    //    Icons.chevron_right
                    //  )
                  ],
                ),
              ),
      ));
    }

    return list;
  }
}
