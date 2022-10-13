import 'dart:convert';

import 'package:bahrain_admin/KeyValueModel.dart';
import 'package:bahrain_admin/Model/AddProductSearchModel/AddProductSearchModel.dart';
import 'package:bahrain_admin/Model/AllVariationModel/AllVariationModel.dart';
import 'package:bahrain_admin/Screen/ShowCouponList/ShowCouponList.dart';
import 'package:bahrain_admin/Screen/ShowNewVariationList/ShowNewVariationList.dart';
import 'package:bahrain_admin/Screen/ShowProductVariationList/ShowProductVariationList.dart';
import 'package:bahrain_admin/Screen/ShowVariableCombitionList/ShowVariableCombitionList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCoupon extends StatefulWidget {
  @override
  _AddCouponState createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController couponController = new TextEditingController();
  TextEditingController discountController = new TextEditingController();
  TextEditingController counterController = new TextEditingController();
  bool _isLoading = false;
  var searchData;
  bool _isSearch = false;
  bool _product = false;
  String _couponType = "";
  var productId;
  String categoryName = "";
  var categoryId = "";
  String date = "";
  KeyValueModel categoryModel;
  List<KeyValueModel> categoryList = <KeyValueModel>[];
  var body;
  var variationData;

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
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  var format;

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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Coupon"),
        backgroundColor: appColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 15, top: 20, right: 15),
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    margin:
                        EdgeInsets.only(left: 15, bottom: 8, top: 8, right: 15),
                    child: Text("Coupon Code",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: appColor, fontSize: 15))),
                Container(
                    margin: EdgeInsets.only(left: 15, top: 0, right: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.grey[100],
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    child: TextField(
                      cursorColor: Colors.grey,
                      controller: couponController,
                      keyboardType: TextInputType.text,
                      // autofocus: true,
                      style: TextStyle(color: Colors.grey[600]),
                      decoration: InputDecoration(
                        // hintText: "Search Here",
                        // labelText: label,
                        // labelStyle: TextStyle(color: appColor),
                        contentPadding:
                            EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                        border: InputBorder.none,
                      ),
                      //autofocus: true,
                    )),

                Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                            left: 15, bottom: 8, top: 20, right: 15),
                        child: Text("Discount %",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: appColor, fontSize: 15))),
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 0, right: 15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.grey[100],
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: TextField(
                          cursorColor: Colors.grey,
                          controller: discountController,
                          keyboardType: TextInputType.number,
                          // autofocus: true,
                          style: TextStyle(color: Colors.grey[600]),
                          decoration: InputDecoration(
                            // hintText: "Search Here",
                            // labelText: label,
                            // labelStyle: TextStyle(color: appColor),
                            contentPadding:
                                EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                            border: InputBorder.none,
                          ),
                          //autofocus: true,
                        )),
                  ],
                ),

                Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                            left: 15, bottom: 8, top: 20, right: 15),
                        child: Text("Coupon Type",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: appColor, fontSize: 15))),
                    Row(
                      children: <Widget>[
                        Container(
                            child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _couponType = "counter";
                                });
                              },
                              icon: Icon(
                                _couponType == "counter"
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: appColor,
                              ),
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    left: 0, bottom: 8, top: 7, right: 15),
                                child: Text("Counter",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: appColor, fontSize: 15))),
                          ],
                        )),

                        ////// validity//

                        Container(
                            child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _couponType = "validity";
                                });
                              },
                              icon: Icon(
                                _couponType == "validity"
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: appColor,
                              ),
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    left: 0, bottom: 8, top: 7, right: 15),
                                child: Text("Validity",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: appColor, fontSize: 15))),
                          ],
                        ))
                      ],
                    )
                  ],
                ),

                ///////////////////////    type details//////////////

                _couponType == "counter"
                    ? Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  left: 15, bottom: 8, top: 10, right: 15),
                              child: Text("Counter",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: appColor, fontSize: 15))),
                          Container(
                              margin:
                                  EdgeInsets.only(left: 15, top: 0, right: 15),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  color: Colors.grey[100],
                                  border: Border.all(
                                      width: 0.2, color: Colors.grey)),
                              child: TextField(
                                cursorColor: Colors.grey,
                                controller: counterController,
                                keyboardType: TextInputType.number,
                                // autofocus: true,
                                style: TextStyle(color: Colors.grey[600]),
                                decoration: InputDecoration(
                                  // hintText: "Search Here",
                                  // labelText: label,
                                  // labelStyle: TextStyle(color: appColor),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 10.0, 20.0, 15.0),
                                  border: InputBorder.none,
                                ),
                                //autofocus: true,
                              )),
                        ],
                      )
                    :

                    //////////////////  validity/////////////

                    _couponType == "validity"
                        ? Column(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      left: 15, bottom: 8, top: 20, right: 15),
                                  child: Text("Validity",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: appColor, fontSize: 15))),
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: Colors.grey[100],
                                    border: Border.all(
                                        width: 0.2, color: Colors.grey)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        date.toString(),
                                        textAlign: TextAlign.right,
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                      icon: Icon(Icons.calendar_today),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                GestureDetector(
                  onTap: () {
                    _isLoading ? null : _addNewCoupon();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 25, right: 15, bottom: 20, top: 50),
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
                            child: Text(_isLoading ? "Creating..." : "Create",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addNewCoupon() async {
    if (couponController.text.isEmpty) {
      return _showMsg("Coupon is empty");
    } 
    else if (discountController.text.isEmpty) {
      return _showMsg("Discount is empty");
    }
    else if ( _couponType=="") {
      return _showMsg("Select counter type");
    }
    else if ( _couponType=="validity" && date=="") {
      return _showMsg("Validity date is empty");
    }
    else if ( _couponType=="counter" && counterController.text.isEmpty) {
      return _showMsg("Counter is empty");
    }
   

    setState(() {
      _isLoading = true;
    });

    //categoryId = categoryId.toString();

    var data = {
      "code": couponController.text,
      "discount": discountController.text,
      "validity": date,
      "type": _couponType,
      "counter": counterController.text
    };

    print(data);

    var res = await CallApi().postData(data, '/app/insertCoupon');
     var body = json.decode(res.body);
    print(body);
    if(res.statusCode == 422){
   
    _showMsg(body['message']);
     }
    else{

    //if (body['success'] == true) {
   if (res.statusCode == 200) {
      // print("sucvsss");
      //   SharedPreferences localStorage = await SharedPreferences.getInstance();
      //   localStorage.setString('token', body['token']);
      // //  localStorage.setString('pass', loginPasswordController.text);
      //   localStorage.setString('user', json.encode(body['user']));

   Navigator.push( context, FadeRoute(page: ShowCouponList()));
    } else {
      _showMsg("Something is wrong! Try Again");
    }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
