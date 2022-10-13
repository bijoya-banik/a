
import 'package:bahrain_admin/Screen/AddOrder/AddOrders.dart';
import 'package:bahrain_admin/Screen/AddOrderGuest/AddOrderGuest.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/Screen/CancelOrderList/CancelOrderList.dart';
import 'package:bahrain_admin/Screen/CreateType/CreateType.dart';
import 'package:bahrain_admin/Screen/DeliveredOrderList/DeliveredOrderList.dart';
import 'package:bahrain_admin/Screen/DriverList/DriverList.dart';
import 'package:bahrain_admin/Screen/HomePage/HomePage.dart';
import 'package:bahrain_admin/Screen/OrderPage/OrderList.dart';
import 'package:bahrain_admin/Screen/PendingOrderList/PendingOrderList.dart';
import 'package:bahrain_admin/Screen/ProductPage/FeatureProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/NewProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductList.dart';
import 'package:bahrain_admin/Screen/ShowShippingCostList/showShippingCostList.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class OrderType extends StatefulWidget {
  @override
  _OrderTypeState createState() => _OrderTypeState();
}

class _OrderTypeState extends State<OrderType> {

  @override
  void initState() {
     visit = false;
    super.initState();
  }

   Future<bool> _onWillPop() async {
    Navigator.push( context, FadeRoute(page: HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(

         appBar: AppBar(
          backgroundColor: appColor,
          leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { 
             Navigator.push(
            context, new MaterialPageRoute(builder: (context) => HomePage()));
          },
        );
      },
  ),
          title: Text("Orders",
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),

        body: SafeArea(
                child: new Container(
                    padding: EdgeInsets.all(0.0),
                    //color: Colors.white,
                    child: Column(
                      children: <Widget>[
                       
                      
                        Expanded(
                          child: Container(
                            child: ListView(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                     Navigator.push(
            context, new MaterialPageRoute(builder: (context) => OrderList()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 8, bottom: 8),
                                    child: ListTile(
                                      title: Container(
                                          child: Row(
                                        children: <Widget>[
                                         
                                          Container(
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Orders',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      )),
                                      trailing: Icon(Icons.chevron_right),
                                    ),
                                  ),
                                ),
                                Divider(height: 0,color: Colors.grey,),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push( context, FadeRoute(page: CancelOrderList()));
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(top: 8, bottom: 8),
                                    child: ListTile(
                                      title: Container(
                                        
                                          child: Row(
                                        children: <Widget>[
                                         
                                          Container(
                                            

                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Canceled Order',
                                              style:
                                                  TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      )),
                                      trailing: Icon(Icons.chevron_right),
                                    ),
                                  ),
                                ),
 Divider(height: 0,color: Colors.grey,),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push( context, FadeRoute(page: DeliveryOrderList()));
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(top: 8, bottom: 8),
                                    child: ListTile(
                                      title: Container(
                                        
                                          child: Row(
                                        children: <Widget>[
                                         
                                          Container(
                                            

                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Delivered Order',
                                              style:
                                                  TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      )),
                                      trailing: Icon(Icons.chevron_right),
                                    ),
                                  ),
                                ),
             
                              Divider(height: 0,color: Colors.grey,),
                                GestureDetector(
                                  onTap: () {
                                   Navigator.push( context, FadeRoute(page: PendingOrderList()));
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(top: 8, bottom: 8),
                                    child: ListTile(
                                      title: Container(
                                        
                                          child: Row(
                                        children: <Widget>[
                                         
                                          Container(
                                            

                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Pending Order',
                                              style:
                                                  TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      )),
                                      trailing: Icon(Icons.chevron_right),
                                    ),
                                  ),
                                ),
                               
                      /////// for driver/////
                               Divider(height: 0,color: Colors.grey,),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push( context, FadeRoute(page: DriverList()));
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(top: 8, bottom: 8),
                                    child: ListTile(
                                      title: Container(
                                        
                                          child: Row(
                                        children: <Widget>[
                                         
                                          Container(
                                            

                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'All Driver',
                                              style:
                                                  TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      )),
                                      trailing: Icon(Icons.chevron_right),
                                    ),
                                  ),
                                ),

                                 /////// for shipping cost/////
                               Divider(height: 0,color: Colors.grey,),
                                GestureDetector(
                                  onTap: () {
                                   Navigator.push( context, FadeRoute(page: ShowShippingCostList()));
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(top: 8, bottom: 8),
                                    child: ListTile(
                                      title: Container(
                                        
                                          child: Row(
                                        children: <Widget>[
                                         
                                          Container(
                                            

                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Shipping Cost',
                                              style:
                                                  TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      )),
                                      trailing: Icon(Icons.chevron_right),
                                    ),
                                  ),
                                ),

                              
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              ),
                  floatingActionButton: FloatingActionButton(
          onPressed: () {
             Navigator.push( context, FadeRoute(page: AddOrder()));
          },
          backgroundColor: appColor,
          child: Icon(Icons.add, color: Colors.white),
        ),

        
      ),
    );
  }

  
}