import 'dart:convert';

import 'package:bahrain_admin/KeyValueModel.dart';
import 'package:bahrain_admin/Model/AddProductSearchModel/AddProductSearchModel.dart';
import 'package:bahrain_admin/Model/AllVariationModel/AllVariationModel.dart';
import 'package:bahrain_admin/Model/ShowVariationModel/ShowVariationModel.dart';
import 'package:bahrain_admin/Screen/ShowProductVariationList/ShowProductVariationList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProductVariation extends StatefulWidget {

  final data;
  EditProductVariation(this.data);

  @override
  _EditProductVariationState createState() => _EditProductVariationState();
}

class _EditProductVariationState extends State<EditProductVariation> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController productNameController = new TextEditingController();
  bool _isLoading = false;
  var searchData;
  bool _isSearch = false;
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

    productNameController.text = widget.data.product.name==null?"":widget.data.product.name;
    categoryName = categoryName==null?"":widget.data.name;
    categoryId = categoryId==null?"":widget.data.id.toString();

    _showVariation();

    super.initState();
  }

  //////////////// get  products start ///////////////

  void _bestProductsState() {
    var vari = AllVariationModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      _isLoading = true;

      variationData = vari.allVariation;

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

      _isLoading = false;
    });

    // print(_status);
  }

  Future<void> _showVariation() async {
    //  var key = 'status-list';
    // await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/indexvariation');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _bestProductsState();

      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString(key, json.encode(body));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit Product Variation"),
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
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 15, top: 12, bottom: 12),
                      margin: EdgeInsets.only(left: 15, top: 0, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.grey[400],
                          border: Border.all(width: 0.2, color: Colors.grey)),
                      child: 
                      Text(widget.data.product.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black, fontSize: 13))),
                      
                ],
              ),
              // _isSearch
              //     ? Column(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: _showProductsList())
              //     : Container(),
              Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15, bottom: 8, top: 15),
                      child: Text("Variation",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 15))),
                  Container(
                    //color: Colors.yellow,
                    margin:
                        EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 6),
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
                                            left: 16, top: 12, bottom: 10),
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
                                          alignedDropdown: true,
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
                  _isLoading ? null : _editProductVariation();
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 25, right: 15, bottom: 20, top: 50),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: appColor.withOpacity(0.9),
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
                          child: Text(_isLoading?"Saving...": "Save",
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

  void _editProductVariation() async {
    if (categoryName=="") {
      return _showMsg("Variation is empty");
    } //else if (loginPasswordController.text.isEmpty) {
    //   return _showMsg("Password is empty");
    // }

       var products;
 // Future _getLocalBestProductsData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localbestProductsData = localStorage.getString("products-variations-list");
    if (localbestProductsData != null) {
     var body = json.decode(localbestProductsData);
         products = ShowVariationModel.fromJson(body);
   // if (!mounted) return;
    // setState(() {
    // var  productsData = products.productVariationValue;
    // });
    }

    var check ="";

    for(var d in products.productVariation){

      //  print(d.productId.toString() + d.variationId.toString() +d.value.toString() );
      //  print(productId.toString() +categoryId.toString()+ valueController.text);
      if(d.productId.toString() == widget.data.product.id.toString() && categoryName.toString() == d.name.toString()){
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
      return _showMsg("Already added same variation for this product");
    }
    else if(check=="noAdded"){

    setState(() {
      _isLoading = true;
    });

    //categoryId = categoryId.toString();

    var data = {
      'id': '${widget.data.id}',
      'productId': '${widget.data.product.id}',
      'name': categoryName
    };

   // print(data);

    var res = await CallApi().postData(data, '/app/editproductVariation');
    var body = json.decode(res.body);
   // print(body);

    if (body['success'] == true) {
      // print("sucvsss");
      //   SharedPreferences localStorage = await SharedPreferences.getInstance();
      //   localStorage.setString('token', body['token']);
      // //  localStorage.setString('pass', loginPasswordController.text);
      //   localStorage.setString('user', json.encode(body['user']));

       Navigator.push( context, FadeRoute(page: ShowProductVariationList()));

    } else {
      _showMsg("Something is wrong! Try Again");
    }
    

    setState(() {
      _isLoading = false;
    });
    }
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

          //  Navigator.push(context, SlideLeftRoute(page: ProductVariablePage(d)));
        },
        child: _product
            ? Container()
            : Card(
                margin: EdgeInsets.only(left: 15, right: 15, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        // width: MediaQuery.of(context).size.width,
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
