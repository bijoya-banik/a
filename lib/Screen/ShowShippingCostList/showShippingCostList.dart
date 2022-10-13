import 'dart:convert';

import 'package:bahrain_admin/Cards/ProductListCard/ProductListCard.dart';
import 'package:bahrain_admin/Cards/VariationListCard/VariationListCard.dart';
import 'package:bahrain_admin/Cards/VariationValueListCard/VariationValueListCard.dart';
import 'package:bahrain_admin/Model/ShippingCostModel/ShippingCostModel.dart';
import 'package:bahrain_admin/Model/ShowProductModel/ShowProductModel.dart';
import 'package:bahrain_admin/Model/ShowVariationModel/ShowVariationModel.dart';
import 'package:bahrain_admin/Model/ShowVariationValueModel/ShowVariationValueModel.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/Screen/AddProductVariationValue/AddProductVariationValue.dart';
import 'package:bahrain_admin/Screen/EditShippingCost/EditShippingCost.dart';
import 'package:bahrain_admin/Screen/OrderType/OrderType.dart';
import 'package:bahrain_admin/Screen/ProductTypeView/ProductTypeView.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowShippingCostList extends StatefulWidget {
  @override
  _ShowShippingCostListState createState() => _ShowShippingCostListState();
}

class _ShowShippingCostListState extends State<ShowShippingCostList> {


var body;
var productsData;
bool  _isLoading = true;

  @override
  void initState() {
      _allData();
    super.initState();
  }

 Future<void> _allData() async {

    _showProducts();
  }

  //////////////// get  shipping cost start ///////////////

  Future _getLocalBestProductsData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localbestProductsData = localStorage.getString(key);
    if (localbestProductsData != null) {
      body = json.decode(localbestProductsData);
      _bestProductsState();
    }
  }

  void _bestProductsState() {
    var products = ShippingCostModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      productsData = products.shiping;
      _isLoading = false;
    });

   // print(productsData);
  }

  Future<void> _showProducts() async {
    var key = 'shipping-cost';
    await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/getShipingPrice');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _bestProductsState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  //////////////// get  shipping cost end ///////////////
  
 Future<bool> _onWillPop() async {
    Navigator.push( context, FadeRoute(page: OrderType()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          title: Text("Variations Value"),

             leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { 
  Navigator.push( context, FadeRoute(page: OrderType()));

           },
          
        );
      },
  ),
        ),
        body:_isLoading?Center(
            child: CircularProgressIndicator(),
          ):
           productsData==null? Center(
                      child:Column(
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
                                  image: new AssetImage('assets/images/empty_box.png'),
                                ))),

                                 Text(
                                          "No shipping cost added",
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
             // children: _showProductsList()
             children: <Widget>[
Slidable(
       actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
      child: Card(
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
                    Expanded(
                      child: Container(
                        //color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                   
                                    child: Text(
                                    "Shopping Cost",
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "sourcesanspro",
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                               
                               productsData.price == null
                                    ? ""
                                    :'${productsData.price}',
                                overflow: TextOverflow.ellipsis,
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
                    ),
                
                  
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
       secondaryActions: <Widget>[
   
    IconSlideAction(
      caption: 'Edit',
      color: Colors.grey,
      icon: Icons.edit,
     onTap: (){
         Navigator.push( context, FadeRoute(page: EditShippingCost(productsData)));

        // _deleteOrder();

     }
    )
       ]

    )


             ],
            ),
          ),
        ),
          ),

 
  
      ),
    );
  }

  //      List<Widget> _showProductsList() {

  //   List<Widget> list = [];
  //  // int checkIndex=0;
  //   for (var d in productsData) {
  //    // print(d.category);
  //      // checkIndex = checkIndex+1;

  //     //print("seeen") ;
  //     //print(d.seen);
  //    //   print(d.status);

  //     list.add(
  //       VariationValueListCard(d)
  //   
  //     );
  //   }

  //   return list;
  // }
}
