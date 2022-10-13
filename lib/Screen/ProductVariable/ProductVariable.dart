import 'dart:convert';

import 'package:bahrain_admin/KeyValueModel.dart';
import 'package:bahrain_admin/Screen/AddOrder/AddOrders.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class 
ProductVariablePage extends StatefulWidget {
  final data;

  ProductVariablePage(this.data);

  @override
  _ProductVariablePageState createState() => _ProductVariablePageState();
}

class _ProductVariablePageState extends State<ProductVariablePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    //Scaffold.of(context).showSnackBar(snackBar);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  TextEditingController quantityController = new TextEditingController();
  List allList = [];
  String comb="";
 int _current = 0, active = 0;
  List imgList = [];
  double discount= 0;
  double price=0;

  String variableName = "Select Type";
  var variableId = "";
  // var subuserId;
  // var subcustomerId;
  var variableData;
  VariableValueModel variableModel;
  List<VariableValueModel> variableList = <VariableValueModel>[];

  @override
  void initState() {
    // print(widget.data.stock);
   discount= 0;
   price=0;
    quantityController.text = "1";

    if(widget.data.photo!=null){
 
  for (var d in widget.data.photo) {
      imgList.add(d.link);
      // print(url + d.link);
    }
}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text("Select Product Type"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              ////////  image start////////////
           imgList.length == 0?
                           Container(
                              height: 300,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0)),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 0.2, color: Colors.grey)),
                                child: Image.asset(
                                  'assets/images/placeholder-image.png',
                                  //    height: 300,
                                  //  width:  MediaQuery.of(context).size.width,
                                  fit: BoxFit.contain,
                                ),
                              )):imgList.length == 1?
                          Container(
                          height: 300, 
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                color: Colors.white,
                                border:
                                    Border.all(width: 0.2, color: Colors.grey)),
                                  child: Image.network(
                          imgList[0],
                          height: 300,
                          width:  MediaQuery.of(context).size.width,
                          fit: BoxFit.contain,
                        ),
         
                          ))
                          : Stack(
                              children: <Widget>[
                                Container(
                                    //height: 300,
                                    //   width:  MediaQuery.of(context).size.width,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      width:
                                          MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 0.2,
                                              color: Colors.grey)),
                                      child: CarouselSlider(
                                        //aspectRatio: 2.0,
                                        //height: 400.0,
                                        viewportFraction: 1.0,
                                        initialPage: 0,
                                        enlargeCenterPage: false,
                                        autoPlay: false,
                                        reverse: false,
                                        enableInfiniteScroll: false,
                                        autoPlayInterval:
                                            Duration(seconds: 2),
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 2000),
                                        pauseAutoPlayOnTouch:
                                            Duration(seconds: 10),
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        items: imgList.map((imgUrl) {
                                          return Builder(
                                            builder:
                                                (BuildContext context) {
                                              return Container(
                                                // width:
                                                //     MediaQuery.of(context)
                                                //         .size
                                                //         .width,
                                                // margin:
                                                //     EdgeInsets.symmetric(
                                                //         horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                child: GestureDetector(
                                                  child: Image.network(
                                                    imgUrl,
                                                    fit: BoxFit.contain,
                                                    height: 300,
                                                    width: MediaQuery.of(
                                                            context)
                                                        .size
                                                        .width,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        color: Colors.black,
                                        child: Text(
                                          "${_current + 1}/${imgList.length}",
                                          style: TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),



              ///////////////  image end ///////
             
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _showProductsVariableList()),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 25, top: 20, bottom: 8),
                  child: Text("Quantity:",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: appColor, fontSize: 18))),
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  margin: EdgeInsets.only(left: 30, top: 0, right: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.grey[100],
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  child: TextField(
                    cursorColor: Colors.grey,
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    // autofocus: true,
                    style: TextStyle(color: Colors.grey[600]),
                    decoration: InputDecoration(
                      hintText: "Type Here",
                      // labelText: label,
                      // labelStyle: TextStyle(color: appColor),
                      contentPadding:
                          EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                      border: InputBorder.none,
                    ),
                    // autofocus: true,
                  )),

                   Container(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {

             // print(widget.data.product_vc[index].stock);
              _storeData();
            },
            child: Container(
              margin:
                  EdgeInsets.only(left: 25, right: 15, bottom: 20, top: 25),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: appColor.withOpacity(0.9),
                  border: Border.all(width: 0.2, color: Colors.grey)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_shopping_cart,
                    size: 20,
                    color: Colors.white,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text("Add to cart",
                          style:
                              TextStyle(color: Colors.white, fontSize: 17)))
                ],
              ),
            ),
          ),
        ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _showProductsVariableList() {
    List<Widget> list = [];
    // int checkIndex=0;
    //int i=0;
    // d.add({
    //     "isSelected": false,
    //   });
    for (var d in widget.data.product_variable) {
  

      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 25, top: 0, bottom: 8),
                    child: Text(d.name==null?"":d.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: appColor, fontSize: 18))),

                      Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 15, top: 0, bottom: 8),
                    child: Text(d.name==null?"":'(Click to select variation)',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: appColor, fontSize: 14))),
              ],
            ),
           d.name==null?Container(): Container(
              child: Divider(
                color: appColor,
                height: 2,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 25, top: 5, bottom: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _showProductsVariableValue(d)),
            )
          ],
        ),
      );
    }

    return list;
  }

  List<Widget> _showProductsVariableValue(var listData) {
    List<Widget> list = [];

    var name;

    for (var d in listData.values) {
      // print(d);
      // int i = 0;

      list.add(GestureDetector(
        onTap: () {
          //  print(listData.isSelected);

          //   print(d);
          // comb = d.value;
          if (d.isSelected == null) {
            // make all d.selected false first // then make d.isSelected true
            for (var d in listData.values) {
              setState(() {
                d.isSelected = null;
              });
            }
            setState(() {
              d.isSelected = true;
              name = d.value;
            });

            int index = 1;
            for (int i = 0; i < allList.length; i++) {
              if (allList[i]['listName'] == listData.name) {
                allList.removeAt(i);
              }
            }

            if (index == 1) {
              allList.add({'listName': listData.name, 'name': name});
            }

            index = 0;

        
          } else {
            setState(() {
              d.isSelected = null;
                 for (int i = 0; i < allList.length; i++) {
              if (allList[i]['listName'] == listData.name) {
                allList.removeAt(i);
              }
            }
             // allList = [];
            });
          }
             print(allList);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.only(bottom: 12, top: 10),
                child: Text(d.value)),

            // IconButton(

            //   icon:
            Container(
              padding: EdgeInsets.only(bottom: 12, top: 6, right: 30),
              child: Icon(
                Icons.check_circle,
                color: d.isSelected == null ? Colors.transparent : appColor,
                //  ),

                // onPressed: (){

                //   setState(() {
                //     is$type = true;
                //   });

                // },
              ),
            )
          ],
        ),
      ));

      // i++;
    }

    return list;
  }

  void _storeData() async {
    List com = [];

    for (var d in widget.data.product_vc) {
      com.add( d.combination
        // { 
        // 'comId': d.id,
        // 'combi': d.combination}
        );
    }

    comb = '';
    for (int i = 0; i < allList.length; i++) {
      comb += allList[i]['name'];

      if (i != allList.length - 1) {
        comb += '-';
      }

       print(comb);
    }
    int index;
    
    if(quantityController.text.isEmpty){
       _showMsg("Quantity is empty");
    }
    print("quantityController.text");
    print(quantityController.text);


      if(quantityController.text=="0"){
        _showMsg("Quantity can not be 0");
      }
      
      else{
  
    if(widget.data.product_variable.length>0 ){
                print("comb");
          print(widget.data.product_variable.length);
      // for (int i = 0; i < widget.data.product_vc.length; i++) {
      //         if (widget.data.product_vc[i]['combination'] == comb) {
               
      //         }
      //       }

        if (com.contains(comb)) {
            
      for (int i = 0; i < com.length; i++) {
        if (com[i] == comb) {

         // var combiId="";
          index = i;

          //print(widget.data.product_vc[index].stock);
        
          int stock = widget.data.product_vc[index].stock;
          var combiId = widget.data.product_vc[index].id;
          // int price = int.parse(widget.data.price);
         // print(combiId);
            int quantity = int.parse(quantityController.text);

            if (quantity==0) {
            _showMsg("Quantity is empty");
          }
   
          if (quantity > widget.data.product_vc[index].stock) {
            _showMsg("No available stock for this combination");
          } 

          
            int countItem=0;
             
            for(int i=0;i<productData.length;i++){
            //  print(countItem);
            //     print(productData[i]['id']);
            //     print(widget.data.id);
            //    //  int stock = widget.data.stock;
              if(productData[i]['id'].toString()==widget.data.id.toString()){

             
                    countItem = 1;
              }
            }


            if(countItem==0){


              
          if (quantity > widget.data.product_vc[index].stock) {
            _showMsg("No available stock for this combination");
          } 

          else{


                // print("discount11111");
                // print(widget.data.discount);
                discount = widget.data.discount/100;
                //  print("discount22222");
                //   print(discount);
                //    print("priceeeeeee");
                price = discount*widget.data.price;
                price = widget.data.price-price;
                // print(price);

      ////  productData.add({
                 productData.add({
              // 'cart': {
                'id':'${widget.data.id}',
                'name': '${widget.data.name}',
                'price': price,
                'quantity': quantity,
                'total': price * quantity,
                'stock': stock,
                'combinationId':combiId,
                'combination':comb,
                'img':widget.data.photo.length==0?"":widget.data.photo[0].link,
                //'userId':0
              //}
            });

              //  print('productData');
                print(productData);
            SharedPreferences localStorage =
                await SharedPreferences.getInstance();
            localStorage.setString('cartList', json.encode(productData));

             Navigator.push( context, FadeRoute(page: AddOrder()));
           // });
             }
            }
             else{

            _showMsg("This Product is already added to cart");

             }
          
            //  SharedPreferences localStorage =
            //     await SharedPreferences.getInstance();
            // localStorage.setString('cartList', json.encode(productData));

            // Navigator.push(context, SlideLeftRoute(page: AddOrder()));
          // else {
          //   productData.add({
          //     // 'cart': {
          //       'id':'${widget.data.id}',
          //       'name': '${widget.data.name} ' + comb,
          //       'price': '${widget.data.price}',
          //       'quantity': quantity,
          //       'total': widget.data.price * quantity,
          //       'stock': stock,
          //       'combinationId':combiId,
          //       'img':widget.data.photo.length==0?"":widget.data.photo[0].link
          //     //}
          //   });

          //      print('productData');
          //      print(productData);
          //   SharedPreferences localStorage =
          //       await SharedPreferences.getInstance();
          //   localStorage.setString('cartList', json.encode(productData));

          //   Navigator.push(context, SlideLeftRoute(page: AddOrder()));
          // }
        }
      }
    } else {
     
      _showMsg("No available combination! Select combination sequentially");
    }

    }

    else{

  int quantity = int.parse(quantityController.text);
   

        int stock = widget.data.stock;


          // if (quantity==0 ) {
          //   _showMsg("Quantity is empty");
          // }
          // if (quantityController.text=="0") {
          //   _showMsg("Quantity is empty");
          // }

        if (quantity > stock) {
            _showMsg("No available stock");
          }

          else{

            print(quantity);

            int countItem=0;
             
            for(int i=0;i<productData.length;i++){
            //  print(countItem);
            //     print(productData[i]['id']);
            //     print(widget.data.id);
            //    //  int stock = widget.data.stock;
              if(productData[i]['id'].toString()==widget.data.id.toString()){

             
                    countItem = 1;
              }
            }


            if(countItem==0){

            //  print("discount11111");
            //     print(widget.data.discount);
                discount = widget.data.discount/100;
                //  print("discount22222");
                //   print(discount);
                //    print("priceeeeeee");
                price = discount*widget.data.price;
                price = widget.data.price-price;
                // print(price);
        productData.add({
              // 'cart': {
                'id':'${widget.data.id}',
                'name': '${widget.data.name}',
                'price': price,
                'quantity': quantity,
                'total': price * quantity,
                'stock': stock,
                'combinationId':0,
                'combination':'No combination',
                'img':widget.data.photo.length==0?"":widget.data.photo[0].link,
               // 'userId':0

              //}
            });

             print("productData");

             print(productData);
            SharedPreferences localStorage =
                await SharedPreferences.getInstance();
            localStorage.setString('cartList', json.encode(productData));

             Navigator.push( context, FadeRoute(page: AddOrder()));
             }


             else{

             _showMsg("This Product is already added to cart");

             }

             
          //  allList=[];
          }

       

    }
      }
 
    
 
  }

  
}
