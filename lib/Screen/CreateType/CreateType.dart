
import 'package:bahrain_admin/Form/AddProductForm/AddProductForm.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/Screen/CategoryList/CategoryList.dart';
import 'package:bahrain_admin/Screen/HomePage/HomePage.dart';
import 'package:bahrain_admin/Screen/ProductPage/FeatureProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/NewProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductList.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class CreateTypeView extends StatefulWidget {
  @override
  _CreateTypeViewState createState() => _CreateTypeViewState();
}

class _CreateTypeViewState extends State<CreateTypeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

       appBar: AppBar(
        backgroundColor: appColor,
  //       leading: Builder(
  //   builder: (BuildContext context) {
  //     return IconButton(
  //       icon: const Icon(Icons.arrow_back),
  //       onPressed: () { 
  //          Navigator.push(
  //         context, new MaterialPageRoute(builder: (context) => HomePage()));
  //       },
  //     );
  //   },
  // ),
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
                                    Navigator.push( context, FadeRoute(page: AddProductform()));
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
                                            'Add Products',
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
                                 Navigator.push( context, FadeRoute(page: CategoryList()));
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
                                            'Add Category',
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


                              ////////////   pre-order list start  ////////////////////
                            
                               Divider(height: 0,
                               color: Colors.grey,),
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
                                            'Add Sub-Category',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    )),
                                    trailing: Icon(Icons.chevron_right),
                                  ),
                                )
                                ,
                              ),
                            
                             



                            
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ),
    );
  }
}