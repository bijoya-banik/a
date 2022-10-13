import 'package:bahrain_admin/Form/AddProductForm/AddProductForm.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/Screen/AddProductVariation/AddProductVariation.dart';
import 'package:bahrain_admin/Screen/AddProductVariationValue/AddProductVariationValue.dart';
import 'package:bahrain_admin/Screen/CreateType/CreateType.dart';
import 'package:bahrain_admin/Screen/HomePage/HomePage.dart';
import 'package:bahrain_admin/Screen/ProductPage/FeatureProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/NewProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductList.dart';
import 'package:bahrain_admin/Screen/ShowNewVariationList/ShowNewVariationList.dart';
import 'package:bahrain_admin/Screen/ShowProductVariationList/ShowProductVariationList.dart';
import 'package:bahrain_admin/Screen/ShowVariableCombitionList/ShowVariableCombitionList.dart';
import 'package:bahrain_admin/Screen/ShowVariationValueList/ShowVariationValueList.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class ProductTypeView extends StatefulWidget {
  @override
  _ProductTypeViewState createState() => _ProductTypeViewState();
}

class _ProductTypeViewState extends State<ProductTypeView> {

   Future<bool> _onWillPop() async {
    Navigator.push( context, FadeRoute(page: HomePage()));
  }

  @override
  void initState() {
    visitDetails = "";
    super.initState();
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
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => HomePage()));
                },
              );
            },
          ),
          title: Text("Products",
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
                              Navigator.push( context, FadeRoute(page: ProductList()));
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
                                        'All Products',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                          ),
                          Divider(
                            height: 0,
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                               Navigator.push( context, FadeRoute(page: NewProductList()));
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
                                        'New Products',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                          ),

                          ////////////   pre-order list start  ////////////////////

                          Divider(
                            height: 0,
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                               Navigator.push( context, FadeRoute(page: FeatureProductList()));
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
                                        'Feature Products',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                          ),

                          /////////  variations/////
                          Divider(
                            height: 0,
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                               Navigator.push( context, FadeRoute(page: ShowNewVariationList()));
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
                                        'Variations',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                          ),

                                  ////////////   product variation start  ////////////////////

                          Divider(
                            height: 0,
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                               Navigator.push( context, FadeRoute(page: ShowProductVariationList()));
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
                                        'Product Variations',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                          ),



                                                          ////////////   product variation value start  ////////////////////

                          Divider(
                            height: 0,
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                               Navigator.push( context, FadeRoute(page: ShowVariationValueList()));
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
                                        'Product Variations Value',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                          ),


                          
                                                          ////////////   product variation combination start  ////////////////////

                          Divider(
                            height: 0,
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                               Navigator.push( context, FadeRoute(page: ShowVariableCombitionList()));
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
                                        'Combination & Update Stock',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                          ),


                           ////////////   add product variation start  ////////////////////

                          // Divider(
                          //   height: 0,
                          //   color: Colors.grey,
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(context,
                          //         SlideLeftRoute(page: ProductVariation()));
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.only(top: 8, bottom: 8),
                          //     child: ListTile(
                          //       title: Container(
                          //           child: Row(
                          //         children: <Widget>[
                          //           Container(
                          //             margin: EdgeInsets.only(left: 8),
                          //             child: Text(
                          //               'Add Product Variation',
                          //               style: TextStyle(color: Colors.black),
                          //             ),
                          //           ),
                          //         ],
                          //       )),
                          //       trailing: Icon(Icons.chevron_right),
                          //     ),
                          //   ),
                          // ),

                             ////////////   add product variation value start  ////////////////////

                          // Divider(
                          //   height: 0,
                          //   color: Colors.grey,
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(context,
                          //         SlideLeftRoute(page: AddProductVariationValue()));
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.only(top: 8, bottom: 8),
                          //     child: ListTile(
                          //       title: Container(
                          //           child: Row(
                          //         children: <Widget>[
                          //           Container(
                          //             margin: EdgeInsets.only(left: 8),
                          //             child: Text(
                          //               'Add Product Variation Value',
                          //               style: TextStyle(color: Colors.black),
                          //             ),
                          //           ),
                          //         ],
                          //       )),
                          //       trailing: Icon(Icons.chevron_right),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
             Navigator.push( context, FadeRoute(page: AddProductform()));
          },
          backgroundColor: appColor,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
