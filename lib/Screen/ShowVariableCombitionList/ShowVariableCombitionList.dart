import 'dart:convert';

import 'package:bahrain_admin/Cards/ProductListCard/ProductListCard.dart';
import 'package:bahrain_admin/Cards/VariableCombinationCard/VariableCombinationCard.dart';
import 'package:bahrain_admin/Cards/VariationListCard/VariationListCard.dart';
import 'package:bahrain_admin/Model/ShowProductModel/ShowProductModel.dart';
import 'package:bahrain_admin/Model/ShowVariationModel/ShowVariationModel.dart';
import 'package:bahrain_admin/Model/VariationCombinationModel/VariationCombinationModel.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/Screen/ProductTypeView/ProductTypeView.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowVariableCombitionList extends StatefulWidget {
  @override
  _ShowVariableCombitionListState createState() =>
      _ShowVariableCombitionListState();
}

class _ShowVariableCombitionListState extends State<ShowVariableCombitionList> {
  var body;
  List productsData=[];
  bool _isLoading = true;

  @override
  void initState() {
    _allData();
    super.initState();
  }

  Future<void> _allData() async {
    _showProducts();
  }

  //////////////// get  products start ///////////////

  Future _getLocalBestProductsData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localbestProductsData = localStorage.getString(key);
    if (localbestProductsData != null) {
      body = json.decode(localbestProductsData);
      _bestProductsState();
    }
  }

  void _bestProductsState() {
    var products = VariationCombinationModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      productsData = products.productVariationCombination;
      _isLoading = false;
    });

    // print(productsData);
  }

  Future<void> _showProducts() async {
    var key = 'products-variations-combination-list';
    await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/indexproductVariationCombination');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _bestProductsState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  //////////////// get  products end ///////////////

Future<bool> _onWillPop() async {
    Navigator.push( context, FadeRoute(page: ProductTypeView()));
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          title: Text("Variation Combination"),

          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                   Navigator.push( context, FadeRoute(page: ProductTypeView()));
                },
              );
            },
          ),

          // actions: <Widget>[

          //   // Padding(
          //   //   padding: const EdgeInsets.all(8.0),
          //   //   child: Text("Add",style:TextStyle(color: Colors.white70)),
          //   // )
          //        Row(
          //          children: <Widget>[
          //            Text("Add",style:TextStyle(color: Colors.white70)),
          //           //  IconButton(
          //           //             onPressed: () {
          //           //                 //  Navigator.push(
          //           //                 //   context, SlideLeftRoute(page: EditVariationCombination(widget.data)));

          //           //             },

          //                      // icon:
          //                       Icon(
          //                         Icons.add,
          //                         color: Colors.white70,
          //                         size:18
          //                       ),

          //                     //),
          //          ],
          //        ),

          // ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : productsData.length==0
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
                                image:
                                    new AssetImage('assets/images/empty_box.png'),
                              ))),
                      Text(
                        "No Combination Found",
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _showProductsList()),
                      ),
                    ),
                  ),
   
      ),
    );
  }

  List<Widget> _showProductsList() {
    List<Widget> list = [];
    // int checkIndex=0;
    for (var d in productsData) {
      // print(d.category);
      // checkIndex = checkIndex+1;

      //print("seeen") ;
      //print(d.seen);
      //   print(d.status);

      list.add(VariableCombinationCard(d)
          // NotificationCard(d)
          );
    }

    return list;
  }
}
