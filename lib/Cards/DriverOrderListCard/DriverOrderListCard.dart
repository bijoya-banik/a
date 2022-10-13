import 'dart:convert';

import 'package:bahrain_admin/Screen/AssignDriver/AssignDriver.dart';
import 'package:bahrain_admin/Screen/CancelOrderDetails/CancelOrderDetails.dart';
import 'package:bahrain_admin/Screen/DriverOrderList/DriverOrderList.dart';
import 'package:bahrain_admin/Screen/OrderDetails/OrderDetails.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductDetails.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DriverOrderListCard extends StatefulWidget {
  var data;
  DriverOrderListCard(this.data);

  @override
  _DriverOrderListCardState createState() => _DriverOrderListCardState();
}

class _DriverOrderListCardState extends State<DriverOrderListCard> {


  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CancelOrderDetails(widget.data)));
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
                padding:
                    EdgeInsets.only(right: 12, left: 12, top: 10, bottom: 10),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width /
                                                2 +
                                            10,
                                        child: Text(
                                          widget.data.id == null
                                              ? "---"
                                              : "Order Id: " +
                                                  widget.data.id.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                              color: appColor,
                                              fontFamily: "sourcesanspro",
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      widget.data.status == null
                                          ? "---"
                                          : 'Order Status is ' +
                                              widget.data.status.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          color: Color(0xFF343434),
                                          fontFamily: "sourcesanspro",
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  widget.data.mobile1 == null &&
                                          widget.data.mobile2 == null
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(
                                            widget.data.mobile1 == null
                                                ? 'Mobile: ' +
                                                    widget.data.mobile2.toString()
                                                : 'Mobile: ' +
                                                    widget.data.mobile1
                                                        .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                                color: Color(0xFF343434),
                                                fontFamily: "sourcesanspro",
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),

                                                               widget.data.grandTotal==null?Container():
                      Container(
                                 margin: EdgeInsets.only(top: 5),
                                 child: Text(

                                  
                                   widget.data.grandTotal==null?'':"Total : "+widget.data.grandTotal.toString()+" BHD",
                
                                   overflow: TextOverflow.ellipsis,
                                   textDirection: TextDirection.ltr,
                                   style: TextStyle(
                                       color: 
                                       Color(0xFF343434),
                                       fontFamily: "sourcesanspro",
                                       fontSize: 14,
                                       fontWeight: FontWeight.normal),
                                 ),
                               ),
                                  widget.data.date==null?Container():
                             Container(
                                 margin: EdgeInsets.only(top: 5),
                                 child: Text(

                                  
                                   widget.data.date==null?'':"Date : "+widget.data.date.toString(),
                
                                   overflow: TextOverflow.ellipsis,
                                   textDirection: TextDirection.ltr,
                                   style: TextStyle(
                                       color: 
                                       Color(0xFF343434),
                                       fontFamily: "sourcesanspro",
                                       fontSize: 14,
                                       fontWeight: FontWeight.normal),
                                 ),
                               ),
                               
                                ],
                              ),
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.edit,
                          //   color: appColor,),
                          //   onPressed: (){

                          //   },

                          // )
                          // GestureDetector(
                          //   onTap: () {
                          //        Navigator.push(context, SlideLeftRoute(page: AssignDriver(widget.data))); 
                          //   },
                          //   child: Text(
                          //     "Change Driver",
                          //     style: TextStyle(color: appColor),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.data.isClick != null
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
 
     widget.data.status=="Delivered"?Container():  IconSlideAction(
      caption: 'Edit',
      color: Colors.grey[350],
      icon: Icons.edit,
     onTap: (){
      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AssignDriver(widget.data))); 
       
     }
     )
     ]
    );
  }
}
