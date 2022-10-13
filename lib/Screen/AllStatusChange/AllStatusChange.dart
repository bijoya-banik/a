import 'dart:convert';

import 'package:bahrain_admin/Model/DefaultDriverModel/DefaultDriverModel.dart';
import 'package:bahrain_admin/Model/DriverModel/DriverModel.dart';
import 'package:bahrain_admin/Model/StatusModel/StatusModel.dart';
import 'package:bahrain_admin/Screen/OrderPage/OrderList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../KeyValueModel.dart';

class AllChangeStatus extends StatefulWidget {
  final data;

  AllChangeStatus(this.data);
  @override
  _AllChangeStatusState createState() => _AllChangeStatusState();
}

class _AllChangeStatusState extends State<AllChangeStatus> {
  // TextEditingController driverController = new TextEditingController();
  ///// Address Drop Down////////
  // var _address = [
  //   'Sylhet',
  //   'Dhaka',
  //   'Barishal',
  //   'Chittagong',
  //   'Rangpur',
  //   'Rajshahi',
  //   'Khulna'
  // ];
  bool _isOrderStatusLoading = false;
  var assignId = "";
  bool assignDriverStatus = false;
  bool _isData = false;
  bool _driverfound = false;
  String drivername = "";
  String categoryName = "";
  var categoryId = "";
  var sendStatus = "";

  bool _isDriverLoading = false;
  var searchData;
  bool _isSearch = false;

  Future<void> _search(String value) async {
    setState(() {
      _isDriverLoading = true;
      _isSearch = true;
      _driverfound = false;
    });

    var urlStr = '/app/indexUserDriver?search=$value';

    var res = await CallApi().getData(urlStr);
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      var products = DriverModel.fromJson(body);
      if (!mounted) return;
      setState(() {
        print("object");
        searchData = products.driver;
        _isDriverLoading = false;
        _isSearch = true;

        print(_isDriverLoading);
      });
    }

    //  print(searchData);
  }
  // var userId;
  // var customerId;
  // var categorysData;

  TextEditingController driverNameController = TextEditingController();
  KeyValueModel categoryModel;
  List<KeyValueModel> categoryList = <KeyValueModel>[];

  List _status = [];
  var _currentAddressSelected; // = 'Sylhet';
  String date = "";

  void _educationDropDownSelected(String newValueSelected) {
    setState(() {
      this._currentAddressSelected = newValueSelected;
    });

    if (newValueSelected == 'Postponed to') {
      _showDate();
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  var hintText;

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
  var statusData;

  DateTime selectedDate = DateTime.now();
  var format;

  @override
  void initState() {
    // print(widget.data);

    //categoryName = widget.data.status==null?"":widget.data.status;
    hintText = "Select Status";
    format = DateFormat("yyyy-MM-dd").format(selectedDate);

    _getLocalBestProductsData('status-list');
    _showDefaultDriver();
    // _getLocalBestProductsData('driver-list');

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

  String defaultDriverName;
  var defaultDriver;
  var defaultDriverId;

  void _orderState() {
    var driver = DefaultDriverModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      defaultDriver = driver.driver;
      defaultDriverId = driver.driver.id;
      var first =
          driver.driver.firstName == null ? "" : driver.driver.firstName;
      var last = driver.driver.lastName == null ? "" : driver.driver.lastName;
      defaultDriverName = first + " " + last;
      _isLoading = false;
      //    categoryName = widget.data.driver == null
      //     ? defaultDriverName
      //     : widget.data.driver.firstName == null &&
      //             widget.data.driver.lastName == null
      //         ? ""
      //         : widget.data.driver.firstName + " " + widget.data.driver.lastName;

      // categoryId = widget.data.driver == null
      //     ? defaultDriverId.toString()
      //     : widget.data.driver.id == null ? "" : widget.data.driver.id.toString();

      driverNameController.text = defaultDriverName;
      drivername = defaultDriverName;
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
        date = "${DateFormat("dd - MMMM - yyyy").format(selectedDate)}";
        Navigator.pop(context);
        _showDate();
      });
  }

  ////////////// get  status start ///////////////

  Future _getLocalBestProductsData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localbestProductsData = localStorage.getString(key);
    if (localbestProductsData != null) {
      body = json.decode(localbestProductsData);
      _bestProductsState();
    }
  }

  void _bestProductsState() {
    var statuses = StatusModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      // _isLoading = true;

      statusData = statuses.statuses;

      for (int i = 0; i < statusData.length; i++) {
        //_status.add(statusData[i].name);
        categoryList.add(KeyValueModel(
            key: "${statusData[i].name}", value: "${statusData[i].id}"));
      }

      // _isLoading = false;
    });

    // print(_status);
  }

  // Future<void> _showStatus() async {
  // //  var key = 'status-list';
  //  // await _getLocalBestProductsData(key);

  //   var res = await CallApi().getData('/app/indexStatus');
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
        title: Text("Change Status"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    left: 10, bottom: 8, top: 10),
                                child: Text("Status",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: appColor, fontSize: 15))),
                            Container(
                              //color: Colors.yellow,
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 6, bottom: 6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  ////////////   category Dropdown ///////////

                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Colors.grey[100],
                                        border: Border.all(
                                            width: 0.2, color: Colors.grey)),
                                    //  borderRadius: BorderRadius.circular(20),
                                    // color: Colors.white),
                                    // alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(

                                            //color: Colors.red,
                                            child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 +
                                                      200,
                                                  //  color: Colors.black,
                                                  margin: EdgeInsets.only(
                                                      left: 16,
                                                      top: 10,
                                                      bottom: 10),
                                                  child: Text(
                                                    categoryName + " " + date,
                                                    // overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54),
                                                  )),
                                            ),
                                            Container(
                                              //  width: 10,
                                              height: 42,
                                              // width: MediaQuery.of(context).size.width/4,
                                              //  color: Colors.yellow,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: ButtonTheme(
                                                  minWidth: 10,
                                                  //  height: 10,
                                                  alignedDropdown: true,
                                                  child: DropdownButton<
                                                      KeyValueModel>(
                                                    items: categoryList.map(
                                                        (KeyValueModel user) {
                                                      return new DropdownMenuItem<
                                                          KeyValueModel>(
                                                        value: user,
                                                        child: new Text(
                                                          user.key,
                                                          style: new TextStyle(
                                                              color:
                                                                  Colors.black),
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
                                                    onChanged:
                                                        (KeyValueModel value) {
                                                      setState(() {
                                                        categoryModel = value;
                                                        categoryName =
                                                            categoryModel.key;
                                                        categoryId =
                                                            categoryModel.value;
                                                        date = "";
                                                        // subcategoryList = [];
                                                        // subcategoryName = "";
                                                      });
                                                      // categoryId =
                                                      if (int.parse(
                                                              categoryId) ==
                                                          6) {
                                                        _showDate();
                                                        setState(() {
                                                          assignDriverStatus =
                                                              false;
                                                        });
                                                      }
                                                      if (int.parse(
                                                              categoryId) ==
                                                          3) {
                                                        setState(() {
                                                          assignDriverStatus =
                                                              true;
                                                        });
                                                      }
                                                      if (int.parse(
                                                              categoryId) ==
                                                          7) {
                                                        setState(() {
                                                          assignDriverStatus =
                                                              false;
                                                        });
                                                        _cancelOrder(
                                                            "Are you sure want to deliver this order?");
                                                      }
                                                      if (int.parse(
                                                              categoryId) ==
                                                          8) {
                                                        setState(() {
                                                          assignDriverStatus =
                                                              false;
                                                        });
                                                        _cancelOrder(
                                                            "Are you sure want to cancel this order?");
                                                      }
                                                      if (int.parse(categoryId) == 1 ||
                                                          int.parse(
                                                                  categoryId) ==
                                                              2 ||
                                                          int.parse(
                                                                  categoryId) ==
                                                              4 ||
                                                          int.parse(
                                                                  categoryId) ==
                                                              5 ||
                                                          int.parse(
                                                                  categoryId) ==
                                                              6 ||
                                                          int.parse(
                                                                  categoryId) ==
                                                              7 ||
                                                          int.parse(
                                                                  categoryId) ==
                                                              8) {
                                                        setState(() {
                                                          assignDriverStatus =
                                                              false;
                                                        });
                                                      }

                                                      print(categoryId);

                                                      //_showsubCategory();
                                                    },
                                                    //  hint: Text('Select Key'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            !assignDriverStatus
                                ? Container()
                                : Column(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(
                                              left: 10, bottom: 8, top: 10),
                                          child: Text("Assign Driver",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: appColor,
                                                  fontSize: 15))),
                                      Container(
                                          margin: EdgeInsets.only(bottom: 20),
                                          // height: 70,
                                          // width: 250,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15,
                                                      top: 0,
                                                      right: 15),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                      color: Colors.grey[100],
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: Colors.grey)),
                                                  child: TextField(
                                                    cursorColor: Colors.grey,
                                                    controller:
                                                        driverNameController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    // autofocus: true,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600]),
                                                    decoration: InputDecoration(
                                                      hintText: "Search Here",
                                                      // labelText: label,
                                                      // labelStyle: TextStyle(color: appColor),
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              15.0,
                                                              10.0,
                                                              20.0,
                                                              15.0),
                                                      border: InputBorder.none,
                                                    ),
                                                    autofocus: true,
                                                    onChanged: (val) {
                                                      if (!mounted) return;
                                                      setState(() {
                                                        // store.dispatch(SearchTextClick(true));
                                                        _search(val);
                                                      });
                                                    },
                                                  )),
                                              _isDriverLoading
                                                  ? Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          left: 20,
                                                          bottom: 8,
                                                          top: 10),
                                                      child: Text(
                                                          "Please wait.....",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13)))
                                                  : _isSearch
                                                      ?
                                                      //  _isDriverLoading? Center(
                                                      //    child: CircularProgressIndicator(),
                                                      //  ):
                                                      Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: //  _isDriverLoading? Center(
                                                              //       //    child: CircularProgressIndicator(),
                                                              //       //  ):
                                                              _showDriverList())
                                                      : Container(),
                                            ],
                                          )),
                                    ],
                                  )
                          ],
                        ),

                        /////////////////   profile editing save start ///////////////

                        GestureDetector(
                          onTap: () {
                            _isOrderStatusLoading ? null : _selectStatus();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 25, right: 15, bottom: 20, top: 40),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: appColor.withOpacity(0.9),
                                border:
                                    Border.all(width: 0.2, color: Colors.grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.save,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                        _isOrderStatusLoading
                                            ? "Saving..."
                                            : "Save",
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

  void _setDriver() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.all(5),
            title: Text(
              "Assign Driver",
              // textAlign: TextAlign.,
              style: TextStyle(
                  color: Color(0xFF000000),
                  fontFamily: "grapheinpro-black",
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            content: SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  // height: 70,
                  // width: 250,
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 15, top: 0, right: 15),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.grey[100],
                              border:
                                  Border.all(width: 0.2, color: Colors.grey)),
                          child: TextField(
                            cursorColor: Colors.grey,
                            controller: driverNameController,
                            keyboardType: TextInputType.text,
                            // autofocus: true,
                            style: TextStyle(color: Colors.grey[600]),
                            decoration: InputDecoration(
                              hintText: "Search Here",
                              // labelText: label,
                              // labelStyle: TextStyle(color: appColor),
                              contentPadding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                              border: InputBorder.none,
                            ),
                            autofocus: true,
                            onChanged: (val) {
                              if (!mounted) return;
                              setState(() {
                                // store.dispatch(SearchTextClick(true));
                                _search(val);
                              });
                            },
                          )),

                      //   _isDriverLoading? Center(
                      //    child: CircularProgressIndicator(),
                      //  ):
                      _isSearch
                          ?
                          //  _isDriverLoading? Center(
                          //    child: CircularProgressIndicator(),
                          //  ):
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: //  _isDriverLoading? Center(
                                  //       //    child: CircularProgressIndicator(),
                                  //       //  ):
                                  _showDriverList())
                          : Container(),
                    ],
                  )),
            ),
          );
        });
        //return SearchAlert(duration);
      },
    );
  }

  void _cancelOrder(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            msg,
            // textAlign: TextAlign.,
            style: TextStyle(
                color: Color(0xFF000000),
                fontFamily: "grapheinpro-black",
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          content: Container(
              height: 70,
              width: 250,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
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
                              //_changeStatus();
                            },
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0))))
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }

  void _selectStatus() async {
    setState(() {
      _isOrderStatusLoading = true;
    });

    var data = {
      'status': categoryName, //int.parse(categoryId) == 3
      // ? categoryName + " " + drivername
      // : categoryName,
      'deliveryDate': date,
      'orders': widget.data,
      'driverId': assignId,
    };

    print(data);

    print(jsonEncode(data));

    var res = await CallApi().postData(data, '/app/editOrderbulkStatus');

    var body = json.decode(res.body);
    print("body");
    print(body);

    if (body['success'] == true) {
      Navigator.push(context, FadeRoute(page: OrderList()));
    } else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isOrderStatusLoading = false;
    });
  }

//       void _changeStatus() async {

//     if (categoryName=="") {
//       return _showMsg("Status is empty");
//     }
//     else if(int.parse(categoryId)==6 && date==""){
//        return _showMsg("Select date to postpone");
//     }
//     else if(int.parse(categoryId)==3 && drivername==""){
//        return _showMsg("Select driver name");
//     }
//     // else if(int.parse(categoryId)==3){
//     //   categoryName = categoryName+" "+driverNameController.text;
//     // }

//     setState(() {
//       _isData = true;
//     });

//     var data = {

//         'id':widget.data.id,
//         'status':int.parse(categoryId)==3?categoryName+" "+drivername:categoryName,
//         'deliveryDate':date

//     };

//     var res = await CallApi().postData(data, '/app/editOrderStatus');

//  var dataDriver = {

//         'id':widget.data.id,
//         'driverId': assignId,

//     };

//   //  print(data);

//     var resDriver = await CallApi().postData(dataDriver, '/app/editOrder');

//     var bodyDriver = json.decode(resDriver.body);
//     var body = json.decode(res.body);
//       //  print("body");

//       // print(body);ali

//     if (body['success'] == true  && bodyDriver['success'] == true) {

//        Navigator.push(
//                         context, SlideLeftRoute(page: OrderList()));

//    //  Toast.show("Status Changed Successfully", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

//     } else {
//       _showMsg("Something is wrong! Try Again");
//     }

//     setState(() {
//       _isData = false;
//     });
//   }

  List<Widget> _showDriverList() {
    List<Widget> list = [];
    //var type;
    //List allLists = [];
    //List<VariableValueModel> allLists = <VariableValueModel>[];
    //var add;

    // int checkIndex=0;
    //_isDriverLoading?

    for (var d in searchData) {
      list.add(GestureDetector(
        onTap: () {
          setState(() {
            assignId = d.id == null ? "" : d.id.toString();
            drivername = d.firstName + " " + d.lastName;
            driverNameController.text = d.firstName + " " + d.lastName;

            // productId = d.id;
            _driverfound = true;
          });

          //   Navigator.of(context).pop();
          //  _setDriver();

          //  Navigator.push(context, SlideLeftRoute(page: ProductVariablePage(d)));
        },
        child: _driverfound
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

  void _showDate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          // actions: <Widget>[

          // ],
          title: Column(
            children: <Widget>[
              ////////////   Address  start ///////////

              ///////////// Address   ////////////

              Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(bottom: 8),
                  child: Text("Select Date",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: appColor, fontSize: 13))),

              Container(
                //  margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.grey[100],
                    border: Border.all(width: 0.2, color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.only(left: 20),
                      child: Text(
                        date.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectDate(context);
                          //_showDate();
                        });
                      },
                      icon: Icon(Icons.calendar_today),
                    )
                  ],
                ),
              ),
            ],
          ),

          content: Container(
              height: 70,
              width: 250,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                            "Ok",
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                            //_showOrders();
                          },
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                        )),
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }
}
