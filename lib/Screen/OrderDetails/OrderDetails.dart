import 'dart:convert';

import 'package:bahrain_admin/Screen/AssignDriver/AssignDriver.dart';
import 'package:bahrain_admin/Screen/EditOrder/EditOrder.dart';
import 'package:bahrain_admin/Screen/OrderPage/OrderItem/OrderItem.dart';
import 'package:bahrain_admin/Screen/OrderPage/OrderList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class OrderDetails extends StatefulWidget {
  var data;
  OrderDetails(this.data);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  var body;
 var taxStatus;
var taxAmount;
  bool _isLoading = false;
double taxFinal=0.0;
  @override
  void initState() {
   // print(widget.data.customer.discount);
    _showTax();
    super.initState();
  }
      ///////////  get tax
    Future<void> _showTax() async {
  //  var key = 'tax-list';
  //  await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/getAllTax');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      if (!mounted) return;
        setState(() {
      taxStatus = body['alltax'][0]['isOn'];
      taxAmount = body['alltax'][0]['tax'];
      
     
      _isLoading = false;
    });

   
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new AppBar(
      //   backgroundColor: appColor,
      //   title: const Text('Order Details'),
      // ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              automaticallyImplyLeading: false,
              // leading:
              backgroundColor: appColor,
              expandedHeight: 180.0,
              //floating: false,
              pinned: true,

              title: Container(
                //color: Colors.red,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 0, bottom: 8, top: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: IconButton(
                          onPressed: () {
                           // driverId = "";
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Order Details ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "DINPro",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
              ),

              // actions: <Widget>[
              //   Row(
              //     children: <Widget>[
              //       IconButton(
              //         icon: Icon(Icons.edit),
              //         onPressed: () {

              //             Navigator.push(context, SlideLeftRoute(page: EditOrder(widget.data)));
              //         },
              //       ),
              //       IconButton(
              //         icon: Icon(Icons.delete),
              //         onPressed: () {
              //           _deleteOrder();
              //         },
              //       )
              //     ],
              //   )
              // ],

              flexibleSpace: new FlexibleSpaceBar(

                  ////////////////////Collapsed Bar/////////////////
                  background: Container(
                child: Container(
                  //constraints: new BoxConstraints.expand(height: 256.0, ),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new AssetImage('assets/images/ecom.jpg'),
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.darken),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )

                  ////////////////////Collapsed Bar  End/////////////////

                  ),
            ),
            // ShopPageTopBar(widget.shop)
          ];
        },
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            // width: MediaQuery.of(context).size.width,
            //color: Colors.red,
            child: Column(
              children: <Widget>[
                ////////// Order /////////
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 2),
                  padding: EdgeInsets.fromLTRB(15, 18, 15, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 17,
                        //offset: Offset(0.0,3.0)
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Order# ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: appColor,
                            fontFamily: "DINPro",
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),

                      Divider(
                        color: Colors.grey[600],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //////// Order Number/////////

                      Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Order Number: ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "DINPro",
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.data.id == null
                                  ? "---"
                                  : widget.data.id.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "DINPro",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      //////// Order Number end /////////

                      SizedBox(
                        height: 7,
                      ),
                      //////// Order Status/////////

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Order Status: ",
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
                              //color: Colors.red,
                              //   height: 100,
                              //width: MediaQuery.of(context).size.width/2+100,
                              child: Text(
                                widget.data.status == null
                                    ? "---"
                                    : widget.data.status.toString(),
                                textAlign: TextAlign.left,
                                // maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color:  Color(
                                                    0xFF343434), //Color(0xFFffa900),
                                    fontFamily: "DINPro",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //////// Order Status end /////////
                      SizedBox(
                        height: 7,
                      ),
                      /////  Order Date ///

                      Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Order Date: ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "DINPro",
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.data.date == null
                                  ? "---"
                                  : widget.data.date.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "DINPro",
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                      widget.data.used_vaoucher==null ||  widget.data.used_vaoucher.voucher == null?Container():SizedBox(
                        height: 7,
                      ),
                      
                   widget.data.used_vaoucher==null ||  widget.data.used_vaoucher.voucher == null?Container():  Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Coupon: ",                           
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "DINPro",
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                       widget.data.used_vaoucher==null ||  widget.data.used_vaoucher.voucher == null?Container():  Container(
                            child: Text( 
                             
                               widget.data.used_vaoucher.voucher == null ||
                                widget.data.used_vaoucher.voucher.code == null
                                  ? "---"
                                  :  widget.data.used_vaoucher.voucher.code.toString()+" ("+widget.data.used_vaoucher.voucher.discount.toString()+"%)",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black54,      
                                  fontFamily: "DINPro",
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                      SizedBox( 
                        height: widget.data.driver!=null? 7:0, 
                      ),
                    widget.data.driver!=null?
                      buyerInfo(
                          "Driver: ",
                          widget.data.driver.firstName == null && 
                           widget.data.driver.lastName == null
                              ? ""
                              : ' ${widget.data.driver.firstName}' ' ${widget.data.driver.lastName}'):Container(), 

                        SizedBox(
                        height: 7,
                      ),
                      widget.data.note == null?Container(): buyerInfo(
                          "Note: ",
                          widget.data.note == null
                              ? ""
                              : ' ${widget.data.note}'),

                    ],
                  ),
                ),

                ////////// Order end/////////

                ///buyer //
                Column(
                  children: <Widget>[
                    Container(
                     // width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 7),
                      padding: EdgeInsets.fromLTRB(15, 15, 18, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 17,
                            //offset: Offset(0.0,3.0)
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Buyer# ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: appColor,
                                fontFamily: "DINPro",
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                              
                          Divider(
                            color: Colors.grey[600],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          widget.data.firstName == null &&
                                  widget.data.lastName == null &&
                                  widget.data.mobile1 == null &&
                                  widget.data.mobile2 == null &&
                                  widget.data.house == null &&
                                  widget.data.street == null &&
                                  widget.data.road == null &&
                                  widget.data.block == null &&
                                  widget.data.area == null &&
                                  widget.data.city == null &&
                                  widget.data.state == null &&
                                  widget.data.country == null
                              ? Center(
                                  child: Text(
                                  "Buyer Information is not available",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: "DINPro",
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ))
                              :
                              //// Buyer //
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width/2,
                                  //  color: Colors.red,
                                    child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "Buyer Name: ",
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
                                                    child: RichText(
                                                  text: TextSpan(
                                                    //  text: 'Hello ',
                                                    style: TextStyle(
                                                        color: appColor,
                                                        fontFamily: "DINPro",
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.normal),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: widget.data.firstName ==
                                                                  null
                                                              ? ""
                                                              : '${widget.data.firstName}'),
                                                      TextSpan(
                                                        text: widget.data.lastName ==
                                                                null
                                                            ? ""
                                                            : ' ${widget.data.lastName}',
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                              ),
                                            ],
                                          ),
                                         
                                          widget.data.mobile1 == null
                                              ? Container()
                                              : Column(
                                                children: <Widget>[
                                                   SizedBox(
                                                        height: 7,
                                                      ),
                                                  buyerInfo(
                                                  "Mobile No 1: ",
                                                  widget.data.mobile1 == null
                                                      ? ""
                                                      : ' ${widget.data.mobile1}'),

                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      
                                                ],
                                              ),
                                              
                                              
                                         
                                          widget.data.mobile2 == null
                                              ? Container()
                                              : Column(
                                                children: <Widget>[
                                                    
                                                  buyerInfo(
                                                  "Mobile No 2: ",
                                                  widget.data.mobile2 == null
                                                      ? ""
                                                      : ' ${widget.data.mobile2}'),

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
                                                 
                                                 buyerInfo(
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
                                                 
                                                 buyerInfo(
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
                                                 
                                                buyerInfo(
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
                                                 
                                                buyerInfo(
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
                                                 
                                              buyerInfo(
                                                  "Street: ",
                                                   widget.data.street == null
                                                      ? ""
                                                      : ' ${widget.data.street}'),

                                                      SizedBox(
                                                        height: 7,
                                                      )
                                                ],
                                              ),
                            

                                          

                                          ////////Delivery Address end /////////

                                          //////// Delivery City/////////
                                          widget.data.city == null &&
                                                  widget.data.state == null &&
                                                  widget.data.country == null
                                              ? Container()
                                              : Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        "City: ",
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: "DINPro",
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.normal),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                          child: RichText(
                                                        text: TextSpan(
                                                          //  text: 'Hello ',
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontFamily: "DINPro",
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight.normal),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: widget.data
                                                                            .state ==
                                                                        null
                                                                    ? ""
                                                                    : '${widget.data.state} ,'),
                                                            TextSpan(
                                                              text: widget.data.city ==
                                                                      null
                                                                  ? ""
                                                                  : ' ${widget.data.city} ,',
                                                            ),
                                                            TextSpan(
                                                              text: widget.data
                                                                          .country ==
                                                                      null
                                                                  ? ""
                                                                  : ' ${widget.data.country}',
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                  ),
                                   GestureDetector(
                          onTap: () {
                            launch(
                              widget.data.mobile1!=null?
                                // 'https://api.whatsapp.com/send?phone=+8801720848705':
                                // 'https://api.whatsapp.com/send?phone=+8801720848705'
                                'https://api.whatsapp.com/send?phone=${widget.data.mobile1}':
                                'https://api.whatsapp.com/send?phone=${widget.data.mobile2}'
                                
                                
                                );
                            // Navigator.push(
                            //     context, SlideLeftRoute(page: Navigation(0)));
                          }, 
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                              radius: 30.0, 
                              backgroundImage:
                                  AssetImage('assets/images/whatsapp.png')),
                        ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ],
                ),

                ////////// Amount Details /////////
                Container(
                  margin:
                      EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 5),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 17,
                        //offset: Offset(0.0,3.0)
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ////// Fee start///////

                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Amount Details# ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "DINPro",
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal),
                            ),
                            Divider(
                              color: Colors.grey[600],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            widget.data.subTotal == null &&
                                    widget.data.shippingPrice == null &&
                                    widget.data.discount == null &&
                                    widget.data.grandTotal == null
                                ? Center(
                                    child: Text(
                                    "Amount Information is not available",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: "DINPro",
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ))
                                : Column(
                                    children: <Widget>[
                                      /////Subtotal////////
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        // width:
                                        //     MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Payment Type",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Container(
                                              //color: Colors.red,
                                              //width: 90,
                                               width:MediaQuery.of(context).size.width/2,
                                              alignment: Alignment.centerRight,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                widget.data.paymentType == null
                                                    ? "---"
                                                    : '${widget.data.paymentType}',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: appColor,
                                                    fontFamily: "DINPro",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        // width:
                                        //     MediaQuery.of(context).size.width/2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Subtotal",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Container(
                                              //color: Colors.red,
                                             // width: 90,
                                               width:
                                            MediaQuery.of(context).size.width/2,
                                              alignment: Alignment.centerRight,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                widget.data.subTotal == null
                                                    ? "0.00 BHD"
                                                    : '${widget.data.subTotal} BHD',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //////Subtotal end//////
    /////Discount////////
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        // width:
                                        //     MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "User Discount",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Container(
                                              //color: Colors.red,
                                             // width: 90,
                                               width:
                                            MediaQuery.of(context).size.width/2,
                                              alignment: Alignment.centerRight,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                              widget.data.discount == null 
                                                    ? "0.00 %"
                                                    : '${widget.data.discount} %',
                                                 textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// coupon discount///
                                      
                                     widget.data.used_vaoucher==null?Container():   Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        // width:
                                        //     MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Coupon Discount",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Container(
                                              //color: Colors.red,
                                             // width: 90,
                                               width:
                                            MediaQuery.of(context).size.width/2,
                                              alignment: Alignment.centerRight,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                widget.data.discount == null 
                                                    ? "0.00 %"
                                                    : widget.data.used_vaoucher ==null||widget.data.used_vaoucher.voucher==null|| widget.data.used_vaoucher.voucher.code == null
                                  ? "---"
                                  : widget.data.used_vaoucher.voucher.discount.toString()+"%",
                                                 textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                     fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      /////Delivery fee////////
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        // width:
                                        //     MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Shipping Cost",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Container(
                                              //color: Colors.red,
                                             /// width: 90,
                                            width:
                                            MediaQuery.of(context).size.width/2,
                                              alignment: Alignment.centerRight,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                widget.data.shippingPrice ==
                                                        null
                                                    ? " 0.00"
                                                    : '${widget.data.shippingPrice} BHD',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ////// fee end//////
                                      
                                      _isLoading?Container():  taxStatus==0?Container() :
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        // width:
                                        //     MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Tax",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Container(
                                              //color: Colors.red,
                                             /// width: 90,
                                            width:
                                            MediaQuery.of(context).size.width/2,
                                              alignment: Alignment.centerRight,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                taxAmount==
                                                        null
                                                    ? " 0.00 %"
                                                    : '$taxAmount %',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                  
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        height: 0.5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.grey,
                                      ),

                                      //////// total start///////

                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        // width:
                                        //     MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Total",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              //color: Colors.red,
                                            //  width: 90,
                                              width:
                                            MediaQuery.of(context).size.width/2,
                                              alignment: Alignment.centerRight,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                widget.data.grandTotal == null
                                                    ? " 0.00 BHD"
                                                    : '${widget.data.grandTotal} BHD',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "DINPro",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //////Subtotal end//////
                                      //////Delivery fee end//////
                                    ],
                                  ),
                          ],
                        ),
                      ),

                      //     //////// total end///////
                    ],
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 60),
                  padding: EdgeInsets.fromLTRB(15, 18, 15, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 17,
                        //offset: Offset(0.0,3.0)
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //////// Title start///////

                      Text(
                        "Items# ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: appColor,
                            fontFamily: "DINPro",
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),

                      Divider(
                        color: Colors.grey[600],
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      ////// Items start///////
                      widget.data.details.length == 0
                          ? Center(
                              child: Text(
                              "No Item is Available",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "DINPro",
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ))
                          : Container(
                              margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: //<Widget>[
                                    _showItems(),
                                //  OrderItem(),
                                //  OrderItem(),
                                //  OrderItem(),
                                // ],
                                // children: _showItems(),
                              ),
                            ),

                      ////// Items end///////

                      //////// Title end///////
                    ],
                  ),
                ),

                //////// Item Details end/////////
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EditOrder(widget.data)));
        },
        backgroundColor: appColor,
        child: Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  List<Widget> _showItems() {
    List<Widget> list = [];
    int i = 0;
    int len = widget.data.details.length;
    for (var d in widget.data.details) {
      i++;

      list.add(OrderItem(d, i, len));
    }

    return list;
  }

  Row buyerInfo(String label, String details) {
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

  void _deleteOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Are you sure want to delete this product?",
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

  void _deleteOrders() async {
    // print(widget.data.id);

    var data = {
      'id': widget.data.id,
    };

    var res = await CallApi().postData(data, '/app/deleteOrder');
    var body = json.decode(res.body);

    if (body['success'] == true) {
      Navigator.push( context, FadeRoute(page: OrderList()));
    }
  }
}
