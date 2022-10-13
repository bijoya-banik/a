import 'dart:convert';

import 'package:bahrain_admin/KeyValueModel.dart';
import 'package:bahrain_admin/Model/DefaultDriverModel/DefaultDriverModel.dart';
import 'package:bahrain_admin/Model/DriverModel/DriverModel.dart';
import 'package:bahrain_admin/Screen/DriverOrderList/DriverOrderList.dart';
import 'package:bahrain_admin/Screen/OrderPage/OrderList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AssignDriver extends StatefulWidget {
  final data;

  AssignDriver(this.data);
  @override
  _AssignDriverState createState() => _AssignDriverState();
}

class _AssignDriverState extends State<AssignDriver> {
  TextEditingController driverController = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String categoryName = "";
  var categoryId = "";
  bool _isData = false;
  // var userId;
  // var customerId;
  // var categorysData;
  KeyValueModel categoryModel;
  List<KeyValueModel> categoryList = <KeyValueModel>[];
  bool _isLoading = false;
  var driverData;

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

  var body;

  List _driver = [];
  var _currentAddressSelected;
  var defaultDriver;
  var defaultDriverName;
  var defaultDriverId;


  @override
  void initState() {
    // _showDriver();
    _getLocalBestProductsData("driver-list");
    _showDefaultDriver();
    //  if(  visitDriver =="driverOrder"){
    //      categoryName =  widget.data.firstName==null &&  widget.data.lastName==null?"":
    //  widget.data.firstName+" "+widget.data.lastName;
    // }
    // else if(  visitDriver =="myOrder"){


   

    // print(categoryId);
    // print(widget.data.customerId);
    //driverId = "driver";
    // }

    // widget.data.firstName==null &&  widget.data.lastName==null?"":
    // widget.data.firstName+" "+widget.data.lastName;
    // hintText = widget.data.status==null?"":widget.data.status;
    super.initState();
  }

  //////////////// get  driver start ///////////////

  Future _getLocalOrderData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localOrderData = localStorage.getString(key);
    if (localOrderData != null) {
      body = json.decode(localOrderData);
      _orderState();
    }
  }

  void _orderState() {
    var driver = DefaultDriverModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      defaultDriver = driver.driver;
      defaultDriverId  = driver.driver.id;
      var first = driver.driver.firstName==null?"":driver.driver.firstName;
      var last = driver.driver.lastName==null?"":driver.driver.lastName;
      defaultDriverName  = first + " " +last;
      _isLoading = false;
       categoryName = widget.data.driver == null
        ? defaultDriverName
        : widget.data.driver.firstName == null &&
                widget.data.driver.lastName == null
            ? ""
            : widget.data.driver.firstName + " " + widget.data.driver.lastName;

    categoryId = widget.data.driver == null
        ? defaultDriverId.toString()
        : widget.data.driver.id == null ? "" : widget.data.driver.id.toString();
    });

   //  print(defaultDriverName);
    // print(_sendType);
  }

  Future<void> _showDefaultDriver() async {
    var key = 'default-driver-list';
    await _getLocalOrderData(key);

    var res = await CallApi().getData(
        '/app/getDefaultDriver'); //order=$_currentStatusSelected,$_sendType');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _orderState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  //////////////// get  driver end ///////////////

  Future _getLocalBestProductsData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localbestProductsData = localStorage.getString(key);
    if (localbestProductsData != null) {
      body = json.decode(localbestProductsData);
      _bestProductsState();
    }
  }

  void _bestProductsState() {
    var statuses = DriverModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      _isLoading = true;

      driverData = statuses.driver;

      for (int i = 0; i < driverData.length; i++) {
        //_status.add(statusData[i].name);
        categoryList.add(
            //{
            // 'name' : "${store.state.categoryListsRedux[i].categoryName}",
            // 'id' : "${store.state.categoryListsRedux[i].id}",
            //  },
            KeyValueModel(
                key: driverData[i].firstName == null &&
                        driverData[i].lastName == null
                    ? ""
                    : "${driverData[i].firstName} ${driverData[i].lastName}",
                value: "${driverData[i].id}"));
      }

      _isLoading = false;
    });

    print(_driver);
  }

  // Future<void> _showDriver() async {
  // //  var key = 'driver-list';
  //  // await _getLocalBestProductsData(key);

  //   var res = await CallApi().getData('/app/indexUserDriver');
  //   body = json.decode(res.body);

  //   if (res.statusCode == 200) {
  //     _bestProductsState();

  //     // SharedPreferences localStorage = await SharedPreferences.getInstance();
  //     // localStorage.setString(key, json.encode(body));
  //   }
  // }

  //////////////// get  status end ///////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text("Assign Driver"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10, bottom: 8, top: 10),
                          child: Text("Driver",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: appColor, fontSize: 15))),

                  _isLoading?
                   Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10, bottom: 8, top: 10),
                          child: Text("Please wait.....",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.grey, fontSize: 13))):
                    Container(
                        //color: Colors.yellow,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 6, bottom: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ////////////   category Dropdown ///////////

                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 42,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  color: Colors.grey[100],
                                  border: Border.all(
                                      width: 0.2, color: Colors.grey)),
                              //  borderRadius: BorderRadius.circular(20),
                              // color: Colors.white),
                              // alignment: Alignment.center,
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  minWidth: 10,
                                  //  height: 10,
                                  alignedDropdown: true,
                                  child: DropdownButton<KeyValueModel>(
                                    items:
                                        categoryList.map((KeyValueModel user) {
                                      return new DropdownMenuItem<
                                          KeyValueModel>(
                                        value: user,
                                        child: new Text(
                                          user.key,
                                          style: new TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                    // items: categoryNameList
                                    //     .map((data) => DropdownMenuItem<String>(
                                    //           child: Text(data.key),
                                    //          // key: data.key.,
                                    //           value: data.key,
                                    //         ))
                                    //     .toList(),
                                    onChanged: (KeyValueModel value) {
                                      setState(() {
                                        categoryModel = value;
                                        categoryName = categoryModel.key;
                                        categoryId = categoryModel.value;
                                        //   categoryId = categoryModel.value;

                                        // subcategoryList = [];
                                        // subcategoryName = "";
                                      });

                                      //_showsubCategory();
                                    },

                                    value: categoryModel,
                                    hint: Text(categoryName),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //     margin: EdgeInsets.only(left: 8, top: 0),
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      //         color: Colors.grey[100],
                      //         border: Border.all(width: 0.2, color: Colors.grey)),
                      //     child: TextField(
                      //       cursorColor: Colors.grey,
                      //       controller: driverController,
                      //       keyboardType: TextInputType.text,
                      //       onChanged: (val) {
                      //         if (!mounted) return;
                      //         setState(() {});
                      //       },
                      //       // autofocus: true,
                      //       style: TextStyle(color: Colors.grey[600]),
                      //       decoration: InputDecoration(
                      //         //hintText: hint,
                      //         // labelText: label,
                      //         // labelStyle: TextStyle(color: appColor),
                      //         contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                      //         border: InputBorder.none,
                      //       ),
                      //     )),
                    ],
                  ),

                  /////////////////   profile editing save start ///////////////

                  GestureDetector(
                    onTap: () {
                      _isData ? null : _assignOrder();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 25, right: 15, bottom: 20, top: 40),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: appColor.withOpacity(0.9),
                          border: Border.all(width: 0.2, color: Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.drive_eta,
                            size: 20,
                            color: Colors.white,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(_isData ? "Assigning..." : "Assign",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)))
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _assignOrder() async {
    if (categoryId == "") {
      return _showMsg("Driver is empty");
    }

    setState(() {
      _isData = true;
    });

    var data = {
      'id': widget.data.id,
      'driverId': categoryId,
      'customerId': widget.data.customerId,
      'status': 'Assigned to driver'
    };

    print(data);
    print(categoryName);

    var res = await CallApi().postData(data, '/app/editOrder');

    var body = json.decode(res.body);
    //   print("body");

    print(body);

    if (body['success'] == true) {
      //     Navigator.of(context).pop();
      // // print("success");

      if (visitDriver == "myOrder") {
        // Toast.show("Driver Changed Successfully", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        Navigator.push( context, FadeRoute(page: OrderList()));
      } else if (visitDriver == "driverOrder") {
        driverId = "driver";
      Navigator.push( context, FadeRoute(page: DriverOrderList(widget.data)));
       
      }

      null;
    } else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isData = false;
    });
  }
}
