import 'dart:convert';

import 'package:bahrain_admin/Model/ShowOrderModel/ShowOrderModel.dart';
import 'package:bahrain_admin/Screen/DriverList/DriverList.dart';
import 'package:bahrain_admin/Screen/DriverOrderList/DriverOrderList.dart';
import 'package:bahrain_admin/Screen/OrderDetails/OrderDetails.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverDetails extends StatefulWidget {
  final data;
  DriverDetails(this.data);
  @override
  _DriverDetailsState createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {


  var body;
  var orderData;
  bool _isLoading = true;


   Row driverInfo(String label, String details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            label,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "DINPro",
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Expanded(
          child: Container(
            child: Text(
              details,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "DINPro",
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {

   // print(object)
    driverId ="";

    super.initState();
  }

    Future<bool> _onWillPop() async {

        Navigator.push( context, FadeRoute(page:DriverList()));
       
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: appColor,
            title: Text("Driver Details", style: TextStyle(color: Colors.white)),
                 leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { 
     
      Navigator.push( context, FadeRoute(page:DriverList()));

           },
          
        );
      },
  ),
          ),
          body: SafeArea(
            child: new Container(
                padding: EdgeInsets.all(0.0),
                //color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                            padding: EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                 widget.data.profilepic!=null?
                                  NetworkImage(widget.data.profilepic):
                                  AssetImage('assets/images/camera.png'),
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.grey, // border color
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              widget.data.firstName == null &&
                                      widget.data.lastName == null
                                  ? Container()
                                  : Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "DINPro",
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: widget.data.firstName ==
                                                        null
                                                    ? ""
                                                    : '${widget.data.firstName}'),
                                            TextSpan(
                                              text: widget.data.lastName == null
                                                  ? ""
                                                  : ' ${widget.data.lastName}',
                                            ),
                                          ],
                                        ),
                                      )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 2,
                        child: Divider()),


                    Container(

                      margin: EdgeInsets.only(left: 20,top: 10),
                      child: Column(
                        children: <Widget>[
                              widget.data.mobile == null
                                            ? Container()
                                            : Column(
                                              children: <Widget>[
                                                 SizedBox(
                                                      height: 7,
                                                    ),
                                                driverInfo(
                                                "Mobile No : ",
                                                widget.data.mobile == null || widget.data.country_code==null
                                                    ? ""
                                                    : '${widget.data.country_code}'+'${widget.data.mobile}'),

                                                    SizedBox(
                                                      height: 7,
                                                    )
                                              ],
                                            ),
                            

                                     

                                        //////// Area Address/////////
                                         widget.data.area == null
                                            ? Container()
                                            : Column(
                                              children: <Widget>[
                                               
                                               driverInfo(
                                                "Area: ",
                                                widget.data.area == null
                                                    ? ""
                                                    : ' ${widget.data.area}'),

                                                    SizedBox(
                                                      height: 7,
                                                    )
                                              ],
                                            ),


                                       
                                       //////// house Address/////////
                                         widget.data.house == null
                                            ? Container()
                                            : Column(
                                              children: <Widget>[
                                               
                                               driverInfo(
                                                "House: ",
                                                widget.data.house == null
                                                    ? ""
                                                    : ' ${widget.data.house}'),

                                                    SizedBox(
                                                      height: 7,
                                                    )
                                              ],
                                            ),

                                  //////// road Address/////////
                                        widget.data.road == null
                                            ? Container()
                                            : Column(
                                              children: <Widget>[
                                               
                                              driverInfo(
                                                "Road: ",
                                                widget.data.road == null
                                                    ? ""
                                                    : ' ${widget.data.road}'),

                                                    SizedBox(
                                                      height: 7,
                                                    )
                                              ],
                                            ),

                                       
                                         //////// block Address/////////
                                        widget.data.block == null
                                            ? Container()
                                            : Column(
                                              children: <Widget>[
                                               
                                              driverInfo(
                                                "Block: ",
                                                widget.data.block == null
                                                    ? ""
                                                    : ' ${widget.data.block}'),

                                                    SizedBox(
                                                      height: 7,
                                                    )
                                              ],
                                            ), 

                                           //////// street Address/////////
                                         widget.data.street == null
                                            ? Container()
                                            : Column(
                                              children: <Widget>[
                                               
                                            driverInfo(
                                                "Street: ",
                                                 widget.data.street == null
                                                    ? ""
                                                    : ' ${widget.data.street}'),

                                                    SizedBox(
                                                      height: 7,
                                                    )
                                              ],
                                            ),

                                            
                                               //////// city Address/////////
                                         widget.data.state == null
                                            ? Container()
                                            : Column(
                                              children: <Widget>[
                                               
                                            driverInfo(
                                                "State: ",
                                                 widget.data.state == null
                                                    ? ""
                                                    : ' ${widget.data.state}'),

                                                    SizedBox(
                                                      height: 7,
                                                    )
                                              ],
                                            ),

                                                  //////// city Address/////////
                                         widget.data.city == null
                                            ? Container()
                                            : Column(
                                              children: <Widget>[
                                               
                                            driverInfo(
                                                "City: ",
                                                 widget.data.city == null
                                                    ? ""
                                                    : ' ${widget.data.city}'),

                                                    SizedBox(
                                                      height: 7,
                                                    )
                                              ],
                                            ),
                                           
                                      //////// Delivery Country/////////
                                      widget.data.country == null
                                            ? Container()
                                            : Column(
                                              children: <Widget>[
                                               
                                            driverInfo(
                                                "Country: ",
                                                 widget.data.country == null
                                                    ? ""
                                                    : ' ${widget.data.country}'),

                                                    SizedBox(
                                                      height: 7,
                                                    )
                                              ],
                                            ),
                                      
                        ],
                      ),
                    ),
                     

                          GestureDetector(
                    onTap: () {

                  //    _showOrders();
  Navigator.push( context, FadeRoute(page:DriverOrderList(widget.data)));
                     
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
                         
                          Container(
                         
                              child: Text("See all orders >",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)))
                        ],
                      ),
                    ),
                  ),
                              
                  ],
                )),
          )),
    );
  }
}
