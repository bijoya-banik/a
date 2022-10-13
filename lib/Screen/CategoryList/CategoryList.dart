import 'dart:convert';

import 'package:bahrain_admin/Cards/CategoryCard/CategoryCard.dart';
import 'package:bahrain_admin/Cards/ProductListCard/ProductListCard.dart';
import 'package:bahrain_admin/Model/CategoryModel/CategoryModel.dart';
import 'package:bahrain_admin/Model/ShowProductModel/ShowProductModel.dart';
import 'package:bahrain_admin/Screen/AddProduct/AddProducts.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  TextEditingController categoryController = new TextEditingController();
  var body;
  var categoryData;

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
    Scaffold.of(context).showSnackBar(snackBar);
  }

    bool _isLoading = false;


  @override
  void initState() {
    _allData();
    super.initState();
  }

  Future<void> _allData() async {
    _showCategory();
  }

  ////////////// get  category start ///////////////

  Future _getLocalCategoryData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localCategoryData = localStorage.getString(key);
    if (localCategoryData != null) {
      body = json.decode(localCategoryData);
      _categoryState();
    }
  }

  void _categoryState() {
    var category = CategoryModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      categoryData = category.category;
      _isLoading = false;
    });

    // print(productsData);
  }

  Future<void> _showCategory() async {
    var key = 'category-list';
    await _getLocalCategoryData(key);

    var res = await CallApi().getData('/app/indexCategory');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _categoryState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  //////////////// get  products end ///////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text("Category"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : categoryData == null || categoryData.length==0
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
                      "No Category Found",
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
                          children: _showCategoryList()),
                    ),
                  ),
                ),
    );
  }

  List<Widget> _showCategoryList() {
    List<Widget> list = [];
    // int checkIndex=0;
    for (var d in categoryData) {
      // print(d);
      // checkIndex = checkIndex+1;

      //print("seeen") ;
      //print(d.seen);
      //   print(d.status);

      list.add(CategoryListCard(d)
          // NotificationCard(d)
          );
    }

    return list;
  }

  void _showAddDialogue() {
    showDialog(
      context: context,
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
                      margin: EdgeInsets.only(left: 5, bottom: 12),
                      child: Text("Category Name",
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 13))),

                  Container(
                      margin: EdgeInsets.only(left: 0, top: 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.grey[100],
                          border: Border.all(width: 0.2, color: Colors.grey)),
                      child: TextField(
                        cursorColor: Colors.grey,
                        controller: categoryController,
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
            ],
          ),

          actions: <Widget>[
            GestureDetector(
              onTap: (){

                _isLoading?null:_addCategory();
              },
                          child: Padding(
                padding: const EdgeInsets.only(right: 30, bottom: 10),
                child: Text(
                  _isLoading?"Saving":"Save",
                  style: TextStyle(
                      color: appColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            )
          ],
          
        );
        //return SearchAlert(duration);
      },
    );
  }


  void _addCategory() async{


    if (categoryController.text.isEmpty) {
      return _showMsg("Category name is empty");
    } 


    setState(() {
      _isLoading = true;
    });

    var data = {

      'category': categoryController.text,
     
    
    };

    print(data);


    var res = await CallApi().postData(data, '/app/storeCategory');
    print(res);
    var body = json.decode(res.body);
    print(body);


      if (body['success'] == true) {
      //   SharedPreferences localStorage = await SharedPreferences.getInstance();
      //   localStorage.setString('token', body['token']);
      // //  localStorage.setString('pass', loginPasswordController.text);
      //   localStorage.setString('user', json.encode(body['user']));


    Navigator.push( context, FadeRoute(page: CategoryList()));

     }
       else {
         _showMsg("Invalid Phone or Password");
      }
   

    setState(() {
      _isLoading = false;
    });


    
  }
}
