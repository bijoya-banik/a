import 'dart:convert';

import 'package:bahrain_admin/Cards/OrderListCard/OrderListCard.dart';
import 'package:bahrain_admin/Cards/ProductListCard/ProductListCard.dart';
import 'package:bahrain_admin/Model/DriverModel/DriverModel.dart';
import 'package:bahrain_admin/Model/ShowOrderModel/ShowOrderModel.dart';
import 'package:bahrain_admin/Model/StatusModel/StatusModel.dart';
import 'package:bahrain_admin/Screen/AddOrder/AddOrders.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/Screen/AllStatusChange/AllStatusChange.dart';
import 'package:bahrain_admin/Screen/HomePage/HomePage.dart';
import 'package:bahrain_admin/Screen/NotificationPage/NotificationPage.dart';
import 'package:bahrain_admin/Screen/OrderDetails/OrderDetails.dart';
import 'package:bahrain_admin/Screen/OrderType/OrderType.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../OrderSort.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var assignId = "";
  var searchData;
  bool _driverfound = false;
  bool _isDriverLoading = false;

  bool _isLoadingMore = false;
  bool _isLoadedAll = false;
  int _lastId;
  int _lastSearchId;

  String drivername = "";
  var _seqName = "";
  var _seqType = "";
  var _sort = ['Block', 'House', 'Road', 'Street', 'Area'];
  var _sendType = 'asc';
  var _currentStatusSelected = 'Block';
  void _statusDropDownSelected(String newValueSelected) {
    setState(() {
      this._currentStatusSelected = newValueSelected;
      _seqName = newValueSelected;
    });

    Navigator.pop(context);
    _showAlert();
  }

  TextEditingController searchController = TextEditingController();

  List selectList = [];
  List markList = [];
  List _status = [];
  bool _isSearch = false;
  bool _isSearchData = false;
  bool _isOrderStatusLoading = false;
  var driverData;
  bool _allSelect = false;
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

  var sendStatus = "";
  var date = "";

  var _type = ['A to Z', 'Z to A'];
  TextEditingController driverNameController = TextEditingController();
  var _currentTypeSelected = 'A to Z';
  void _typeDropDownSelected(String newValueSelected) {
    setState(() {
      this._currentTypeSelected = newValueSelected;
      if (newValueSelected == 'A to Z') {
        _sendType = 'asc';
        _seqType = 'asc';
      } else {
        _sendType = 'desc';
        _seqType = 'desc';
      }
    });

    Navigator.pop(context);
    _showAlert();
  }

  bool _searchDriver = false;
  String orderDate = "";
  var body;
  List orderData = [];
  var statusData;
  bool _isLoading = true;
  bool _isOrderLoading = true;
  bool _isDropData = true;
  var orderSearchData;
  DateTime selectedDate = DateTime.now();
  DateTime selectedOrderDate = DateTime.now();
  var format;
  var formatOrderDate;
  @override
  void initState() {
    visitDriver = "myOrder";
    format = DateFormat("yyyy-MM-dd").format(selectedDate);
    formatOrderDate = DateFormat("yyyy-MM-dd").format(selectedOrderDate);
    _allData();
    super.initState();
  }

  Future<void> _search(String value) async {
    setState(() {
      _isDriverLoading = true;
      _searchDriver = true;
      _driverfound = false;
    });

    var urlStr = '/app/indexUserDriver?search=$value';

    var res = await CallApi().getData(urlStr);
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      var products = DriverModel.fromJson(body);
      if (!mounted) return;
      setState(() {
        //   print("object");
        searchData = products.driver;
        _isDriverLoading = false;
        _searchDriver = true;

        // print(_isDriverLoading);
      });
    }

    //  print(searchData);
  }

  void _statusState() {
    var statuses = StatusModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      // _isLoading = true;

      statusData = statuses.statuses;
      for (int i = 0; i < statusData.length; i++) {
        _status.add(statusData[i].name);
      }

      _isLoading = false;

      _isDropData = false;
    });

    // print(_status);
  }

  Future<void> _showStatus() async {
    var key = 'status-list';
    //  await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/indexStatus');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _statusState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  Future<void> _showDriver() async {
    var key = 'driver-list';
    // await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/indexUserDriver');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _driverState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  void _driverState() {
    var drivers = DriverModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      // _isLoading = true;

      driverData = drivers.driver;
      // for (int i = 0; i < driverData.length; i++) {
      //   _status.add(driverData[i].name);
      // }

      _isLoading = false;

      // _isDropData = false;
    });

    // print(_status);
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
        print(date);
        Navigator.pop(context);
        _showDate();
      });
  }

  Future<Null> _selectOrderDate(BuildContext context) async {
    final DateTime pickedOrder = await showDatePicker(
        //  locale: Locale("yyyy-MM-dd"),
        context: context,
        initialDate: selectedOrderDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (pickedOrder != null && pickedOrder != selectedOrderDate)
      setState(() {
        selectedOrderDate = pickedOrder;
        // date = "${DateFormat("dd - MMMM - yyyy").format(selectedDate)}";
        searchController.text =
            "${DateFormat("yyyy-MM-dd").format(selectedOrderDate)}";
        orderDate = "${DateFormat("yyyy-MM-dd").format(selectedOrderDate)}";
        // print(orderDate);
        _showSearchOrders();
        // Navigator.pop(context);
        // _showDate();
      });
  }

  Future<void> _allData() async {
    _showOrders();
    _showStatus();
    _showDriver();
    selectList = [];
    markList = [];
  }

  void choiceAction(String choice) {
    if (choice == OrderSort.Sort) {
      if (selectList.length > 0 && markList.length > 0) {
        _showSelectItem("Please unselect order to sort");
      } else {
        _showAlert();
      }
    }
    if (choice == OrderSort.Status) {
      if (selectList.length == 0 && markList.length == 0) {
        _showSelectItem("Please select order with long press to change status");
      } else {
        // print(selectList);
        Navigator.push(context, FadeRoute(page: AllChangeStatus(selectList)));
        // _showStatus();
        // _showStatusAlert();
      }
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
      _isLoading = false;
      _isOrderLoading = false;
    });

    // print(_seqName);
    // print(_seqType);
  }

  Future<void> _showOrders() async {
    // var key = 'orders-list';
    // await _getLocalOrderData(key);
    var res;
    _seqName != "" && _seqType != ""
        ? res =
            await CallApi().getData('/app/indexOrder?order=$_seqName,$_seqType')
        : res = await CallApi().getData('/app/indexOrder');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      // print("aiche");
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

    var res;
    _seqName != "" && _seqType != ""
        ? res = await CallApi().getData(
            '/app/indexOrder?order=$_seqName,$_seqType&lastId=$_lastId')
        : res = await CallApi().getData('/app/indexOrder?lastId=$_lastId');
    print('res - $res');
    var body2 = json.decode(res.body);
    print('body2 - $body2');
    print('..........more more more...........');

    if (res.statusCode == 200) {
      var loadList = body2['order'];
      if (loadList.length > 0) {
        _lastId = loadList[loadList.length - 1]['id'];
      } else {
        if (!mounted) return;
        setState(() {
          _isLoadedAll = true;
        });
      }
      var orders = ShowOrderModel.fromJson(body2);
      // print('$orders -- orders');
      // print('${orders.order} -- orders.order');
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

  //////////////// get search orders start ///////////////

  Future _getSearchLocalOrderData(key) async {
    SharedPreferences localSearchStorage =
        await SharedPreferences.getInstance();
    var localSearchOrderData = localSearchStorage.getString(key);
    if (localSearchOrderData != null) {
      body = json.decode(localSearchOrderData);
      _orderSearchState();
    }
  }

  void _orderSearchState() {
    var ordersSearch = ShowOrderModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      orderSearchData = ordersSearch.order;

      _isSearchData = true;
    });
  }

  Future<void> _showSearchOrders() async {
    // var key = 'search-orders-list';
    // await _getSearchLocalOrderData(key);

    var res;
    orderDate == ""
        ? res = await CallApi()
            .getData('/app/indexOrder?key=${searchController.text}')
        : res = await CallApi().getData(
            '/app/indexOrder?date1=${searchController.text}&date2=${searchController.text}');

    // print(res);

    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _orderSearchState();

      if (orderDate != "") {
        var loadList = body['order'];
        if (loadList.length > 0) {
          _lastSearchId = loadList[loadList.length - 1]['id'];
        } else {
          if (!mounted) return;
          setState(() {
            _isLoadedAll = true;
          });
        }
      }

      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString(key, json.encode(body));
    }
  }

  Future<void> _showMoreSearchOrders() async {
    setState(() {
      // amount = 0.0;
      _isSearchData = true;
      _isLoadedAll = false;
    });

    var res = await CallApi().getData(
        '/app/indexOrder?date1=${searchController.text}&date2=${searchController.text}&lastId=$_lastSearchId');

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
        orderSearchData..addAll(orders.order);
      });

      // if (orderData.length > 0) {
      //   amount = 0.0;
      //   for (int i = 0; i < orderData.length; i++) {
      //     // print('i = $i');
      //     String total = orderData[i].grandTotal;
      //     double gTotal = double.parse(total);
      //     // print(gTotal);
      //     amount += gTotal;
      //   }
      // }
    }
  }

  //////////////// get search orders end ///////////////
  Future<bool> _onWillPop() async {
    if (visit == true) {
      visit = false;
      Navigator.push(context, FadeRoute(page: NotificationPage()));
    } else {
      Navigator.push(context, FadeRoute(page: OrderType()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: appColor,
          // title: Text("Order"),
          title: !_isSearch
              ? Text("Order")
              : Container(
                  height: 40.0,
                  // width: 300,
                  // margin: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white),
                  child: TextField(
                    cursorColor: Colors.grey,
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(
                      //   Icons.search,
                      //   color: appRedColor,
                      // ),
                      hintText: 'Search order id/mobile/date',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 12.0, top: 10.0, bottom: 10),
                      suffixIcon: searchController.text == ""
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectOrderDate(context);
                                  //_showDate();
                                });
                              },
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ))
                          : IconButton(
                              onPressed: () {
                                // setState(() {});
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  setState(() {
                                    searchController.clear();
                                    markList.clear();
                                    selectList.clear();
                                    _isSearchData = false;
                                    orderDate = "";
                                  });
                                });
                                _showOrders();
                              },
                              icon: Icon(Icons.cancel),
                              color: Colors.grey,
                            ),
                    ),
                    onChanged: (val) {
                      if (!mounted) return;
                      if (searchController.text.isNotEmpty) {
                        _showSearchOrders();
                      } else if (searchController.text.isEmpty) {
                        _isSearchData = false;
                        _showOrders();
                      } else {
                        _showSearchOrders();
                      }
                    },
                    autofocus: true,
                  ),
                ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (visit == true) {
                    visit = false;
                    Navigator.push(
                        context, FadeRoute(page: NotificationPage()));
                  } else {
                    Navigator.push(context, FadeRoute(page: OrderType()));
                  }
                },
              );
            },
          ),
          actions: <Widget>[
            _isSearch
                ? Container()
                : Container(
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearch = true;
                          // store.dispatch(SearchTextClick(false));
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
            selectList.length < 1
                ? Container()
                : !_allSelect
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _allSelect = true;
                            selectList.clear();
                            markList.clear();
                            for (var d in orderData) {
                              selectList.add(
                                  {'id': d.id, 'customerId': d.customerId});
                              // selectList.add({'id': d.id, 'data': d});
                              markList.add(d.id);
                              d.isClick = true;
                            }
                          });

                          print(selectList.length);
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
                    : selectList.length == orderData.length
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _allSelect = false;
                                for (var d in orderData) {
                                  selectList.clear();
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
                                selectList.clear();
                                markList.clear();
                                for (var d in orderData) {
                                  selectList.add(
                                      {'id': d.id, 'customerId': d.customerId});
                                  // selectList.add({'id': d.id, 'data': d});
                                  markList.add(d.id);
                                  d.isClick = true;
                                }
                              });

                              // print(selectList.length);
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
                          ),
            Container(
              alignment: Alignment.topRight,
              child: PopupMenuButton<String>(
                onSelected: choiceAction,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return OrderSort.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
        body: _isOrderLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _isOrderStatusLoading
                ? Center(
                    child: Text(
                    "Please wait...",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black38,
                        fontFamily: "sourcesanspro",
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ))
                : !_isSearchData && orderData.length == 0
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
                    : _isSearchData && orderSearchData.length == 0
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
                                "No Order Found",
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
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Column(
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: _isSearchData
                                            ? _showSearchOrdersList()
                                            : _showOrdersList()),
                                    ////////////////////////////// load more button start /////////////////////////////
                                    (_isSearchData && orderDate == "") ||
                                            _isLoadedAll
                                        ? Container()
                                        : OutlineButton(
                                            onPressed: () {
                                              _isLoadingMore
                                                  ? null
                                                  : _isSearchData
                                                      ? _showMoreSearchOrders()
                                                      : _loadMoreOrders();
                                            },
                                            borderSide: BorderSide(
                                                color: appColor,
                                                style: BorderStyle.solid,
                                                width: 1),
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        50.0)),
                                            child: new Text(
                                              _isLoadingMore
                                                  ? "Please wait..."
                                                  : "Load More",
                                              style: TextStyle(
                                                  color: appColor,
                                                  fontSize: 12),
                                            ),
                                          ),
                                    //////////////////////////// load more button end /////////////////////////////
                                  ],
                                ),
                              ),
                            ),
                          ),
      ),
    );
  }

  List<Widget> _showOrdersList() {
    List<Widget> list = [];
    for (var d in orderData) {
      //print("seeen") ;
      //print(d.seen);
      //   print(d.status);

      list.add(
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrderDetails(d)));
          },
          onLongPress: () {
            int index = 1;
            for (int i = 0; i < selectList.length; i++) {
              if (selectList[i]['id'] == d.id) {
                selectList.removeAt(i);
                markList.removeAt(i);
                setState(() {
                  index = 0;
                  d.isClick = null;
                });
              }
            }

            if (index == 1) {
              selectList.add({'id': d.id, 'customerId': d.customerId});
              markList.add(d.id);
              setState(() {
                d.isClick = true;
              });
            }

            print(markList);
          },
          child: Stack(
            children: <Widget>[
              Card(
                elevation: 1,
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
                      )
                    ],
                  ),
                  padding:
                      EdgeInsets.only(right: 12, left: 12, top: 10, bottom: 10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        d.id == null
                                            ? Container()
                                            : Expanded(
                                                child: Container(
                                                  child: Text(
                                                    d.id == null
                                                        ? "---"
                                                        : "Order Id: " +
                                                            d.id.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: appColor,
                                                        fontFamily:
                                                            "sourcesanspro",
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                    d.status == null
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              d.status == null
                                                  ? "---"
                                                  : 'Order Status is ' +
                                                      d.status.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF343434),
                                                  fontFamily: "sourcesanspro",
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                    d.mobile1 == null && d.mobile2 == null
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              d.mobile1 == null
                                                  ? 'Mobile: ' +
                                                      d.mobile2.toString()
                                                  : 'Mobile: ' +
                                                      d.mobile1.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF343434),
                                                  fontFamily: "sourcesanspro",
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                                      d.grandTotal.toString() +
                                                      " BHD",
                                              overflow: TextOverflow.ellipsis,
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
                                              d.status_updated_at == null
                                                  ? ''
                                                  : "Status Date : " +
                                                      d.status_updated_at
                                                          .toString(),
                                              overflow: TextOverflow.ellipsis,
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
      );
    }

    return list;
  }

  List<Widget> _showSearchOrdersList() {
    List<Widget> list = [];
    // int checkIndex=0;
    for (var d in orderSearchData) {
      // checkIndex = checkIndex+1;

      //print("seeen") ;
      //print(d.seen);
      //   print(d.status);

      //list.add(OrderListCard(d, selectList,markList));
      list.add(
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrderDetails(d)));
          },
          onLongPress: () {
            int index = 1;
            for (int i = 0; i < selectList.length; i++) {
              if (selectList[i]['id'] == d.id) {
                selectList.removeAt(i);
                markList.removeAt(i);
                setState(() {
                  index = 0;
                  d.isClick = null;
                });
              }
            }

            if (index == 1) {
              selectList.add({'id': d.id, 'customerId': d.customerId});
              markList.add(d.id);
              setState(() {
                d.isClick = true;
              });
            }

            print(markList);
          },
          child: Stack(
            children: <Widget>[
              Card(
                elevation: 1,
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
                      )
                    ],
                  ),
                  padding:
                      EdgeInsets.only(right: 12, left: 12, top: 10, bottom: 10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        d.id == null
                                            ? Container()
                                            : Expanded(
                                                child: Container(
                                                  child: Text(
                                                    d.id == null
                                                        ? "---"
                                                        : "Order Id: " +
                                                            d.id.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    // textDirection:
                                                    //     TextDirection.ltr,
                                                    style: TextStyle(
                                                        color: appColor,
                                                        fontFamily:
                                                            "sourcesanspro",
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                    d.status == null
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              d.status == null
                                                  ? "---"
                                                  : 'Order Status is ' +
                                                      d.status.toString(),
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
                                    d.mobile1 == null && d.mobile2 == null
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              d.mobile1 == null
                                                  ? 'Mobile: ' +
                                                      d.mobile2.toString()
                                                  : 'Mobile: ' +
                                                      d.mobile1.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              //  textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                  color: Color(0xFF343434),
                                                  fontFamily: "sourcesanspro",
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                                      d.grandTotal.toString() +
                                                      " BHD",
                                              overflow: TextOverflow.ellipsis,
                                              //  textDirection: TextDirection.ltr,
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
                                    d.date == null
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              d.status_updated_at == null
                                                  ? ''
                                                  : "Status Date : " +
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
      );
    }

    return list;
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
                                    items:
                                        _sort.map((String dropDownStringItem) {
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

  /////////  select items///

  void _showSelectItem(String msg) {
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
                      child: Text(msg,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 15))),
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
                        width: 80,
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

  void _showStatusAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return
            // _isDropData
            //     ? Center(
            //       child: Container(
            //                   padding: EdgeInsets.only(top: 5, bottom: 15),
            //                   child: new Text("Please wait to change status...")),
            //        //child: CircularProgressIndicator(),
            //       )
            //     :
            AlertDialog(
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                title: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 5, bottom: 15),
                          child: new Text("Change Status")),
                      Divider(
                        height: 0,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
                content: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 40, top: 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(statusData.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLoading = false;
                                sendStatus = statusData[index].name;
                              });

                              if (statusData[index].id == 6) {
                                // Navigator.of(context).pop();
                                _showDate();

                                // print("object");
                              }
                              if (statusData[index].id == 3) {
                                _setDriver();
                              } else if (statusData[index].id == 7) {
                                _cancelOrder(
                                    "Are you sure want to deliver this order?");
                              }
                              if (statusData[index].id == 8) {
                                _cancelOrder(
                                    "Are you sure want to cancel this order?");
                              } else {
                                // _selectStatus();
                                Navigator.of(context).pop();
                              }

                              //  print(sendStatus);
                            },
                            child: Container(
                              // child: Text('name'),
                              padding: EdgeInsets.only(bottom: 12, top: 12),
                              alignment: Alignment.centerLeft,
                              child: Text(statusData[index].name),
                              // child: Column(
                              //   children: <Widget>[

                              //   ],
                              // ),
                            ),
                          );
                        })),
                  ),
                ));
      },
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
                      _searchDriver
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
            assignId = d.id == null ? "" : d.id;
            drivername = d.firstName + " " + d.lastName;

            // productId = d.id;
            _driverfound = true;
          });

          Navigator.of(context).pop();
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
                              _selectStatus();
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
      'status': assignId == "" ? sendStatus : sendStatus + " " + drivername,
      'deliveryDate': date,
      'orders': selectList,
      'driverId': assignId,
    };

    //  print(data);

    var res = await CallApi().postData(data, '/app/editOrderbulkStatus');

    var body = json.decode(res.body);
    print("body");
    print(body);

    if (body['success'] == true) {
      selectList = [];
      markList = [];
      _showOrders();

      // print("success");
      // Navigator.push(context, SlideLeftRoute(page: OrderList()));
    } else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isOrderStatusLoading = false;
    });
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
                            _isLoading
                                ? null
                                : date == ""
                                    ? null
                                    : _selectStatus();
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
