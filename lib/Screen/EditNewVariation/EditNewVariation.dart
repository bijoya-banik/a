import 'dart:convert';

import 'package:bahrain_admin/KeyValueModel.dart';
import 'package:bahrain_admin/Model/AddProductSearchModel/AddProductSearchModel.dart';
import 'package:bahrain_admin/Model/AllVariationModel/AllVariationModel.dart';
import 'package:bahrain_admin/Screen/ShowNewVariationList/ShowNewVariationList.dart';
import 'package:bahrain_admin/Screen/ShowProductVariationList/ShowProductVariationList.dart';
import 'package:bahrain_admin/Screen/ShowVariableCombitionList/ShowVariableCombitionList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class EditNewVariation extends StatefulWidget {

  final data;
  EditNewVariation(this.data);


  @override
  EditdNewVariationState createState() => EditdNewVariationState();
}

class EditdNewVariationState extends State<EditNewVariation> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController variationNameController = new TextEditingController();
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
   

   variationNameController.text = widget.data.name==null?"":widget.data.name;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit Variation"),
        backgroundColor: appColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(
                       left: 15,top: 20, right: 15),
            child: Column( 
              children: <Widget>[
               Container(
                   alignment: Alignment.topLeft,
                   margin: EdgeInsets.only(
                       left: 15, bottom: 8, top: 20, right: 15),
                   child: Text("Variation Name",
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
                     controller: variationNameController,
                     keyboardType: TextInputType.text,
                     // autofocus: true,
                     style: TextStyle(color: Colors.grey[600]),
                     decoration: InputDecoration(
                      // hintText: "Search Here",
                       // labelText: label,
                       // labelStyle: TextStyle(color: appColor),
                       contentPadding:
                           EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                       border: InputBorder.none,
                     ),
                     //autofocus: true,
                  
                   )),

                
                GestureDetector(
                  onTap: () {
                    _isLoading ? null : _editProductCombination();
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
                          Icons.save,
                          size: 20,
                          color: Colors.white,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(_isLoading?"Saving...":"Save",
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
      ),
    );
  }

  void _editProductCombination() async {
    if (variationNameController.text.isEmpty) {
      return _showMsg("Variation Name is empty");
    } //else if (loginPasswordController.text.isEmpty) {
    //   return _showMsg("Password is empty");
    // }

    setState(() {
      _isLoading = true;
    });

    //categoryId = categoryId.toString();

    var data = {
      
      'id': widget.data.id,
      'name':variationNameController.text
    };

    //print(data);

    var res = await CallApi().postData(data, '/app/editvariation');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      // print("sucvsss");
      //   SharedPreferences localStorage = await SharedPreferences.getInstance();
      //   localStorage.setString('token', body['token']);
      // //  localStorage.setString('pass', loginPasswordController.text);
      //   localStorage.setString('user', json.encode(body['user']));

      Navigator.push( context, FadeRoute(page: ShowNewVariationList()));

    } else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isLoading = false;
    });
  }

  // List<Widget> _showProductsList() {
  //   List<Widget> list = [];
  //   var type;
  //   List allLists = [];
  //   //List<VariableValueModel> allLists = <VariableValueModel>[];
  //   var add;

  //   // int checkIndex=0;
  //   for (var d in searchData) {
  //     list.add(GestureDetector(
  //       onTap: () {
  //         setState(() {
  //           productNameController.text = d.name;
  //           productId = d.id;
  //           _product = true;
  //         });

  //         //  Navigator.push(context, SlideLeftRoute(page: ProductVariablePage(d)));
  //       },
  //       child: _product
  //           ? Container()
  //           : Card(
  //               margin: EdgeInsets.only(left: 15, right: 15, top: 8),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: const EdgeInsets.all(12.0),
  //                     child: Container(
  //                       // width: MediaQuery.of(context).size.width,
  //                       child: Text(d.name),
  //                     ),
  //                   ),

  //                   //  Icon(

  //                   //    Icons.chevron_right
  //                   //  )
  //                 ],
  //               ),
  //             ),
  //     ));
  //   }

  //   return list;
  // }
}
