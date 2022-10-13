import 'dart:convert';

import 'package:bahrain_admin/KeyValueModel.dart';
import 'package:bahrain_admin/Model/ShowProductModel/ShowProductModel.dart';
import 'package:bahrain_admin/Model/ShowProductWithVariationModel/ShowProductWithVariationModel.dart';
import 'package:bahrain_admin/Screen/ProductVariable/ProductVariable.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';


class ProductOrder extends StatefulWidget {
  @override
  _ProductOrderState createState() => _ProductOrderState();
}

class _ProductOrderState extends State<ProductOrder> {

   TextEditingController productNameController = new TextEditingController();
   bool _isLoading=false;
   var searchData;
   bool _isSearch=false;

   Future<void> _search(String value) async{


      setState(() {
          _isLoading = true;
         
        });

   var urlStr =
        '/app/product?search=$value';
  
var res = await CallApi().getData(urlStr);
 var   body = json.decode(res.body);

    if (res.statusCode == 200) {
          var products = ShowProductWithVariationModel.fromJson(body);
        if (!mounted) return;
        setState(() {
          searchData = products.product;
          _isLoading = false;
          _isSearch = true;
        });
        //   print(value);
        //  print(searchData);
       
    }

   
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add to Order"),
      backgroundColor: appColor,),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

             Column(
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 15, bottom: 8,top: 20,right: 15),
                child: Text("Product Name",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: appColor, fontSize: 13))),
            Container(
                margin: EdgeInsets.only(left: 15, top: 0,right:15),
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
                    contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 15.0),
                    border: InputBorder.none,
                    
                  ),
                  autofocus: true,
                  onChanged: (val) {


                              if (!mounted) return;
                          //    setState(() {
                                 
                              // store.dispatch(SearchTextClick(true));
                                _search(val);
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
                    style: TextStyle(color: Colors.black, fontSize: 13))):
                    _isSearch?Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _showProductsList()
          ):Container(),

            ],
          ),
        ),
      ),
      
    );
  }

       List<Widget> _showProductsList() {

    List<Widget> list = [];
    var type;
    List allLists=[];
  //List<VariableValueModel> allLists = <VariableValueModel>[];
   var add;

   // int checkIndex=0;
    for (var d in searchData) {


           

      list.add(
       GestureDetector(
         onTap: (){

           //allList=[];

              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProductVariablePage(d)));


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
                  Container(
                      // alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 12.0),
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
                        //color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 5),
                                child: Text(
                                  d.name==null?"---": d.name,
                                //  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "sourcesanspro",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Icon(
                        Icons.chevron_right
                          )
                          
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
       )
      );
    }

    return list;
  }
}