import 'dart:convert';

import 'package:bahrain_admin/Menu.dart';
import 'package:bahrain_admin/Model/DriverModel/DriverModel.dart';
import 'package:bahrain_admin/Model/NotificationModel/NotificationModel.dart';
import 'package:bahrain_admin/Model/ShowOrderModel/ShowOrderModel.dart';
import 'package:bahrain_admin/Model/StatusModel/StatusModel.dart';
import 'package:bahrain_admin/Screen/HomePage/HomePage.dart';
import 'package:bahrain_admin/Screen/OrderDetails/OrderDetails.dart';
import 'package:bahrain_admin/Screen/OrderPage/OrderList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List notificData=[];
  bool _isLoading = true;
  bool _isDelete  = false;
  bool _notificLoading = true;
  var body;
  var driverData;
  var statusData;

  @override 
  void initState() {

    visit = true;
    _allData();
    super.initState();
  }  

  Future<void> _allData() async {
    _showAllNotifications();
    _updateAllNotifications();
    _showStatus();
    _showDriver();
  }



    void _statusState() {
    var statuses = StatusModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      // _isLoading = true;

      statusData = statuses.statuses;
      // for (int i = 0; i < statusData.length; i++) {
      //   _status.add(statusData[i].name);
      // }

      _isLoading = false;

     // _isDropData = false;
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

  //////////////// get  orders start ///////////////

  Future _getLocalOrderData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localOrderData = localStorage.getString(key);
    if (localOrderData != null) {
  
      body = json.decode(localOrderData);
        //  print(body);
      _orderState();
    }
  }

  void _orderState() {
    var notifis = NotificationModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      notificData = notifis.notification;
      _notificLoading = false;
    });

    // print(orderData);
  }

  Future<void> _showAllNotifications() async {
    var key = 'all-notifications-list';
    await _getLocalOrderData(key);

    var res = await CallApi().getData('/app/adminNotification');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _orderState();

      // print("body");
      // print(body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  ////////////// get  update end ///////////////
  
  
    Future<void> _updateAllNotifications() async {

    var res = await CallApi().getData('/app/seenAllNotifications');
    body = json.decode(res.body);
    //print(body);
    
  }

   Future<bool> _onWillPop() async {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                  },
                );
              },
            ),
            backgroundColor: appColor,
            //   elevation: 0,
            title: Text(
              "Notifications",
              style: TextStyle(color: Colors.white),
            ),
            actions: [       
                _isDelete ||  notificData.length==0?Container(): Container(
                 margin: EdgeInsets.only(top:10),
             // alignment: Alignment.topRight,
                child: PopupMenuButton<String>(
                onSelected: choiceAction,
                icon: Icon(     
                  Icons.more_vert,
                  color: Colors.white,     
                ),
                itemBuilder: (BuildContext context) {   
                  return Notific.choices.map((String choice) {
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
        body: _notificLoading || _isDelete
            ? Center(
                child: CircularProgressIndicator(
                  // backgroundColor: Colors.green,
                ),
              )
            : RefreshIndicator(
                onRefresh: _allData,
                child: SafeArea(
                  top: false,
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child:  notificData.length==0?
                         Stack(
                            children: <Widget>[ 
                              Center(
                                child: Container(
                                  child: Text("You have no new notification"),
                                  // decoration: new BoxDecoration(
                                  //     shape: BoxShape.rectangle,
                                  //     image: new DecorationImage(
                                  //       fit: BoxFit.fill,
                                  //       image:
                                  //           new AssetImage('assets/images/noproduct.png'),
                                  //     ))
                                ),
                              ),
                              ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                              )
                            ],
                          )
                        : SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 12),
                              child: // _isLoading?CircularProgressIndicator():

                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: _showNotifications()),
                            ),
                          ),
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> _showNotifications() {
    List<Widget> list = [];
    // int checkIndex=0;
    for (var d in notificData) {
      // checkIndex = checkIndex+1;

      //print("seeen") ;
      //print(d.seen);
      //   print(d.status);

      list.add(NotificationCard(d,notificData));
    }

    return list;
  }

      void choiceAction(String choice) {
    if (choice == Notific.Delete) {

                showItemAlert();
   
     
    }
  
    }

      void _deleteAll() async{

    setState(() {
      _isDelete = true;
    });

 var data = {             
      'userId': 0,
    };

    var res = await CallApi().postData(data, '/app/deleteAllNotification');
    // var body = json.decode(res.body);

      // print(res);              
    //   print(body);
   //   print(res.statusCode);    

    if (res.statusCode==200) {
      
                      
       SharedPreferences localStorage = await SharedPreferences.getInstance();
       localStorage.remove("all-notifications-list");
      

       setState(() {
          notificData.clear();
          //_showAllNotifications();
       });

     
    //  Navigator.push( context, FadeRoute(page: NotificationPage()));
    }

      setState(() {
      _isDelete = false;
    });

  }


    void showItemAlert(){

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: 
              Text(
                                "Are you sure want to delete all notification?",
                               // textAlign: TextAlign.,
                                style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontFamily: "grapheinpro-black",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),

                              content:    Container(
                    height: 70,
                    width: 250,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
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
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                              )),
                          Container(
                              decoration: BoxDecoration(
                                color:appColor.withOpacity(0.9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              width: 110,
                              height: 45,
                              margin: EdgeInsets.only(top: 25, bottom: 15),
                              child: //_buttonFunction
                              OutlineButton(
                                 // color: Colors.greenAccent[400],
                                  child: new Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    
                                     Navigator.of(context).pop();
                                    _deleteAll();
                                  },
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)))
                                          )
                        ])),
            
        );
        //return SearchAlert(duration);
      },
    );
  }
}

class NotificationCard extends StatefulWidget {
  var data;
  var allData;
  NotificationCard(this.data,this.allData);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool open = true;
  var orderedItem;
  var body;
  var detailsData;
  bool _isLoading= false;

    //////////////// get  orders start ///////////////

  // Future _getLocalOrderData(key) async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var localOrderData = localStorage.getString(key);
  //   if (localOrderData != null) {
  //     body = json.decode(localOrderData);
  //     _orderState();
  //   }
  // }

  void _orderState() {
    var detail = ShowOrderModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      detailsData = detail.order;
      _isLoading = false;
    });

    detailsData.length ==0?
       Toast.show("This order has been deleted,So you can't see this order details", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM):

      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OrderDetails(detailsData[0])));

    // print(orderData);
  }

  Future<void> _goOrderPage() async {
    var key = 'notifications-details';
  //  await _getLocalOrderData(key);
 // print(widget.data.id);

    setState(() {
      _isLoading = true;
    });
    var res = await CallApi().getData('/app/indexOrderforSingledetail?orderId=${widget.data.orderId}');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _orderState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  ////////////// get  update end ///////////////

  @override
  Widget build(BuildContext context) {
    return Slidable(
       actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child:GestureDetector(
      onTap: () {

        _goOrderPage();
        // bottomNavIndex = 2;

        // _showHistory();
        //  Navigator.push(context,
        // new MaterialPageRoute(builder: (context) => OrderList()));
      },
  
        child: _isLoading? Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          child:Text("please wait....")) : Card(
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
            padding: EdgeInsets.only(right: 12, left: 12, top: 10, bottom: 10),
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
                      // Container(
                      //  // alignment: Alignment.center,
                      //   margin: EdgeInsets.only(right: 10.0),
                      //   child: ClipOval(
                      //     child: Image.asset(
                      //     widget.data.title=="Order Completed"?'assets/img/completed.jpg' :
                      //      widget.data.title=="Order has been cancelled"?'assets/img/cancel.jpg' :
                      //       widget.data.title=="Status Changed"?'assets/img/status.jpg' :
                      //     widget.data.title=="Driver found"? 'assets/img/driver_found.jpg':'assets/img/g2.png',
                      //       height: 42,
                      //       width: 42,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Container(
                          //color: Colors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  widget.data.title == null
                                      ? ""
                                      : widget.data.title,

                                  //'Your Order Has been recived',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "sourcesanspro",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.data.msg == null ? "" : widget.data.msg,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      color: Color(0xFF343434),
                                      fontFamily: "sourcesanspro",
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
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
      ),
    
        secondaryActions: <Widget>[

       IconSlideAction(
      caption: 'Delete',
      color: Colors.red[100],
      icon: Icons.delete,
     onTap: (){
        showItemAlert(widget.data,);
       
     }
     )
       ]
    );
   
  }

    
     void showItemAlert(var d){

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: 
              Text(
                                "Are you sure want to delete this notification?",
                               // textAlign: TextAlign.,
                                style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontFamily: "grapheinpro-black",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),

                              content:    Container(
                    height: 70,
                    width: 250,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
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
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                              )),
                          Container(
                              decoration: BoxDecoration(
                                color:appColor.withOpacity(0.9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              width: 110,
                              height: 45,
                              margin: EdgeInsets.only(top: 25, bottom: 15),
                              child: //_buttonFunction
                              OutlineButton(
                                 // color: Colors.greenAccent[400],
                                  child: new Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    
                                     Navigator.of(context).pop();
                                     _deleteItem(d);
                                  },
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)))
                                          )
                        ])),
            
        );
        //return SearchAlert(duration);
      },
    );
  }

  void _deleteItem(var d) async{

    // setState(() {
    //   _isLoading = true;
    // });

 var data = {
      'id': d.id,
    };

    var res = await CallApi().postData(data, '/app/deleteNotification');
    var body = json.decode(res.body);

     print(body);

    if (body['success'] == true) {


    // print(widget.allData.length);
       widget.allData.remove(d);
          // print(widget.allData.length);
          //    print(widget.allData);
        // var data = {
        //   'body': widget.allData
        // };
        // print(data);
      //  SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString("all-notifications-list", json.encode(data));

     
      Navigator.push( context, FadeRoute(page: NotificationPage()));
    }

    //   setState(() {
    //   _isLoading = false;
    // });



  }




}
