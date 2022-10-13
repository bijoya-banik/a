import 'dart:convert';

import 'package:bahrain_admin/KeyValueModel.dart';
import 'package:bahrain_admin/Model/AddProductSearchModel/AddProductSearchModel.dart';
import 'package:bahrain_admin/Model/AllVariationModel/AllVariationModel.dart';
import 'package:bahrain_admin/Model/ShowVariationModel/ShowVariationModel.dart';
import 'package:bahrain_admin/Model/ShowVariationValueModel/ShowVariationValueModel.dart';
import 'package:bahrain_admin/Screen/ShowVariationValueList/ShowVariationValueList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductVariationValue extends StatefulWidget {
  @override
  _AddProductVariationValueState createState() => _AddProductVariationValueState();
}

class _AddProductVariationValueState extends State<AddProductVariationValue> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController productNameController = new TextEditingController();
  TextEditingController valueController = new TextEditingController();
  bool _isLoading = false;
  var searchData;
  bool _isSearch = false;
  bool _product = false;
  bool _isData = false;
  bool _isDrop= false;
  var productId;
  String categoryName = "";
  var categoryId = "";
  KeyValueModel categoryModel;
  List<KeyValueModel> categoryList = <KeyValueModel>[];
  var body;
  var variationData;

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

 // @override
  // void initState() {
  //   // print(widget.data.status);

  //   //   categoryName = widget.data.status==null?"":widget.data.status;
  //   // hintText = widget.data.status==null?"":widget.data.status;
  //   //  format = DateFormat("yyyy-MM-dd").format(selectedDate);

  //  // _showVariation(59);

  //   super.initState();
  // }

  //////////////// get  products start ///////////////

  // void _bestProductsState() { 
  //   var vari = ShowVariationModel.fromJson(body);
  //   if (!mounted) return;
  //  // setState(() {
  //  //   _isLoading = true;
  //  setState(() {
  //       variationData = vari.productVariation;
  //  });

  //    // variationData = vari.productVariation;
  //    // categoryList=[];

  //     for (int i = 0; i < variationData.length; i++) {
  //       //_status.add(statusData[i].name);
  //       categoryList.add(
  //           //{
  //           // 'name' : "${store.state.categoryListsRedux[i].categoryName}",
  //           // 'id' : "${store.state.categoryListsRedux[i].id}",
  //           //  },
  //           KeyValueModel(
  //               key: "${variationData[i].name}",
  //               value: "${variationData[i].id}"));
  //     }

  //    // _isLoading = false;
  //  // });

    

  // }

  Future<void> _showVariation(var id) async {


        setState(() {
          _isDrop = true;
      });
    var res = await CallApi().getData('/app/showproductVariationValue?productId=$id');
    body = json.decode(res.body);

    if (res.statusCode == 200) {

        var vari = ShowVariationModel.fromJson(body);
    if (!mounted) return;

   setState(() {
        variationData = vari.productVariation;
      
   });

   //List list=[];
     List<KeyValueModel> list = <KeyValueModel>[];

      for (int i = 0; i < variationData.length; i++) {
      
        list.add(
          
            KeyValueModel(
                key: "${variationData[i].name}",
                value: "${variationData[i].id}"));
      }
      setState(() {
        categoryList = list;
          _isDrop = false;

      });
  
    }
  }

  //////////////// get  status end ///////////////
  Future<void> _search(String value) async {
    setState(() {
      _isLoading = true;
    });

    var urlStr = '/app/indexProduct?search=$value';

    var res = await CallApi().getData(urlStr);
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      var products = AddProductSearchModel.fromJson(body);
      if (!mounted) return;
      setState(() {
        searchData = products.product.data;
        _isLoading = false;
        _isSearch = true;
      });
    }

   // print(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Product Variation Value"),
        backgroundColor: appColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(
                          left: 15, bottom: 8, top: 20, right: 15),
                      child: Text("Product Name",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 15))),
                  Container(
                      margin: EdgeInsets.only(left: 15, top: 0, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.grey[100],
                          border: Border.all(width: 0.2, color: Colors.grey)),
                      child: TextField(
                        cursorColor: Colors.grey,
                        controller: productNameController,
                        keyboardType: TextInputType.text,
                        // autofocus: true,
                        style: TextStyle(color: Colors.grey[600]),
                        decoration: InputDecoration(
                          hintText: "Search Here",
                          // labelText: label,
                          // labelStyle: TextStyle(color: appColor),
                          contentPadding:
                              EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                          border: InputBorder.none,
                        ),
                        //autofocus: true,
                        onChanged: (val) {
                          if (!mounted) return;
                          //    setState(() {

                          // store.dispatch(SearchTextClick(true));
                          _search(val);
                            if(productNameController.text==""){

                              setState(() {
                                   _product = false;
                                   categoryList = [];
                                 //  _showVariation()
                                   

                              });

                          }
                          
                          //  });
                        },
                      )),
                ],
              ),
              _isLoading?  Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20, bottom: 8,top: 20,right: 15),
                child: Text("Please wait...",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 13))): _isSearch
                  ? _product? Container():Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _showProductsList())
                  : Container(),
             _isDrop? Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(bottom: 8, top: 30),
                      child: Text("Please wait to select variation...",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 15))): 
                           Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15, bottom: 8, top: 20),
                      child: Text("Variation Name",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 15))),
                  Container(
                      //color: Colors.yellow,
                      margin:
                          EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.grey[100],
                            border:
                                Border.all(width: 0.2, color: Colors.grey)),
                        //  borderRadius: BorderRadius.circular(20),
                        // color: Colors.white),
                        // alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:
                  MainAxisAlignment.start,
                          children: <Widget>[
                        Expanded(
                  child: Container(
                      // width:
                      //     MediaQuery.of(context).size.width /
                      //             2 +
                      //         200,
                      //  color: Colors.black,
                      margin: EdgeInsets.only(
                      left: 16, top: 10, bottom: 10),
                      child: Text(
                        categoryName,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54),
                      )),
                        ),
                        Expanded(
                  child: Container(
                    //  width: 10,
                    height: 42,
             
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        //  height: 10,
                       // alignedDropdown: true,
                        child: DropdownButton<KeyValueModel>(
                      items: categoryList
                          .map((KeyValueModel user) {
                        return new DropdownMenuItem<
                        KeyValueModel>(
                          value: user,
                          child: new Text(
                        user.key,
                        style: new TextStyle(
                        color: Colors.black),
                          ),
                        );
                      }).toList(),
                      
                      onChanged: (KeyValueModel value) {
                        setState(() {
                          categoryModel = value;
                          categoryName =
                          categoryModel.key;
                          categoryId =
                          categoryModel.value;

                        });

                      },
                      //  hint: Text('Select Key'),
                        ),
                      ),
                    ),
                  ),
                        ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
 Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(
                          left: 15, bottom: 8, top: 20, right: 15),
                      child: Text("Variation Value",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 15))),
                  Container(
                      margin: EdgeInsets.only(left: 15, top: 0, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.grey[100],
                          border: Border.all(width: 0.2, color: Colors.grey)),
                      child: TextField(
                        cursorColor: Colors.grey,
                        controller: valueController,
                        keyboardType: TextInputType.text,
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
                    
                      )),
                ],
              ),





              GestureDetector(
                onTap: () {
                 _isDrop?null: _isData ? null : _storeProductVariationValue();
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 25, right: 15, bottom: 20, top: 50),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: _isDrop?Colors.grey:appColor.withOpacity(0.9),
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.create_new_folder,
                        size: 20,
                        color: Colors.white,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(_isData?"Creating...":"Create",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _storeProductVariationValue() async {


      if (productNameController.text.isEmpty) {
      return _showMsg("Product Name is empty");
    } else if (categoryName == "") {
      return _showMsg("Variation Name is empty");
    }
    else if (valueController.text.isEmpty) {
      return _showMsg("Variation Value is empty");
    }
    var products;
 // Future _getLocalBestProductsData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localbestProductsData = localStorage.getString("products-variations-value-list");
    if (localbestProductsData != null) {
     var body = json.decode(localbestProductsData);
         products = ShowVariationValueModel.fromJson(body);
   // if (!mounted) return;
    // setState(() {
    // var  productsData = products.productVariationValue;
    // });
    }

    var check ="";

    for(var d in products.productVariationValue){

      //  print(d.productId.toString() + d.variationId.toString() +d.value.toString() );
      //  print(productId.toString() +categoryId.toString()+ valueController.text);
      if(d.productId.toString() == productId.toString() && d.variationId.toString() ==categoryId.toString()  && d.value.toString() ==valueController.text){
          // print("object");
          // return _showMsg("already added");
          check="added";
      //      print(d.productId);
      //  print(productId);
          break;
         
      }
      else{
        check="noAdded";
      }
    }

    //  print("check");
    // print(check);

    if(check=="added"){
      return _showMsg("Already added same value for this product");
    }
    else if(check=="noAdded"){

      
    setState(() {
      _isData = true;
    });

    var data = {
      'variationId': categoryId, 
      'productId': productId,
      'value':valueController.text
      };

//    print(data);

    var res = await CallApi().postData(data, '/app/storeproductVariationValue');

    var body = json.decode(res.body);
    //print("body");

    // print(body);

  //  if (body['success'] == true) {

       if (res.statusCode == 200) {
        //  _showMsg("Added");
   
      _showSuccess();
    } else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isData = false;
    });

    }
  
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  ////////////   Address  start ///////////

                  ///////////// Address   ////////////

                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 18, top: 5, bottom: 8),
                      child: Text("Stock of this variation will be 0, Please update product stock",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 15))),
                ],
              ),
            ],
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
                        width: 80,
                        height: 45,
                        margin: EdgeInsets.only(
                          top: 25,
                          bottom: 15,
                        ),
                        child: OutlineButton(
                          child: new Text(
                            "Ok",
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                             Navigator.push( context, FadeRoute(page: ShowVariationValueList()));
                          },
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                        )),
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }

  List<Widget> _showProductsList() {
    List<Widget> list = [];
    var type;
    List allLists = [];
    //List<VariableValueModel> allLists = <VariableValueModel>[];
    var add;

    // int checkIndex=0;
    for (var d in searchData) {

      if(productNameController.text != d.name){
        _product = false;
      }
      list.add(GestureDetector(
        onTap: () {
          setState(() {
            productNameController.text = d.name;
            productId = d.id;
            _product = true;
              
          });
 _showVariation(productId);
          //  print(productId);
        

          //  Navigator.push(context, SlideLeftRoute(page: ProductVariablePage(d)));
        },
        child: _product
            ? Container()
            : Card(
                margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                     Container(
                      // alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 12.0),
                      padding: EdgeInsets.only(left: 5, right: 5, top: 6, bottom: 6),
                      child: ClipOval(
                         child: 
                        d.photo.length!=0?  Image.network(
                        // 'http://10.0.2.2:8000/uploads/kV4hi8q2GxQrBcoYbKhi8UJ3kL8D0r5NhesbKrEO.png',
                        d.photo[0].link,
                          height: 42,
                          width: 42,
                          fit: BoxFit.cover,
                        ):
                        Image.asset(
                          'assets/images/placeholder-image.png',
                          height: 42,
                          width: 42,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          child: Text(d.name),
                        ),
                      ),
                    ),

                    //  Icon(

                    //    Icons.chevron_right
                    //  )
                  ],
                ),
              ),
      ));
    }

    return list;
  }
}
