import 'dart:convert';
import 'dart:io';

import 'package:bahrain_admin/Model/ShippingCostModel/ShippingCostModel.dart';
import 'package:bahrain_admin/Model/UserModel/UserModel.dart';
import 'package:bahrain_admin/ProductOrder/ProductOrder.dart';
import 'package:bahrain_admin/Screen/OrderPage/OrderList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

enum PhotoCrop {
  free,
  picked,
  cropped,
}

class AddOrderForm extends StatefulWidget {
  @override
  _AddOrderFormState createState() => _AddOrderFormState();
}

class _AddOrderFormState extends State<AddOrderForm> {
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
  String phoneCodeNum = "";

  String voucher = "",
      name = "",
      phone = "",
      price = "",
      quantity = "",
      area = "",
      house = "",
      road = "",
      block = "",
      city = "",
      stateAdd = "",
      countrys = "",
      curDate = "";

  bool _isAddress = false;

  var taxStatus;
  var taxAmount;

  String validity;
  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  String countryName = "";
  String countryNameDefault = "";

  List contList = [];
  List contListBahrain = [];
  List<DropdownMenuItem<String>> _dropDownCountryItems;
  List<DropdownMenuItem<String>> _dropDownCountryItemsBahrain;

  List<DropdownMenuItem<String>> getDropDownCountryItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String countryList in contList) {
      // print(object)
      items.add(new DropdownMenuItem(
          value: countryList,
          child: new Text(
            countryList,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownCountryItemsBahrain() {
    List<DropdownMenuItem<String>> items = new List();
    for (String countryList in contListBahrain) {
      // print(object)
      items.add(new DropdownMenuItem(
          value: countryList,
          child: new Text(
            countryList,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, color: Colors.black),
          )));
    }
    return items;
  }

  ////////// Image Picker//////
  PhotoCrop state;
  File imageFile;
  String image;
  var imagePath;
  bool _product = false;
  bool _isSearch = false;
  String date = "";
  String orderType = "";

  List phnList = [];

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
  bool _isUser = false;
  var customerId;
  var now;
  var productsData;

  var discountVal = 0;

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

  @override
  void initState() {
    _showTax();
    String counNameBahrain = "";
    String phone = "";
    for (int i = 0; i < country.length; i++) {
      contListBahrain.add("${country[i]['name']}");
      phnList.add("${country[i]['phoneCode']}");
      setState(() {
        if (country[i]['name'] == "Bahrain") {
          counNameBahrain = "${country[i]['name']}";
          phone = "${country[i]['phoneCode']}";
        }
      });
    }

    _dropDownCountryItemsBahrain = getDropDownCountryItemsBahrain();
    setState(() {
      countryNameDefault = counNameBahrain;
      phoneCodeNum = phone;
    });

    now = DateTime.now();

    state = PhotoCrop.free;
    date = "${DateFormat("yyyy-MM-dd").format(now)}";
    discountController.text = "0";
    _showShippingCost();
    _showCart();
    super.initState();
  }

  ///////////  get tax
  Future<void> _showTax() async {
    var res = await CallApi().getData('/app/getAllTax');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        taxStatus = body['alltax'][0]['isOn'];
        taxAmount = body['alltax'][0]['tax'];

        _isLoading = false;
      });
      print(taxAmount);
    }
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
      _isUser = true;
    });
    var users = UserModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      userData = users.user;
      _isLoading = false;
      _isSearch = true;
      _product = false;
      _isUser = false;
    });

    print(userData);
  }

  Future<void> _showUser() async {
    var key = 'user-list';
    await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/getAllCoustomersWithAddress?name=${customerIdController.text}');
    body = json.decode(res.body);

    //   print(body);

    if (res.statusCode == 200) {
      _bestProductsState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  //////////////// get  user end ///////////////

  //////////////// get  shipping cost start ///////////////

  Future _getLocalCostProductsData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localcostProductsData = localStorage.getString(key);
    if (localcostProductsData != null) {
      body = json.decode(localcostProductsData);
      _costProductsState();
    }
  }

  void _costProductsState() {
    var products = ShippingCostModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      productsData = products.shiping;
      shippingCostController.text = productsData.price.toString();
      _isLoading = false;
    });

    // print(productsData);
  }

  Future<void> _showShippingCost() async {
    var key = 'shipping-cost';
    await _getLocalCostProductsData(key);

    var res = await CallApi().getData('/app/getShipingPrice');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _costProductsState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  //////////////// get  shipping cost end ///////////////

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
    final DateTime picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = "${DateFormat("yyyy-MM-dd").format(selectedDate)}";
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                                shippingCostController.text == "" ? shipping = 0 : shipping = double.parse(shippingCostController.text);

                                discountController.text == "" ? discount = 0 : discount = double.parse(discountController.text);

                                discount = discount / 100;
                                discount = (subTotal * discount).toDouble();

                                total = subTotal + shipping - discount.toDouble();

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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            cartData[index]['img'] == ""
                                                ? ClipOval(
                                                    child: Image.asset(
                                                    'assets/images/placeholder-image.png',
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.cover,
                                                  ))
                                                : ClipOval(
                                                    child: Image.network(
                                                      cartData[index]['img'],
                                                      height: 50,
                                                      width: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(right: 10, left: 10),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width / 3,
                                                    padding: EdgeInsets.only(top: 8, bottom: 3),
                                                    child: Text(
                                                      cartData[index]['name'],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: "sourcesanspro",
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.normal),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(right: 10, left: 10),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width / 3,
                                                    padding: EdgeInsets.only(top: 8, bottom: 3),
                                                    child: Text(
                                                      cartData[index]['combination'],
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
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
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
                                                          padding: EdgeInsets.all(4),
                                                          child: Icon(
                                                            Icons.remove,
                                                            color: appColor,
                                                            //size: 13,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 5, left: 2, right: 2),
                                                        child: Text(
                                                          cartData[index]['quantity'].toString(),
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontFamily: "sourcesanspro",
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (cartData[index]['quantity'] < cartData[index]['stock']) {
                                                            setState(() {
                                                              cartData[index]['quantity'] = cartData[index]['quantity'] + 1;
                                                              cartData[index]['total'] = cartData[index]['quantity'] * (cartData[index]['price']);

                                                              subTotal = subTotal + cartData[index]['total'];
                                                            });
                                                          } else {
                                                            Toast.show("No more stock available", context,
                                                                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                                                          }

                                                          _dataCrud(cartData[index], index);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(5),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: appColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 20),
                                        alignment: Alignment.topRight,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: GestureDetector(
                                                child: Icon(
                                                  Icons.delete,
                                                  color: appColor,
                                                ),
                                                onTap: () {
                                                  _deleteOrder(cartData[index], index);
                                                },
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(top: 2, left: 8),
                                              child: Text(
                                                cartData[index]['total'].toString() + " BHD",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: appColor, fontFamily: "sourcesanspro", fontSize: 16, fontWeight: FontWeight.normal),
                                              ),
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
                                      style: TextStyle(color: Colors.black, fontFamily: "sourcesanspro", fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      // "\$ 78",
                                      "${(subTotal).toStringAsFixed(2)} BHD",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black, fontFamily: "sourcesanspro", fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            /////////////  Subtotal end ////////////

                            ////////////////   Discount Start   ////////////

                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  //     border: Border(
                                  //   top: BorderSide(
                                  //     color: Colors.grey,
                                  //     width: 1.5,
                                  //   ),
                                  // )
                                  ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "User Discount",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red, fontFamily: "sourcesanspro", fontSize: 15, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      //"\$ 5678",
                                      discountController.text + "%",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red, fontFamily: "sourcesanspro", fontSize: 17, fontWeight: FontWeight.normal),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            /////////////  Discount End  ////////////

                            ////////////////   Shipping Start   ////////////

                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 10),
                              decoration: BoxDecoration(
                                  //     border: Border(
                                  //   top: BorderSide(
                                  //     color: Colors.grey,
                                  //     width: 1.5,
                                  //   ),
                                  // )
                                  ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Shipping Cost",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black, fontFamily: "sourcesanspro", fontSize: 15, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      //"\$ 5678",
                                      shippingCostController.text + " BHD",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black, fontFamily: "sourcesanspro", fontSize: 17, fontWeight: FontWeight.normal),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            /////////////  Shipping End  ////////////

                            ////////////////   tax Start   ////////////

                            _isLoading
                                ? Container()
                                : taxStatus == 0
                                    ? Container()
                                    : Container(
                                        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                        decoration: BoxDecoration(
                                            //     border: Border(
                                            //   top: BorderSide(
                                            //     color: Colors.grey,
                                            //     width: 1.5,
                                            //   ),
                                            // )
                                            ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    "Tax",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "sourcesanspro",
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.normal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              child: Text(
                                                //"\$ 5678",
                                                taxAmount == null ? "0%" : "" + taxAmount.toString() + "%",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black, fontFamily: "sourcesanspro", fontSize: 17, fontWeight: FontWeight.normal),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                            /////////////  tax End  ////////////
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
                                      style: TextStyle(color: Colors.black, fontFamily: "sourcesanspro", fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      //"\$ 5678",
                                      "${(total).toStringAsFixed(2)} BHD",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black, fontFamily: "sourcesanspro", fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            /////////////  Total End  ////////////
                            ///
                            ///
                            // addUserCon(
                            //           "Payment Type", "", payTypeController, TextInputType.text),

                            ////////////   warrenty end

                            SizedBox(height: 15),

                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      //"\$ 5678",
                                      "Select which type order you want ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: appColor, fontFamily: "sourcesanspro", fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  /////////  user /////////
                                  Container(
                                    margin: EdgeInsets.only(top: 15, bottom: 10),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              orderType = "user";
                                              _product = false;
                                              countryName = "";

                                              contList = [];
                                            });
                                          },
                                          child: Icon(
                                            orderType == "user" ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                            color: appColor,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            //"\$ 5678",
                                            "Order for registered user",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black, fontFamily: "sourcesanspro", fontSize: 17, fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  /////////// guest///////
                                  Container(
                                    margin: EdgeInsets.only(top: 15, bottom: 10),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              orderType = "anonymous";
                                              customerId = "";
                                              customerIdController.text = "";
                                              firstController.text = "user";
                                              lastController.text = "user";
                                              mobile1Controller.text = "";
                                              mobile2Controller.text = "";
                                              houseController.text = "";
                                              streetController.text = "";
                                              roadController.text = "";
                                              blockController.text = "";
                                              areaController.text = "";
                                              stateController.text = "";
                                              cityController.text = "";
                                              discountController.text = "0";
                                              // countryController.text = "";

                                              //print(countryName);
                                            });
                                          },
                                          child: Icon(
                                            orderType == "anonymous" ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                            color: appColor,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            //"\$ 5678",
                                            "Order for anonymous user",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black, fontFamily: "sourcesanspro", fontSize: 17, fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),

                            orderType == "anonymous"
                                ? Column(
                                    children: <Widget>[
                                      addUserCon("First Name", "", firstController, TextInputType.text),
                                      addUserCon("Last Name", "", lastController, TextInputType.text),
                                      Container(
                                          //width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.only(left: 25, right: 15, top: 10, bottom: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    color: Colors.grey[100],
                                                    border: Border.all(width: 0.2, color: Colors.grey)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Code ",
                                                        style: TextStyle(color: appColor, fontSize: 14),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 16),
                                                      child: Text(
                                                        phoneCodeNum,
                                                        style: TextStyle(color: appColor, fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                    width: MediaQuery.of(context).size.width / 2,
                                                    margin: EdgeInsets.only(left: 8, top: 0),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                        color: Colors.grey[100],
                                                        border: Border.all(width: 0.2, color: Colors.grey)),
                                                    child: TextField(
                                                      cursorColor: Colors.grey,
                                                      controller: mobile1Controller,
                                                      keyboardType: TextInputType.number,
                                                      autofocus: true,
                                                      enabled: true,
                                                      style: TextStyle(color: Colors.black54),
                                                      decoration: InputDecoration(
                                                        hintText: "",
                                                        labelText: 'Mobile Number 1',
                                                        labelStyle: TextStyle(color: appColor),
                                                        contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                                                        border: InputBorder.none,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          )),

                                      /// mobile 2//
                                      Container(
                                          //width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.only(left: 25, right: 15, top: 10, bottom: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    color: Colors.grey[100],
                                                    border: Border.all(width: 0.2, color: Colors.grey)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Code ",
                                                        style: TextStyle(color: appColor, fontSize: 14),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 16),
                                                      child: Text(
                                                        phoneCodeNum,
                                                        style: TextStyle(color: appColor, fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                    width: MediaQuery.of(context).size.width / 2,
                                                    margin: EdgeInsets.only(left: 8, top: 0),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                        color: Colors.grey[100],
                                                        border: Border.all(width: 0.2, color: Colors.grey)),
                                                    child: TextField(
                                                      cursorColor: Colors.grey,
                                                      controller: mobile2Controller,
                                                      keyboardType: TextInputType.number,
                                                      autofocus: true,
                                                      enabled: true,
                                                      style: TextStyle(color: Colors.black54),
                                                      decoration: InputDecoration(
                                                        hintText: "",
                                                        labelText: 'Mobile Number 2',
                                                        labelStyle: TextStyle(color: appColor),
                                                        contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                                                        border: InputBorder.none,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          )),
                                      //  addUserCon("Mobile Number 2", "", mobile2Controller,
                                      //      TextInputType.number),
                                      addOrderCon("Shipping Cost", "", shippingCostController, TextInputType.number),
                                      addOrderCon("Discount", "", discountController, TextInputType.number),
                                      addUserCon("Area", "", areaController, TextInputType.text),
                                      addUserCon("House", "", houseController, TextInputType.text),
                                      addUserCon("Road", "", roadController, TextInputType.text),
                                      addUserCon("Block", "", blockController, TextInputType.text),

                                      addUserCon("Street", "", streetController, TextInputType.text),

                                      addUserCon("State", "", stateController, TextInputType.text),
                                      addUserCon("City", "", cityController, TextInputType.text),

                                      Column(
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(left: 25, top: 8),
                                              child: Text("Country", textAlign: TextAlign.left, style: TextStyle(color: appColor, fontSize: 13))),
                                          Container(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                            child: Container(
                                              margin: EdgeInsets.only(left: 8, top: 0),
                                              padding: EdgeInsets.only(left: 15, top: 0),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                  color: Colors.grey[100],
                                                  border: Border.all(width: 0.2, color: Colors.grey)),
                                              child: Container(
                                                //  child: Text(countryName),
                                                child: DropdownButtonHideUnderline(
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    child: DropdownButton(
                                                      isExpanded: true,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                      value: countryNameDefault,
                                                      items: _dropDownCountryItemsBahrain,
                                                      onChanged: (String value) {
                                                        setState(() {
                                                          countryName = value;
                                                        });
                                                        print("object1");
                                                        print(countryName);

                                                        for (int i = 0; i < contListBahrain.length; i++) {
                                                          if (country[i]['name'] == countryName) {
                                                            setState(() {
                                                              phoneCodeNum = phnList[i];
                                                              countryNameDefault = countryName;
                                                            });
                                                            break;
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      addUserCon("Note", "", noteController, TextInputType.text),
                                    ],
                                  )
                                : Column(children: <Widget>[
                                    orderType == "" || orderType == "anonymous"
                                        ? Container()
                                        : Container(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                    alignment: Alignment.topLeft,
                                                    margin: EdgeInsets.only(left: 10, bottom: 8),
                                                    child: Text("Select Customer Name",
                                                        textAlign: TextAlign.left, style: TextStyle(color: appColor, fontSize: 13))),
                                                Container(
                                                    margin: EdgeInsets.only(left: 8, top: 0),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                        color: Colors.grey[100],
                                                        border: Border.all(width: 0.2, color: Colors.grey)),
                                                    child: TextField(
                                                      cursorColor: Colors.grey,
                                                      controller: customerIdController,
                                                      keyboardType: TextInputType.text,
                                                      style: TextStyle(color: Colors.grey[600]),
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                                                        border: InputBorder.none,
                                                      ),
                                                      onChanged: (val) {
                                                        if (!mounted) return;
                                                        setState(() {
                                                          if (customerIdController.text == "") {
                                                            contList = [];
                                                            countryName = "";
                                                          }

                                                          _showUser();
                                                        });
                                                      },
                                                    )),
                                              ],
                                            )),
                                    _isUser
                                        ? Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(left: 20, bottom: 8, top: 20, right: 15),
                                            child: Text("Please wait...",
                                                textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontSize: 13)))
                                        : _isSearch
                                            ? Column(mainAxisAlignment: MainAxisAlignment.start, children: _userList())
                                            : Container(),
                                    _product == true
                                        ? Column(
                                            children: <Widget>[
                                              addUserCon("First Name", "", firstController, TextInputType.text),
                                              addUserCon("Last Name", "", lastController, TextInputType.text),
                                              Container(
                                                  //width: MediaQuery.of(context).size.width,
                                                  padding: EdgeInsets.only(left: 25, right: 15, top: 10, bottom: 10),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                            color: Colors.grey[100],
                                                            border: Border.all(width: 0.2, color: Colors.grey)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                "Code ",
                                                                style: TextStyle(color: appColor, fontSize: 14),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 16),
                                                              child: Text(
                                                                phoneCodeNum,
                                                                style: TextStyle(color: appColor, fontSize: 12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                            width: MediaQuery.of(context).size.width / 2,
                                                            margin: EdgeInsets.only(left: 8, top: 0),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                color: Colors.grey[100],
                                                                border: Border.all(width: 0.2, color: Colors.grey)),
                                                            child: TextField(
                                                              cursorColor: Colors.grey,
                                                              controller: mobile1Controller,
                                                              keyboardType: TextInputType.number,
                                                              autofocus: true,
                                                              enabled: true,
                                                              style: TextStyle(color: Colors.black54),
                                                              decoration: InputDecoration(
                                                                hintText: "",
                                                                labelText: 'Mobile Number 1',
                                                                labelStyle: TextStyle(color: appColor),
                                                                contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                                                                border: InputBorder.none,
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  )),

                                              /// mobile 2//
                                              Container(
                                                  //width: MediaQuery.of(context).size.width,
                                                  padding: EdgeInsets.only(left: 25, right: 15, top: 10, bottom: 10),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                            color: Colors.grey[100],
                                                            border: Border.all(width: 0.2, color: Colors.grey)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                "Code ",
                                                                style: TextStyle(color: appColor, fontSize: 14),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 16),
                                                              child: Text(
                                                                phoneCodeNum,
                                                                style: TextStyle(color: appColor, fontSize: 12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                            width: MediaQuery.of(context).size.width / 2,
                                                            margin: EdgeInsets.only(left: 8, top: 0),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                color: Colors.grey[100],
                                                                border: Border.all(width: 0.2, color: Colors.grey)),
                                                            child: TextField(
                                                              cursorColor: Colors.grey,
                                                              controller: mobile2Controller,
                                                              keyboardType: TextInputType.number,
                                                              autofocus: true,
                                                              enabled: true,
                                                              style: TextStyle(color: Colors.black54),
                                                              decoration: InputDecoration(
                                                                hintText: "",
                                                                labelText: 'Mobile Number 2',
                                                                labelStyle: TextStyle(color: appColor),
                                                                contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                                                                border: InputBorder.none,
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  )),
                                              addOrderCon("Shipping Cost", "", shippingCostController, TextInputType.number),
                                              addOrderCon("Discount", "", discountController, TextInputType.number),
                                              addUserCon("Area", "", areaController, TextInputType.text),
                                              addUserCon("House", "", houseController, TextInputType.text),
                                              addUserCon("Road", "", roadController, TextInputType.text),
                                              addUserCon("Block", "", blockController, TextInputType.text),

                                              addUserCon("Street", "", streetController, TextInputType.text),

                                              addUserCon("State", "", stateController, TextInputType.text),
                                              addUserCon("City", "", cityController, TextInputType.text),

                                              Column(
                                                children: <Widget>[
                                                  Container(
                                                      alignment: Alignment.topLeft,
                                                      margin: EdgeInsets.only(left: 25, top: 8),
                                                      child: Text("Country",
                                                          textAlign: TextAlign.left, style: TextStyle(color: appColor, fontSize: 13))),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                                    child: Container(
                                                      margin: EdgeInsets.only(left: 8, top: 0),
                                                      padding: EdgeInsets.only(left: 15, top: 0),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                          color: Colors.grey[100],
                                                          border: Border.all(width: 0.2, color: Colors.grey)),
                                                      child: Container(
                                                        //  child: Text(countryName),
                                                        child: DropdownButtonHideUnderline(
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width,
                                                            child: DropdownButton(
                                                              isExpanded: true,
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.black,
                                                              ),
                                                              value: countryName,
                                                              items: _dropDownCountryItemsBahrain,
                                                              onChanged: (String value) {
                                                                setState(() {
                                                                  countryName = value;
                                                                });
                                                                print("object1");
                                                                print(countryName);

                                                                for (int i = 0; i < contListBahrain.length; i++) {
                                                                  if (country[i]['name'] == countryName) {
                                                                    setState(() {
                                                                      phoneCodeNum = phnList[i];
                                                                      countryNameDefault = countryName;
                                                                    });
                                                                    break;
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              addUserCon("Note", "", noteController, TextInputType.text),
                                            ],
                                          )
                                        : Container()
                                  ]),

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
                                        child:
                                            Text(_isLoading ? "Processing..." : "Place Order", style: TextStyle(color: Colors.white, fontSize: 17)))
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
          ],
        ),
      ),
    );
  }

  void _storeOrder() async {
    print("data");

    if (orderType == "user" && customerIdController.text.isEmpty) {
      return _showMsg("Select Customer Name");
    } else if (orderType == "user" && firstController.text.isEmpty) {
      return _showMsg("First Name is empty");
    } else if (orderType == "user" && lastController.text.isEmpty) {
      return _showMsg("Last Name is empty");
    } else if (mobile1Controller.text.isEmpty && mobile2Controller.text.isEmpty) {
      return _showMsg("Mobile is empty");
    } else if (shippingCostController.text.isEmpty) {
      return _showMsg("Shipping Cost is empty");
    } else if (areaController.text.isEmpty) {
      return _showMsg("Area is empty");
    } else if (houseController.text.isEmpty) {
      return _showMsg("House is empty");
    } else if (roadController.text.isEmpty) {
      return _showMsg("Road is empty");
    } else if (blockController.text.isEmpty) {
      return _showMsg("Block is empty");
    } else if (orderType == "user" && countryName == "") {
      return _showMsg("Country is empty");
    } else if (orderType == "anonymous" && countryNameDefault == "") {
      return _showMsg("Country is empty");
    } else if (orderType == "anonymous" && customerIdController.text.isEmpty) {
      customerId = 0;
    }
    setState(() {
      _isLoading = true;
    });

    var data = {
      'firstName': firstController.text,
      'lastName': lastController.text,
      'mobile1': mobile1Controller.text.isEmpty ? "" : phoneCodeNum + mobile1Controller.text,
      'mobile2': mobile2Controller.text.isEmpty ? "" : phoneCodeNum + mobile2Controller.text,
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
      'note': noteController.text,
    };

    print(data);

    var res = await CallApi().postData(data, '/app/storeOrder');

    var body = json.decode(res.body);

    print(body);
    print(res.statusCode);

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

  List<Widget> _userList() {
    List<Widget> list = [];
    for (var d in userData) {
      list.add(GestureDetector(
        onTap: () {
          print("countryName");
          print(countryName);
          countryName = "Bahrain";
          setState(() {
            customerId = d.id == null ? "" : d.id;
            customerIdController.text = d.firstName + " " + d.lastName;
            firstController.text = d.firstName == null ? "" : d.firstName;
            lastController.text = d.lastName == null ? "" : d.lastName;

            validity = d.discountValidity == null ? "0000-00-00" : d.discountValidity;
            var validDate = DateTime.parse(validity);

            if (validDate.isAfter(now) == false) {
              discountController.text = "0";
            } else {
              discountController.text = d.discount == null ? "" : d.discount;
            }
            _product = true;
            getAddress(d.delevery_address);
          });
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
                  ],
                ),
              ),
      ));
    }

    return list;
  }

  void _deleteOrder(var d, int i) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Are you sure want to delete this order?",
            style: TextStyle(color: Color(0xFF000000), fontFamily: "grapheinpro-black", fontSize: 14, fontWeight: FontWeight.w500),
          ),
          content: Container(
              height: 70,
              width: 250,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    width: 110,
                    height: 45,
                    margin: EdgeInsets.only(
                      top: 25,
                      bottom: 15,
                    ),
                    child: OutlineButton(
                      child: new Text(
                        "No",
                        style: TextStyle(color: Colors.black),
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      borderSide: BorderSide(color: Colors.black, width: 0.5),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    )),
                Container(
                    decoration: BoxDecoration(
                      color: appColor.withOpacity(0.9),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    width: 110,
                    height: 45,
                    margin: EdgeInsets.only(top: 25, bottom: 15),
                    child: OutlineButton(
                        // color: Colors.greenAccent[400],
                        child: new Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _deleteCart(d, i);
                          // _deleteOrders(d,i);
                        },
                        borderSide: BorderSide(color: Colors.green, width: 0.5),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0))))
              ])),
        );
      },
    );
  }

  void getAddress(newAddList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            title: Container(
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 5, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[new Text("Delivery Addresses"), Container()],
                      )),
                  Divider(
                    height: 0,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
            content: newAddList.length == 0
                ? Center(
                    child: Container(
                      child: Text("No address yet"),
                    ),
                  )
                : Container(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: 40,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(newAddList.length, (index) {
                              return addressesList(newAddList[index], index);
                            })),
                      ),
                    ),
                  ));
      },
    );
  }

  Container addressesList(var newAddList, int index) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 5, top: 0, left: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            Navigator.pop(context);

            mobile1Controller.text = "${newAddList['mobile']}";
            areaController.text = "${newAddList['area']}";
            houseController.text = "${newAddList['house']}";
            roadController.text = "${newAddList['road']}";
            blockController.text = "${newAddList['block']}";
            cityController.text = "${newAddList['city']}";
            stateController.text = "${newAddList['state']}";
            String counName = "";
            for (int i = 0; i < country.length; i++) {
              contList.add("${country[i]['name']}");
              if (country[i]['name'] == "${newAddList['country']}") {
                counName = "${country[i]['name']}";

                phoneCodeNum = "${country[i]['phoneCode']}";
              }
            }

            _dropDownCountryItems = getDropDownCountryItems();

            countryName = counName;
            print(countryName);
            _isAddress = true;
            print(phoneCodeNum);
          });
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 17,
                )
              ],
              color: Colors.white),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 7, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.7,
                                  padding: EdgeInsets.only(top: 8),
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          size: 18,
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              "Address:  ${newAddList['name']}",
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.black, fontFamily: "sourcesanspro", fontSize: 16, fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.9,
                                  margin: EdgeInsets.only(left: 25),
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "Country Code:  ${newAddList['country_code']}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black54, fontFamily: "sourcesanspro", fontSize: 13, fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.9,
                                  margin: EdgeInsets.only(left: 25),
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "Mobile:  ${newAddList['mobile']}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black54, fontFamily: "sourcesanspro", fontSize: 13, fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.9,
                                  margin: EdgeInsets.only(left: 25),
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "Area: ${newAddList['area']}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black54, fontFamily: "sourcesanspro", fontSize: 13, fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.9,
                                  margin: EdgeInsets.only(left: 25),
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "House:${newAddList['house']}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black54, fontFamily: "sourcesanspro", fontSize: 13, fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.9,
                                  margin: EdgeInsets.only(left: 25),
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "Road: ${newAddList['road']}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black54, fontFamily: "sourcesanspro", fontSize: 13, fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.9,
                                  margin: EdgeInsets.only(left: 25),
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "Block: ${newAddList['block']}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black54, fontFamily: "sourcesanspro", fontSize: 13, fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.9,
                                  margin: EdgeInsets.only(left: 25),
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "Country: ${newAddList['country']}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black54, fontFamily: "sourcesanspro", fontSize: 13, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
