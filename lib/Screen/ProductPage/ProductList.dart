import 'dart:convert';

import 'package:bahrain_admin/Cards/ProductListCard/ProductListCard.dart';
import 'package:bahrain_admin/Model/ShowProductModel/ShowProductModel.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/Screen/EditProduct/EditProducts.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductDetails.dart';
import 'package:bahrain_admin/Screen/ProductTypeView/ProductTypeView.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {


var body;
List productsData=[];
List storeProductList=[];
bool  _isLoading = true;
bool _isSearch = false;

TextEditingController searchController = new TextEditingController();


  @override
  void initState() {

    visitDetails = "product";
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
    var products = ShowProductModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      productsData = products.product;
      _isLoading = false;
      storeProductList = products.product;
    });

    print(storeProductList);
  }

  Future<void> _showProducts() async {
    var key = 'products-list';
    await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/showProduct');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _bestProductsState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }    
             
    Future<void> getFilterData(value) async {

      print("storeProductList11111111111111111111");
      print(storeProductList);
      productsData=[];
      print("storeProductList");      
      print(storeProductList);
    setState(() {
      _isLoading = true;
    });
  //  Var result = _foodList.where((food) => food.name.toLowerCase().contains(userInputValue.toLowerCase())

    for(var d in storeProductList){
              
      // print(d);
       if(d.name.toLowerCase().contains(value.toLowerCase())){
           
       if (!mounted) return;
         setState(() { 
                                           
        productsData.add(d);   

        });            

       // if(productsData.length>0){
            // break;
            //   }           
      }      
    }                           
                                
                      
    setState(() {                     
      _isLoading = false;
    });
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
          title: _isSearch==false? Text("Products"):
          Container(
                  height: 50.0,
                  margin: EdgeInsets.only(right: 0, left: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white),
                  child: TextField(
                    cursorColor: Colors.grey,
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    autofocus: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: appColor,
                      ),
                      hintText: "Search",
                      
                      hintStyle: TextStyle(color: Colors.grey,),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 5.0, top: 15.0),
                     // suffixIcon: 
                      // search != ""
                      //     ? IconButton(
                      //         onPressed: () {
                      //           setState(() {
                      //             searchController.text = "";
                      //             search = "";
                      //           });
                      //         },
                      //         icon: Icon(Icons.arrow_forward),
                      //         color: Colors.grey,
                      //       )
                      //     :
                          //  Icon(
                          //     Icons.cancel,
                          //     color: Colors.transparent,
                          //   ),
                    ),
                    onChanged: (val) {
                      setState(() {
                      
                       print(val);
                        // filterList = null;
                        // search = val;
                        getFilterData(val);
                       
                      });
                    },
                  ),
                ),

           leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                 
                  ),
                onPressed: () {
                  
                   Navigator.push( context, FadeRoute(page: ProductTypeView()));
                },
              );
            },
          ),

          actions: [
            IconButton(icon: Icon(
             _isSearch?Icons.close: Icons.search,
               color: Colors.white,
              ),
             onPressed: (){

               if (!mounted) return;
                 setState(() {
                  _isSearch = !_isSearch;
                  });

                  if(_isSearch==false){
                     setState(() {
                    searchController.text="";
                    productsData = storeProductList;
                    print(storeProductList);
                     });
                    
                  }
             })
          ],

          
        ),
        body:_isLoading?Center(
            child: CircularProgressIndicator(),
          ):
           productsData.length==0? Center(
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
                                          "No Products Found",
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
              children: _showProductsList()
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
      //print(d.seen);
     //   print(d.status);

      list.add(
       Slidable(
       actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
      child: GestureDetector(
        onTap: () {
        Navigator.push( context, FadeRoute(page:ProductsDetailsPage(d)));
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


                      ///image start
                    // Container(
                    //     // alignment: Alignment.center,
                    //     margin: EdgeInsets.only(right: 12.0),
                    //     child: ClipOval(
                    //        child: 
                    //       d.photo.length!=0?  Image.network(
                    //       // 'http://10.0.2.2:8000/uploads/kV4hi8q2GxQrBcoYbKhi8UJ3kL8D0r5NhesbKrEO.png',
                    //       d.photo[0].link,
                    //         height: 42,
                    //         width: 42,
                    //         fit: BoxFit.cover,
                    //       ):
                    //       Image.asset(
                    //         'assets/images/placeholder-image.png',
                    //         height: 42,
                    //         width: 42,
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //   ),

                      ///image end
                      Expanded(
                        child: Container(
                          //color: Colors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                   Container(
                        padding: const EdgeInsets.only( bottom: 5),
                        //   margin: EdgeInsets.only(top: 15),
                        child: Text(
                          //name,
                          "Product id: ${d.id}",
                          style: TextStyle(fontSize: 12.0, color: appColor),
                        ),
                      ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      d.name==null?"---": d.name,
                                    
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "sourcesanspro",
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height:2
                                  ),

                                  Container(
                                    child: Text(
                                       d.price==null?"":  d.price.toStringAsFixed(2)+" BHD",
                                     // "\$ 45.00",
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
                              // Container(
                              //   margin: EdgeInsets.only(top: 5),
                              //   child: Text(
                              //      d.description==null?"---": d.description,
                              //     overflow: TextOverflow.ellipsis,
                              //     textDirection: TextDirection.ltr,
                              //     style: TextStyle(
                              //         color: Color(0xFF343434),
                              //         fontFamily: "sourcesanspro",
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.normal),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
          secondaryActions: <Widget>[
   
    IconSlideAction(
      caption: 'Edit', 
      color: Colors.grey[350], 
      icon: Icons.edit,
     onTap: (){
             Navigator.push( context, FadeRoute(page: EditProduct(d)));
     }
     ),
       IconSlideAction(
      caption: 'Delete',
      color: Colors.red[100],
      icon: Icons.delete,
     onTap: (){
        showItemAlert(d);
       
     }
     )
     ]

       )
   // );
     // NotificationCard(d)
      );
    }

    return list;
  }

  
     void showItemAlert(var d){

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: 
              Text(
                                "Are you sure want to delete this product?",
                               // textAlign: TextAlign.,
                                style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontFamily: "grapheinpro-black",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),

                              content:    Container(
                    height: 70,
                    width: 250,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
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
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                              )),
                          Container(
                              decoration: BoxDecoration(
                                color:appColor.withOpacity(0.9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              width: 110,
                              height: 45,
                              margin: EdgeInsets.only(top: 25, bottom: 15),
                              child: //_buttonFunction
                              OutlineButton(
                                 // color: Colors.greenAccent[400],
                                  child: new Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    
                                     Navigator.of(context).pop();
                                     _deleteItem(d);
                                  },
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)))
                                          )
                        ])),
            
        );
        //return SearchAlert(duration);
      },
    );
  }

  void _deleteItem(var d) async{

    setState(() {
      _isLoading = true;
    });

 var data = {
      'id': d.id,
    };

    var res = await CallApi().postData(data, '/app/deleteProduct');
    var body = json.decode(res.body);

    if (body['success'] == true) {

 
       productsData.remove(d);
      
    }

      setState(() {
      _isLoading = false;
    });



  }
}
