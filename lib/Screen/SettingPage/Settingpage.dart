
import 'dart:convert';

import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

bool pinValueSwitch = false;
bool _isLoading = true;
bool _isData = false;
bool _isStatus = false;

var taxStatus;
var taxAmount;
var id;
TextEditingController taxController = new TextEditingController();

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
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
@override
  void initState() {
   _showTax();
    super.initState();
  }
  void onPINValueChanged(bool value) {
    setState(() {
      pinValueSwitch = value;
    //  if (pinValueSwitch == true) {
        _turnOff();
    //  }
     // else
    });
  }

var body;
    //////////////// get  products start ///////////////

  // Future _getLocalBestProductsData(key) async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var localbestProductsData = localStorage.getString(key);
  //   if (localbestProductsData != null) {
  //     body = json.decode(localbestProductsData);
  //     _bestProductsState();
  //   }
  // }

  // void _bestProductsState() {
  //  // var products = ShowProductModel.fromJson(body);
  //   if (!mounted) return;
  //   setState(() {
  //     taxData = products.product;
  //     _isLoading = false;
  //   });

   // print(productsData);
//  }

  Future<void> _showTax() async {
  //  var key = 'tax-list';
  //  await _getLocalBestProductsData(key);

    var res = await CallApi().getData('/app/getAllTax');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
        setState(() {
      taxStatus = body['alltax'][0]['isOn'];
      taxAmount = body['alltax'][0]['tax'];
      id = body['alltax'][0]['id'];
      taxController.text = taxAmount.toString();
      _isLoading = false;
    });

    if(taxStatus==1){
    setState(() {
        pinValueSwitch = true;

    });
    }

    print(taxAmount);
     // _bestProductsState();

      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString(key, json.encode(body));
    }
  }

  //////////////// get  products end ///////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
          backgroundColor: appColor,
          title: Text("Tax"),

           leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                    Navigator.of(context).pop();
                //  Navigator.push(context, SlideLeftRoute(page: ()));
                },
              );
            },
          ),

          
        ),

        body: SafeArea(child: SingleChildScrollView(child:Column(
          children: <Widget>[
            Container( 
              padding: EdgeInsets.only(left:20, right:20,top:20),
               child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              "Turn on to add tax",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black, fontSize: 20),
                            )),
                            Switch(
                      onChanged: onPINValueChanged,
                      value: pinValueSwitch,
                      activeColor: Colors.white,
                      activeTrackColor: Color(0XFF1A3D7A),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    ),
              ],
            ),),
          _isLoading?  Container(
              margin: EdgeInsets.only(top: 20),
            child: Text(
                    "Please wait to load data...",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: appColor, fontSize: 13)),
          ): !pinValueSwitch?Container():
          Column(
            children: <Widget>[

                Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 10, bottom: 8),
                child: Text(
                  "Tax",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: appColor, fontSize: 13))),
           Container(
                margin: EdgeInsets.only(left: 8, top: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.grey[100],
                    border: Border.all(width: 0.2, color: Colors.grey)),
                child: TextField(
                  cursorColor: Colors.grey,
                  controller: taxController,
                  keyboardType: TextInputType.number,
                  // textCapitalization: TextCapitalization.words,
                  // autofocus: true,
                  style: TextStyle(color: Colors.grey[600]),
                  decoration: InputDecoration(
                    hintText: "",
                    // labelText: label,
                    // labelStyle: TextStyle(color: appColor),
                    contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                    border: InputBorder.none,
                  ),
                )),
          ],
        )),
                 GestureDetector(
                          onTap: () {
                            _isLoading ? null : saveTax();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 25, right: 15, bottom: 20, top: 40),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: appColor.withOpacity(0.9),
                                border:
                                    Border.all(width: 0.2, color: Colors.grey)),
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
                                    child: Text(_isData ? "Saving..." : "Save",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17)))
                              ],
                            ),
                          ),
                        ),
            ]
          )
          
        
          ],
        ))),
      
    );
  }


    void saveTax() async {
    if (taxController.text.isEmpty) {
      return _showMsg("Tax is empty");
    } //else if (loginPasswordController.text.isEmpty) {
    //   return _showMsg("Password is empty");
    // }

    setState(() {
      _isData = true;
    });

    //categoryId = categoryId.toString();

    var data = {
      
      "id": id,
      "tax": taxController.text,
      "isOn": true
    };

    //print(data);

    var res = await CallApi().postData(data, '/app/updateTax');
    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      _showMsg("Edited Successfully");
  //  if (body['success'] == true) {
      // print("sucvsss");
      //   SharedPreferences localStorage = await SharedPreferences.getInstance();
      //   localStorage.setString('token', body['token']);
      // //  localStorage.setString('pass', loginPasswordController.text);
      //   localStorage.setString('user', json.encode(body['user']));

      // Navigator.push(
      //                   context, SlideLeftRoute(page: ShowNewVariationList()));

    } else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isData = false;
    });
  }

      void _turnOff() async {
    if (taxController.text.isEmpty) {
      return _showMsg("Tax is empty");
    } //else if (loginPasswordController.text.isEmpty) {
    //   return _showMsg("Password is empty");
    // }

    setState(() {
      _isStatus = true;
    });

    //categoryId = categoryId.toString();

    var data = {
      
      "id": id,
      "tax": taxController.text,
      "isOn": pinValueSwitch?true:false
    };

    //print(data);

    var res = await CallApi().postData(data, '/app/updateTax');
    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
     pinValueSwitch? _showMsg("Tax turned on"):_showMsg("Tax turned off");
 

    } else {
      _showMsg("Something is wrong! Try Again");
    }

    setState(() {
      _isStatus = false;
    });
  }
}