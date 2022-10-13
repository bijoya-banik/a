import 'dart:convert';

import 'package:bahrain_admin/Cards/CouponListCard/CouponListCard.dart';
import 'package:bahrain_admin/Cards/ProductListCard/ProductListCard.dart';
import 'package:bahrain_admin/Cards/VariationListCard/VariationListCard.dart';
import 'package:bahrain_admin/Cards/VariationValueListCard/VariationValueListCard.dart';
import 'package:bahrain_admin/Model/CouponModel/CouponModel.dart';
import 'package:bahrain_admin/Model/ShowProductModel/ShowProductModel.dart';
import 'package:bahrain_admin/Model/ShowVariationModel/ShowVariationModel.dart';
import 'package:bahrain_admin/Model/ShowVariationValueModel/ShowVariationValueModel.dart';
import 'package:bahrain_admin/Screen/AddCoupon/AddCoupon.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/Screen/AddProductVariationValue/AddProductVariationValue.dart';
import 'package:bahrain_admin/Screen/CouponsOrderList/CouponsOrderList.dart';
import 'package:bahrain_admin/Screen/HomePage/HomePage.dart';
import 'package:bahrain_admin/Screen/ProductTypeView/ProductTypeView.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCouponList extends StatefulWidget {
  @override
  _ShowCouponListState createState() => _ShowCouponListState();
}

class _ShowCouponListState extends State<ShowCouponList> {
  var body;
  List productsData = [];
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
    var products = CouponModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      productsData = products.coupon;
      _isLoading = false;
    });

    // print(productsData);
  }

  Future<void> _showProducts() async {
    var key = 'coupon-list';
    await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/getCoupon');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _bestProductsState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  //////////////// get  products end ///////////////
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
          title: Text("Coupons"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push( context, FadeRoute(page: HomePage()));
                },
              );
            },
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : productsData.length == 0
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
                        "No Coupons Found",
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
        bottomNavigationBar: BottomAppBar(
          child: GestureDetector(
            onTap: () {
             Navigator.push( context, FadeRoute(page: AddCoupon()));
            },
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: appColor,
                  ),
                  Text(" Add New Coupon",
                      style: TextStyle(color: appColor, fontSize: 18)),
                ],
              ),
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
      
      //   print(d.status);

      list.add(GestureDetector(
      

        onTap: (){
print(d.id);
             Navigator.push( context, FadeRoute(page: CouponsOrderList(d.id)));

        },
        child: CouponListCard(d))
          // NotificationCard(d)
          );
    }

    return list;
  }
}
