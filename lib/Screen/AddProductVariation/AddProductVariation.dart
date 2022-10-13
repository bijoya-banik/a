import 'dart:convert';

import 'package:bahrain_admin/KeyValueModel.dart';
import 'package:bahrain_admin/Model/AddProductSearchModel/AddProductSearchModel.dart';
import 'package:bahrain_admin/Model/AllVariationModel/AllVariationModel.dart';
import 'package:bahrain_admin/Screen/ProductTypeView/ProductTypeView.dart';
import 'package:bahrain_admin/Screen/ShowProductVariationList/ShowProductVariationList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class ProductVariationPage extends StatefulWidget {
  @override
  _ProductVariationPageState createState() => _ProductVariationPageState();
}

class _ProductVariationPageState extends State<ProductVariationPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController productNameController = new TextEditingController();
  bool _isLoading = false;
  var searchData;
  bool _isSearch = false;
  bool _isData = false;
  bool _isDrop = false;
  bool _product = false;
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

  @override
  void initState() {
    // print(widget.data.status);

    //   categoryName = widget.data.status==null?"":widget.data.status;
    // hintText = widget.data.status==null?"":widget.data.status;
    //  format = DateFormat("yyyy-MM-dd").format(selectedDate);

    _showVariation();

    super.initState();
  }

  //////////////// get  products start ///////////////

  void _bestProductsState() {
//     var vari = AllVariationModel.fromJson(body);
//     if (!mounted) return;
//     setState(() {
//       _isDrop = true;

//       variationData = vari.allVariation;
//         });

//       for (int i = 0; i < variationData.length; i++) {
//         //_status.add(statusData[i].name);
//         categoryList.add(
//             //{
//             // 'name' : "${store.state.categoryListsRedux[i].categoryName}",
//             // 'id' : "${store.state.categoryListsRedux[i].id}",
//             //  },
//             KeyValueModel(
//                 key: "${variationData[i].name}",
//                 value: "${variationData[i].id}"));
//       }
//  setState(() {
//       _isDrop = false;
//     });

    // print(_status);
  }

  Future<void> _showVariation() async {
    //  var key = 'status-list';
    // await _getLocalBestProductsData(key);
     setState(() {
      _isDrop = true;

   
        });

    var res = await CallApi().getData('/app/indexvariation');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
     // _bestProductsState();
       var vari = AllVariationModel.fromJson(body);
    if (!mounted) return;
   //setState(() {
        variationData = vari.allVariation;
   //});

      for (int i = 0; i < variationData.length; i++) {
        //_status.add(statusData[i].name);
        categoryList.add(
            //{
            // 'name' : "${store.state.categoryListsRedux[i].categoryName}",
            // 'id' : "${store.state.categoryListsRedux[i].id}",
            //  },
            KeyValueModel(
                key: "${variationData[i].name}",
                value: "${variationData[i].id}"));
      }


      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString(key, json.encode(body));
    }
     setState(() {
      _isDrop = false;
    });

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Product Variation"),
        backgroundColor: appColor,
      ),
      body: 
      // _isDrop?Center(
      //   child: CircularProgressIndicator(),
      // ):
      SafeArea(
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
                                    // categoryList = [];
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
                    style: TextStyle(color: Colors.black, fontSize: 13))):  _isSearch
                  ? Column(
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
                      child: Text("Variation",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 15))),
                  Container(
                    //color: Colors.yellow,
                    margin:
                        EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ////////////   category Dropdown ///////////

                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.grey[100],
                              border:
                                  Border.all(width: 0.2, color: Colors.grey)),
                          //  borderRadius: BorderRadius.circular(20),
                          // color: Colors.white),
                          // alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(

                                  //color: Colors.red,
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      //width: MediaQuery.of(context).size.width,
                                      //  color: Colors.yellow,
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          minWidth: 10,
                                          //  height: 10,
                                       //   alignedDropdown: true,
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
                                            // items: categoryNameList
                                            //     .map((data) => DropdownMenuItem<String>(
                                            //           child: Text(data.key),
                                            //          // key: data.key.,
                                            //           value: data.key,
                                            //         ))
                                            //     .toList(),
                                            onChanged: (KeyValueModel value) {
                                              setState(() {
                                                categoryModel = value;
                                                categoryName =
                                                    categoryModel.key;
                                                categoryId =
                                                    categoryModel.value;

                                                // subcategoryList = [];
                                                // subcategoryName = "";
                                              });

                                            //  print(categoryId);

                                              //_showsubCategory();
                                            },
                                            //  hint: Text('Select Key'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                _isDrop?null:  _isData ? null : _storeProductVariation();
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 25, right: 15, bottom: 20, top: 50),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color:_isDrop?Colors.grey: appColor.withOpacity(0.9),
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

  void _storeProductVariation() async {
    if (productNameController.text.isEmpty) {
      return _showMsg("Product Name is empty");
    } else if (categoryName == "") {
      return _showMsg("Variation is empty");
    }

    setState(() {
      _isData = true;
    });

    var data = {'name': categoryName, 'productId': productId};

    //print(data);

    var res = await CallApi().postData(data, '/app/storeproductVariation');

    var body = json.decode(res.body);
    //print("body");

     print(body);

  //  if (body['success'] == true) {

      if (res.statusCode == 200) {
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('token', body['token']);
      //  localStorage.setString('pass', loginPasswordController.text);
      // localStorage.setString('products', json.encode(body['product']));
Navigator.push( context, FadeRoute(page: ShowProductVariationList()));
    } 
      else if (res.statusCode == 403) {
         _showMsg(body['message']);
    } 
    else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isData = false;
    });
  }

  List<Widget> _showProductsList() {
    List<Widget> list = [];
    var type;
    List allLists = [];
    //List<VariableValueModel> allLists = <VariableValueModel>[];
    var add;

    // int checkIndex=0;
    for (var d in searchData) {
      list.add(GestureDetector(
        onTap: () {
          setState(() {
            productNameController.text = d.name;
            productId = d.id;
            _product = true;
          });
         // _showVariation();

          //  Navigator.push(context, SlideLeftRoute(page: ProductVariablePage(d)));
        },
        child: _product
            ? Container()
            : Card(
                margin: EdgeInsets.only(left: 15, right: 15, top: 4),
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
                      child: Container(
                        // width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(12.0),
                        child: Text(d.name),
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
