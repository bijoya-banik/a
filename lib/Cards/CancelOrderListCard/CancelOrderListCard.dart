import 'dart:convert';

import 'package:bahrain_admin/Screen/CancelOrderDetails/CancelOrderDetails.dart';
import 'package:bahrain_admin/Screen/CancelOrderList/CancelOrderList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';   

class CancelOrderListCard extends StatefulWidget {
  var data;
  CancelOrderListCard(this.data);
        
  @override                                                                   
  _CancelOrderListCardState createState() => _CancelOrderListCardState();
}

class _CancelOrderListCardState extends State<CancelOrderListCard> {
  //bool open = true;
 // var orderedItem;

bool _isData = false;


  @override
  Widget build(BuildContext context) {
    return _isData?Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          child:Text("please wait....")):
          Slidable(
       actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
      child: GestureDetector(
        onTap: () {
           Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>CancelOrderDetails(widget.data)));
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
                       
                          Expanded(
                            child: Container(
                             //color: Colors.red,
                             margin: EdgeInsets.only(left: 15),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: <Widget>[
                                     Container(
                                       width: MediaQuery.of(context).size.width / 2 +
                                           10,
                                       child: Text(
                                        widget.data.id==null?"---": "Order Id: "+widget.data.id.toString(),
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

                                    
                                     widget.data.status==null?"---":'Order Status is '+widget.data.status.toString(),
                                     overflow: TextOverflow.ellipsis,
                                     textDirection: TextDirection.ltr,
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

                                    
                                     widget.data.mobile1==null?'Mobile: '+widget.data.mobile2.toString():
                                     'Mobile: '+widget.data.mobile1.toString(),
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
                         
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

           widget.data.isClick!=null? Container(
              margin: EdgeInsets.all(8),
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.check_circle,
                                color: appColor,
                              ),
                            ):Container(),
            
          ],
        ),
      ),
      secondaryActions: <Widget>[
 
       IconSlideAction(
      caption: 'Remove',
      color: Colors.red[100],
      icon: Icons.delete,
     onTap: (){
        _deleteOrder();
       
     }
     )
     ]
    );
  }

   void _deleteOrder() {
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
                              _deleteOrders();
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

  void _deleteOrders() async{

       setState(() {
     _isData = true;
   });

 var data = {
      'id': widget.data.id,
    };

    var res = await CallApi().postData(data, '/app/deleteOrder');
    var body = json.decode(res.body);

    if (body['success'] == true) {
                                           
      //  Navigator.of(context).pop();
     
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => CancelOrderList()));
    }

         setState(() {
     _isData = false;
   });             
  }
}                                                     
 