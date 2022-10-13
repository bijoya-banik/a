import 'dart:convert';

import 'package:bahrain_admin/KeyValueModel.dart';
import 'package:bahrain_admin/Model/AddProductSearchModel/AddProductSearchModel.dart';
import 'package:bahrain_admin/Model/AllVariationModel/AllVariationModel.dart';
import 'package:bahrain_admin/Screen/ShowProductVariationList/ShowProductVariationList.dart';
import 'package:bahrain_admin/Screen/ShowShippingCostList/showShippingCostList.dart';
import 'package:bahrain_admin/Screen/ShowVariableCombitionList/ShowVariableCombitionList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class EditShippingCost extends StatefulWidget {

  final data;
  EditShippingCost(this.data);

  @override
  _EditShippingCostState createState() => _EditShippingCostState();
}

class _EditShippingCostState extends State<EditShippingCost> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController editCostNameController = new TextEditingController();
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

    editCostNameController.text = widget.data.price==null?"":widget.data.price.toString();
    // categoryName = categoryName==null?"":widget.data.name;
    // categoryId = categoryId==null?"":widget.data.id.toString();

   // _showVariation();

    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit Shipping Cost"),
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
                      child: Text("Shipping Cost",
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
                        controller: editCostNameController,
                        keyboardType: TextInputType.number,
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
                ],
              ),

              
              GestureDetector(
                onTap: () {
                  _isLoading ? null : _editCost();
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
    );
  }

  void _editCost() async {
    if (editCostNameController.text.isEmpty) {
      return _showMsg("Shipping Cost is empty");
    } //else if (loginPasswordController.text.isEmpty) {
    //   return _showMsg("Password is empty");
    // }

    setState(() {
      _isLoading = true;
    });

    //categoryId = categoryId.toString();

    var data = {
      'id': '${widget.data.id}',
      'price':editCostNameController.text
    };

    //print(data);

    var res = await CallApi().postData(data, '/app/updateShipingPrice');
    var body = json.decode(res.body);
   // print(body);

   // if (body['success'] == true) {
      // print("sucvsss");
      //   SharedPreferences localStorage = await SharedPreferences.getInstance();
      //   localStorage.setString('token', body['token']);
      // //  localStorage.setString('pass', loginPasswordController.text);
      //   localStorage.setString('user', json.encode(body['user']));
   if (res.statusCode == 200) {
       Navigator.push( context, FadeRoute(page: ShowShippingCostList()));

    } else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isLoading = false;
    });
  }

}
