import 'dart:convert';

import 'package:bahrain_admin/KeyValueModel.dart';
import 'package:bahrain_admin/Model/AddProductSearchModel/AddProductSearchModel.dart';
import 'package:bahrain_admin/Model/AllVariationModel/AllVariationModel.dart';
import 'package:bahrain_admin/Screen/DriverOrderList/DriverOrderList.dart';
import 'package:bahrain_admin/Screen/EditOrder/EditOrder.dart';
import 'package:bahrain_admin/Screen/OrderPage/OrderList.dart';
import 'package:bahrain_admin/Screen/ShowProductVariationList/ShowProductVariationList.dart';
import 'package:bahrain_admin/Screen/ShowVariableCombitionList/ShowVariableCombitionList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class AddNote extends StatefulWidget {

  final data;
  AddNote(this.data);

 

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController noteController = new TextEditingController();
  bool _isLoading = false;
  var searchData;
  bool _isSearch = false;
  bool _product = false;
  bool _isData=false;
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


      noteController.text = widget.data.note==null?"":widget.data.note;

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Note"),
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
                      child: Text("Note",
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
                        controller: noteController,
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
                ],
              ),

              
              GestureDetector(
                onTap: () {
                  _isData ? null : _addNote();
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
                          child: Text(_isData?"Saving...":"Save",
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

  void _addNote() async {
    if (noteController.text.isEmpty) {
      return _showMsg("Note is empty");
    } 
     

    setState(() {
      _isData = true;
    });

    //categoryId = categoryId.toString();

    var data = {
      'id': '${widget.data.id}',
      'note':noteController.text
    };

    //print(data);

    var res = await CallApi().postData(data, '/app/updateOrderNote');
    var body = json.decode(res.body);
   // print(body);

    if (res.statusCode == 200) {

           if (visitDriver == "myOrder") {
        // Toast.show("Driver Changed Successfully", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
         Navigator.push( context, FadeRoute(page:OrderList()));
      } else if (visitDriver == "driverOrder") {
           driverId = "driver";
        // driverId = "change";
        //  Navigator.of(context).pop();
        //  Toast.show("Driver Changed Successfully", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
       Navigator.push( context, FadeRoute(page: DriverOrderList(widget.data)));
     
      }

      null;
     

    //  Navigator.push(
    // context,
    // MaterialPageRoute(builder: (context) => OrderList()));
  

    } else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isData = false;
    });
  }


}
