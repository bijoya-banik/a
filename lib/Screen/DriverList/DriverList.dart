import 'dart:convert';

import 'package:bahrain_admin/Cards/FeatureListCard/FeatureListCard.dart';
import 'package:bahrain_admin/Cards/ProductListCard/ProductListCard.dart';
import 'package:bahrain_admin/Model/DriverModel/DriverModel.dart';
import 'package:bahrain_admin/Model/NewFeatureModel/NewFeatureModel.dart';
import 'package:bahrain_admin/Model/ShowProductModel/ShowProductModel.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/Screen/DriverDetails/DriverDetails.dart';
import 'package:bahrain_admin/Screen/OrderType/OrderType.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductDetails.dart';
import 'package:bahrain_admin/Screen/ProductTypeView/ProductTypeView.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverList extends StatefulWidget {
  @override
  _DriverListState createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {

 final _scaffoldKey = GlobalKey<ScaffoldState>();

var body;
List driverData;
bool  _isLoading = true;


 _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
       _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
   
      _allData();
      driverId="";
    super.initState();
  }

 Future<void> _allData() async {

    _showDrivers();
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
    var drivers = DriverModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      driverData = drivers.driver;
      _isLoading = false;
    });

   // print(productsData);
  }

  Future<void> _showDrivers() async {
    var key = 'driver-list';
    await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/indexUserDriver');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _bestProductsState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  //////////////// get  products end ///////////////
 Future<bool> _onWillPop() async {
   Navigator.push( context, FadeRoute(page: OrderType()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
      child: Scaffold(
          key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: appColor,
          title: Text("Drivers"),
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
           driverData.length==0? Center(
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Container(
                          //   width: 100,
                          //   height: 110,
                          //   decoration: new BoxDecoration(
                          //       shape: BoxShape.rectangle,
                          //       image: new DecorationImage(
                          //         fit: BoxFit.fill,
                          //         image: new AssetImage('assets/images/empty_box.png'),
                          //       ))),

                                 Text(
                                          "No Driver Found",
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
              children: _showDriverList()
            ),
          ),
        ),
          ),
          

      ),
    );
  }

       List<Widget> _showDriverList() {

    List<Widget> list = [];
   // int checkIndex=0;
    for (var d in driverData) {
   
      list.add(
         GestureDetector(
     onTap: () {
      Navigator.push( context, FadeRoute(page: DriverDetails(d)));
      },
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
                Container(
                      // alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 12.0),
                      child: ClipOval(
                         child: 
                        d.profilepic!=null?  Image.network(
                          // 'http://10.0.2.2:8000/uploads/kV4hi8q2GxQrBcoYbKhi8UJ3kL8D0r5NhesbKrEO.png',
                          d.profilepic,
                            height: 42,
                            width: 42,
                            fit: BoxFit.cover,
                          ):
                        Image.asset(
                          'assets/images/camera.png',
                          height: 42,
                          width: 42,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                
                    Expanded(
                      child: Container(
                        //color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                              d.firstName==null &&  d.lastName==null?
                              Container():
                                  Container(
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
                                            text: d.firstName ==
                                                    null
                                                ? ""
                                                : '${d.firstName}'),
                                        TextSpan(
                                          text: d.lastName ==
                                                  null
                                              ? ""
                                              : ' ${d.lastName}',
                                        ),
                                      ],
                                    ),
                                  )),
                           
                          d.mobile==null && d.country_code==null?Container():  Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                 d.mobile==null || d.country_code==null ?"":d.country_code+d.mobile,
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
    )
     
      );
    }

    return list;
  }


}
