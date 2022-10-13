import 'dart:convert';

import 'package:bahrain_admin/Cards/OrderListCard/OrderListCard.dart';
import 'package:bahrain_admin/Cards/ProductListCard/ProductListCard.dart';
import 'package:bahrain_admin/Model/ShowOrderModel/ShowOrderModel.dart';
import 'package:bahrain_admin/Model/StatusModel/StatusModel.dart';
import 'package:bahrain_admin/Screen/AddOrder/AddOrders.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/Screen/CancelOrderDetails/CancelOrderDetails.dart';
import 'package:bahrain_admin/Screen/DeliveredOrderList/DeliveredOrderList.dart';
import 'package:bahrain_admin/Screen/HomePage/HomePage.dart';
import 'package:bahrain_admin/Screen/OrderDetails/OrderDetails.dart';
import 'package:bahrain_admin/Screen/OrderType/OrderType.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:bahrain_admin/printDocument.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../OrderSort.dart';

class PendingOrderList extends StatefulWidget {
  @override
  _PendingOrderListState createState() => _PendingOrderListState();
}

class _PendingOrderListState extends State<PendingOrderList> {
  final GlobalKey<State<StatefulWidget>> scaffoldKey = GlobalKey();

  Printer selectedPrinter;
  PrintingInfo printingInfo;
  TextEditingController printText1Controller = TextEditingController();
  TextEditingController printText2Controller = TextEditingController();

  List pendingPrintList = [];
  List markList = [];
  bool _isPrint = false;
  bool _isLoadingTax = false;
  bool _allSelect = false;

  bool _isLoadedAll = false;
  bool _isLoadingMore = false;
  int _lastId;
  int _lastSearchId;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _status = ['Block', 'House', 'Road', 'Street', 'Area'];
  var _sendType = 'asc';
  var _currentStatusSelected = 'Block';
  void _statusDropDownSelected(String newValueSelected) {
    setState(() {
      this._currentStatusSelected = newValueSelected;
    });
  }

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

  var taxStatus;
  var taxAmount;
  var sendStatus = "";
  var date = "";
  double amount = 0.0;
  var _type = ['A to Z', 'Z to A'];

  var _currentTypeSelected = 'A to Z';
  void _typeDropDownSelected(String newValueSelected) {
    setState(() {
      this._currentTypeSelected = newValueSelected;
      if (newValueSelected == 'A to Z') {
        _sendType = 'asc';
      } else {
        _sendType = 'desc';
      }
    });
  }

  var body;
  List orderData = [];
  var statusData;
  bool _isLoading = true;
  bool _isDropData = true;
  DateTime selectedDate = DateTime.now();
  String dateFr = '';
  String dateTo = '';
  bool _isSearched = false;
  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDateTo = DateTime.now();
  var format;

  Container dateFromField(String label, String date) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              // width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 8),
              child: Text(
                label,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w400),
              )),
          GestureDetector(
            onTap: () {
              _selectDateFrom(context);
            },
            child: Container(
              //   width: ,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              margin: EdgeInsets.only(top: 13),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.white,
                  border: Border.all(width: 0.2, color: Colors.grey)),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.date_range,
                    color: appColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: appTealColor, width: 2),
                    // ),
                    child: new Text(date,
                        //DateFormat.yMMMd().format(selectedDate),
                        style: TextStyle(
                            color: appColor,
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _selectDateFrom(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateFrom,
        firstDate: DateTime(1964, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateFrom) {
      setState(() {
        selectedDateFrom = picked;
        dateFr = "${DateFormat("yyyy-MM-dd").format(selectedDateFrom)}";
        Navigator.pop(context);
        dialogDate();
      });
    }
  }

  Container dateToField(String label2, String date2) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              // width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 8),
              child: Text(
                label2,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w400),
              )),
          GestureDetector(
            onTap: () {
              _selectDateTo(context);
            },
            child: Container(
              //   width: ,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              margin: EdgeInsets.only(top: 13),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.white,
                  border: Border.all(width: 0.2, color: Colors.grey)),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.date_range,
                    color: appColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: appTealColor, width: 2),
                    // ),
                    child: new Text(date2,
                        //DateFormat.yMMMd().format(selectedDate),
                        style: TextStyle(
                            color: appColor,
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    Printing.info().then((PrintingInfo info) {
      setState(() {
        printingInfo = info;
      });
    });

    format = DateFormat("yyyy-MM-dd").format(selectedDate);
    // print(pendingPrintList.length);
    _allData();
    super.initState();
  }

  Future<void> _allData() async {
    setState(() {
      dateFr = "";
      dateTo = "";
      pendingPrintList = [];
      markList = [];
    });
    _showOrders();
    _showTax();

    //_showStatus();
  }

  Future<void> _showTax() async {
    //  var key = 'tax-list';
    //  await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/getAllTax');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        taxStatus = body['alltax'][0]['isOn'];
        taxAmount = body['alltax'][0]['tax'];

        _isLoadingTax = false;
      });
      print(taxAmount);
    }
  }

  void _showPrintedToast(bool printed) {
    if (scaffoldKey.currentContext != null) {
      final ScaffoldState scaffold = Scaffold.of(scaffoldKey.currentContext);
      if (printed) {
        scaffold.showSnackBar(const SnackBar(
          content: Text('Document printed successfully'),
        ));
      } else {
        scaffold.showSnackBar(const SnackBar(
          content: Text('Document not printed'),
        ));
      }
    }
  }

  void _printInvoiceDoc1() async {
    print('Print ...');
    final bool result = await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async =>
            (await generatePdf(format, pendingPrintList, taxStatus, taxAmount))
                .save());

    //   print(result);
    _showPrintedToast(result);
  }

  Future<void> _showSearchOrders(String fr, String to) async {
    setState(() {
      amount = 0.0;
      _isSearched = true;
      _isLoadedAll = false;
    });
    // var key = 'Pending-date-orders-list';
    //await _getLocalOrderData(key);

    var res = await CallApi()
        .getData('/app/indexOrder?status=Pending&date1=$fr&date2=$to');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _orderState();

      var loadList = body['order'];
      if (loadList.length > 0) {
        _lastSearchId = loadList[loadList.length - 1]['id'];
      } else {
        if (!mounted) return;
        setState(() {
          _isLoadedAll = true;
        });
      }

      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString(key, json.encode(body));
    }
  }

  ///////////////////////////// _showMoreSearchOrders ////////////////////////////
  Future<void> _showMoreSearchOrders(String fr, String to) async {
    setState(() {
      _isSearched = true;
    });

    var res = await CallApi().getData(
        '/app/indexOrder?status=Pending&date1=$fr&date2=$to&lastId=$_lastSearchId');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      var loadList = body['order'];
      if (loadList.length > 0) {
        _lastSearchId = loadList[loadList.length - 1]['id'];
      } else {
        if (!mounted) return;
        setState(() {
          _isLoadedAll = true;
        });
      }

      var orders = ShowOrderModel.fromJson(body);
      if (!mounted) return;
      setState(() {
        orderData..addAll(orders.order);
      });

      if (orderData.length > 0) {
        amount = 0.0;
        for (int i = 0; i < orderData.length; i++) {
          // print('i = $i');
          String total = orderData[i].grandTotal;
          double gTotal = double.parse(total);
          // print(gTotal);
          amount += gTotal;
        }
      }
    }
  }
  ///////////////////////////// _showMoreSearchOrders ////////////////////////////

  Future<Null> _selectDateTo(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateTo,
        firstDate: DateTime(1964, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateTo) {
      setState(() {
        selectedDateTo = picked;
        dateTo = "${DateFormat("yyyy-MM-dd").format(selectedDateTo)}";
        Navigator.pop(context);
        dialogDate();
      });
    }
  }

  //////////////// get  orders start ///////////////

  Future _getLocalOrderData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localOrderData = localStorage.getString(key);
    if (localOrderData != null) {
      body = json.decode(localOrderData);
      _orderState();
    }
  }

  void _orderState() {
    var orders = ShowOrderModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      orderData = orders.order;
      for (int i = 0; i < orderData.length; i++) {
        String total = orderData[i].grandTotal;
        double gTotal = double.parse(total);
        amount += gTotal;
      }
      //  print(amount);
      _isLoading = false;
    });

    // print(_currentStatusSelected);
    // print(_sendType);
    print("total");
    print(orderData.length);
  }

  Future<void> _showOrders() async {
    // var key = 'Pending-orders-list';
    // await _getLocalOrderData(key);

    var res = await CallApi().getData(
        '/app/indexOrder?status=Pending'); //order=$_currentStatusSelected,$_sendType');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        dateFr = "";
        dateTo = "";
      });
      _orderState();

      if (body['order'].length > 0) {
        _lastId = body['order'][body['order'].length - 1]['id'];
      }

      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString(key, json.encode(body));
    }
  }
  //////////////// get  orders end ///////////////

//////////////// get more orders start ////////////////
  _loadMoreOrders() async {
    setState(() {
      _isLoadingMore = true;
    });

    var res = await CallApi()
        .getData('/app/indexOrder?status=Pending&lastId=$_lastId');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('..........more more more...........');

    if (res.statusCode == 200) {
      var loadList = body['order'];
      if (loadList.length > 0) {
        _lastId = loadList[loadList.length - 1]['id'];
      } else {
        if (!mounted) return;
        setState(() {
          _isLoadedAll = true;
        });
      }
      var orders = ShowOrderModel.fromJson(body);
      if (!mounted) return;
      setState(() {
        orderData..addAll(orders.order);
      });
    }

    if (!mounted) return;
    setState(() {
      _isLoadingMore = false;
    });
  }
  //////////////// get more orders end ////////////////

  void dialogDate() {
    showDialog(
      ////////////////   Select Date Dialog    //////////////
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Column(
            children: <Widget>[
              new Text("Status Date"),
              Divider(
                color: Colors.grey[400],
              ),
              dateFromField("Date From", '$dateFr'),
              dateToField("To", '$dateTo'),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new OutlineButton(
                  borderSide: BorderSide(
                      color: appColor, style: BorderStyle.solid, width: 1),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0)),
                  child: new Text(
                    "Search",
                    style: TextStyle(color: appColor),
                  ),
                  onPressed: () {
                    setState(() {
                      // if (statusSelect == '') {
                      //   _showMsg("Select a status first");
                      // } else
                      if (dateTo == '' || dateFr == '') {
                        _showMsg("Select date");
                      } else {
                        // isSearching2 = true;
                        _showSearchOrders(dateFr, dateTo);
                        // _isSearching = true;
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.push(context, FadeRoute(page: OrderType()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: appColor,
          title: Text("Pending Order"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(context, FadeRoute(page: OrderType()));
                },
              );
            },
          ),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  dialogDate();
                },
                child: Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(Icons.search))),
            _isLoadingTax
                ? Container()
                : pendingPrintList.length < 1
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          printingInfo?.canPrint ?? false
                              ? _printInvoiceDoc1()
                              : null;
                        },
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  //  alignment: Alignment.topRight,
                                  padding: EdgeInsets.all(4),
                                  margin: EdgeInsets.only(left: 15, top: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    pendingPrintList.length == 0
                                        ? ""
                                        : pendingPrintList.length.toString(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(right: 15),
                                  child: Icon(Icons.print)),
                            ],
                          ),
                        )),
            pendingPrintList.length < 1
                ? Container()
                : !_allSelect
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _allSelect = true;
                            pendingPrintList.clear();
                            markList.clear();
                            for (var d in orderData) {
                              pendingPrintList.add({'id': d.id, 'data': d});
                              markList.add(d.id);
                              d.isClick = true;
                            }
                          });

                          print(pendingPrintList.length);
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Row(
                              children: <Widget>[
                                Text("All"),
                                SizedBox(width: 5),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    shape: BoxShape.circle,
                                  ),
                                )
                              ],
                            )),
                      )
                    : pendingPrintList.length == orderData.length
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _allSelect = false;
                                for (var d in orderData) {
                                  pendingPrintList.clear();
                                  markList.clear();
                                  d.isClick = null;
                                }
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Text("All"),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.check_circle,
                                      size: 18,
                                    )
                                  ],
                                )),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                _allSelect = true;
                                pendingPrintList.clear();
                                markList.clear();
                                for (var d in orderData) {
                                  pendingPrintList.add({'id': d.id, 'data': d});
                                  markList.add(d.id);
                                  d.isClick = true;
                                }
                              });

                              // print(pendingPrintList.length);
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Text("All"),
                                    SizedBox(width: 5),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.white),
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  ],
                                )),
                          )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : orderData.length == 0
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 100,
                          height: 110,
                          decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new AssetImage(
                                    'assets/images/empty_box.png'),
                              ))),
                      Text(
                        "You have no order",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: appColor,
                            fontFamily: "sourcesanspro",
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ))
                : RefreshIndicator(
                    onRefresh: _allData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(top: 5, bottom: 12),
                        margin: EdgeInsets.only(left: 5, right: 5, top: 2),
                        child: Column(
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: _showOrdersList()),
                            ////////////////////////////// load more button start /////////////////////////////
                            _isLoadedAll
                                ? Container()
                                : OutlineButton(
                                    onPressed: () {
                                      _isLoadingMore
                                          ? null
                                          : _isSearched
                                              ? _showMoreSearchOrders(
                                                  dateFr, dateTo)
                                              : _loadMoreOrders();
                                    },
                                    borderSide: BorderSide(
                                        color: appColor,
                                        style: BorderStyle.solid,
                                        width: 1),
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(50.0)),
                                    child: new Text(
                                      _isLoadingMore
                                          ? "Please wait..."
                                          : "Load More",
                                      style: TextStyle(
                                          color: appColor, fontSize: 12),
                                    ),
                                  ),
                            //////////////////////////// load more button end /////////////////////////////
                          ],
                        ),
                      ),
                    ),
                  ),
        bottomNavigationBar: _isSearched == false
            ? Container(
                height: 0,
              )
            : Container(
                padding: EdgeInsets.all(15),
                color: appColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "No. of orders: ${orderData.length}",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      "Total amount: ${amount.toStringAsFixed(2)} BHD",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> _showOrdersList() {
    List<Widget> list = [];
    // int checkIndex=0;
    for (var d in orderData) {
      // checkIndex = checkIndex+1;

      //print("seeen") ;
      //print(d.seen);
      //   print(d.status);

      list.add(Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: GestureDetector(
            onLongPress: () {
              // if (d.isClick == null) {
              //   setState(() {
              //     d.isClick = true;
              //   });

              int index = 1;
              for (int i = 0; i < pendingPrintList.length; i++) {
                if (pendingPrintList[i]['id'] == d.id) {
                  pendingPrintList.removeAt(i);
                  markList.removeAt(i);
                  setState(() {
                    index = 0;
                    d.isClick = null;
                  });
                }
              }

              if (index == 1) {
                pendingPrintList.add({'id': d.id, 'data': d});
                markList.add(d.id);

                setState(() {
                  d.isClick = true;
                  _isPrint = true;
                });
              }

              //  if (index == 1) {
              // pendingPrintList.add({'id': d.id, 'data': d});

              // setState(() {
              //   _isPrint = true;
              //     d.isClick = true;
              // });
              //   }

              // index = 0;

              print(markList);
              // }
              // else {
              //   setState(() {
              //     d.isClick = null;
              //     for (int i = 0; i < pendingPrintList.length; i++) {
              //       if (pendingPrintList[i]['id'] == d.id) {
              //         pendingPrintList.removeAt(i);
              //       }
              //     }
              //     //widget.list = [];
              //   });
              //   // print(widget.list);
              // }
            },
            onTap: () {
              Navigator.push(context, FadeRoute(page: OrderDetails(d)));
            },
            child: Stack(
              children: <Widget>[
                Card(
                  elevation: 1,
                  // margin: EdgeInsets.only(bottom: 5, top: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 16.0,
                          // offset: Offset(0.0,3.0)
                        )
                      ],
                      // border: Border.all(
                      //   color: Color(0xFF08be86)
                      // )
                    ),
                    padding: EdgeInsets.only(
                        right: 12, left: 12, top: 10, bottom: 10),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.blue,
                    child: Column(
                      children: <Widget>[
                        Container(
                          //color: Colors.red,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  //color: Colors.red,
                                  margin: EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 +
                                                10,
                                            child: Text(
                                              d.id == null
                                                  ? "---"
                                                  : "Order Id: " +
                                                      d.id.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              //  textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                  color: appColor,
                                                  fontFamily: "sourcesanspro",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          // Container(
                                          //   child: Text(
                                          //     "\$ 45.00",
                                          //     textDirection: TextDirection.ltr,
                                          //     style: TextStyle(
                                          //         color: appColor,
                                          //         fontFamily: "sourcesanspro",
                                          //         fontSize: 15,
                                          //         fontWeight: FontWeight.bold),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          d.status == null
                                              ? "---"
                                              : 'Order Status is ' +
                                                  d.status.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          //  textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                              color: Color(0xFF343434),
                                              fontFamily: "sourcesanspro",
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          d.mobile1 == null
                                              ? 'Mobile: ' +
                                                  d.mobile2.toString()
                                              : 'Mobile: ' +
                                                  d.mobile1.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          // textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                              color: Color(0xFF343434),
                                              fontFamily: "sourcesanspro",
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      d.grandTotal == null
                                          ? Container()
                                          : Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(
                                                d.grandTotal == null
                                                    ? ''
                                                    : "Total : " +
                                                        d.grandTotal
                                                            .toString() +
                                                        " BHD",

                                                overflow: TextOverflow.ellipsis,
                                                // textDirection: TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Color(0xFF343434),
                                                    fontFamily: "sourcesanspro",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                      d.date == null
                                          ? Container()
                                          : Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(
                                                d.date == null
                                                    ? ''
                                                    : "Order Date : " +
                                                        d.date.toString(),

                                                overflow: TextOverflow.ellipsis,
                                                // textDirection: TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Color(0xFF343434),
                                                    fontFamily: "sourcesanspro",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                      d.status_updated_at == null
                                          ? Container()
                                          : Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(
                                                d.status_updated_at == null
                                                    ? ''
                                                    : "Status Date: " +
                                                        d.status_updated_at
                                                            .toString(),

                                                overflow: TextOverflow.ellipsis,
                                                // textDirection: TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Color(0xFF343434),
                                                    fontFamily: "sourcesanspro",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),

                              // IconButton(
                              //   icon: Icon(Icons.delete,
                              //   color: appColor),
                              //   onPressed: (){
                              //               _deleteOrder();

                              //   }

                              // )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //d.isClick == null
                markList.contains(d.id)
                    ? Container(
                        margin: EdgeInsets.all(8),
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.check_circle,
                          color: appColor,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
                caption: 'Remove',
                color: Colors.red[100],
                icon: Icons.delete,
                onTap: () {
                  _deleteOrder(d);
                })
          ]));
    }

    return list;
  }

  void _deleteOrder(var d) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Are you sure want to delete this order?",
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
                              _deleteOrders(d);
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

  void _deleteOrders(var d) async {
    // print(d.id);

    //  setState(() {
    //    _isLoading = true;
    //  });

    var data = {
      'id': d.id,
    };

    var res = await CallApi().postData(data, '/app/deleteOrder');
    var body = json.decode(res.body);

    if (body['success'] == true) {
      orderData.remove(d);
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString("cancel-orders-list", json.encode(body));
      //  Navigator.of(context).pop();

      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => PendingOrderList()));
    }

    //    setState(() {
    //    _isLoading = false;
    //  });
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  ////////////   Address  start ///////////

                  ///////////// Address   ////////////

                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 25, top: 5, bottom: 8),
                      child: Text("Sort by",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 13))),

                  ////////////   Address Dropdown ///////////

                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.grey[100],
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(

                            //color: Colors.red,
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    icon: Icon(Icons.keyboard_arrow_down,
                                        size: 25, color: Color(0xFFC5C2C7)),
                                    items: _status
                                        .map((String dropDownStringItem) {
                                      return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(
                                            dropDownStringItem,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ));
                                    }).toList(),
                                    onChanged: (String newValueSelected) {
                                      _statusDropDownSelected(newValueSelected);
                                    },
                                    value: _currentStatusSelected,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  ),

                  ////////////   Address end ///////////
                ],
              ),
              Column(
                children: <Widget>[
                  ////////////   Address  start ///////////

                  ///////////// Address   ////////////

                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 25, top: 5, bottom: 8),
                      child: Text("Sort",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 13))),

                  ////////////   Address Dropdown ///////////

                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.grey[100],
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(

                            //color: Colors.red,
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    icon: Icon(Icons.keyboard_arrow_down,
                                        size: 25, color: Color(0xFFC5C2C7)),
                                    items:
                                        _type.map((String dropDownStringItem) {
                                      return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(
                                            dropDownStringItem,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ));
                                    }).toList(),
                                    onChanged: (String newValueSelected) {
                                      _typeDropDownSelected(newValueSelected);
                                    },
                                    value: _currentTypeSelected,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  ),

                  ////////////   Address end ///////////
                ],
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
                            _showOrders();
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
