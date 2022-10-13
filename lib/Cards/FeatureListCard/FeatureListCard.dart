import 'dart:convert';

import 'package:bahrain_admin/Screen/ProductPage/FeatureProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductDetails.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class FeatureListCard extends StatefulWidget {
  var data;
  FeatureListCard(this.data);

  @override
  _FeatureListCardState createState() => _FeatureListCardState();
}

class _FeatureListCardState extends State<FeatureListCard> {
  bool open = true;
  var orderedItem;
  bool _isLoading=false;



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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: () {
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>ProductsDetailsPage(widget.data)));
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
                        widget.data.photo.length!=0?  Image.network(
                          // 'http://10.0.2.2:8000/uploads/kV4hi8q2GxQrBcoYbKhi8UJ3kL8D0r5NhesbKrEO.png',
                          widget.data.photo[0].link,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              // width: MediaQuery.of(context).size.width / 2 +
                              //     10,
                              child: Text(
                                widget.data.name==null?"---": widget.data.name,
                               // overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "sourcesanspro",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                              Container(
                                   margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                     widget.data.price==null?"": '\$'+ widget.data.price.toStringAsFixed(2),
                                   // "\$ 45.00",
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        color: appColor,
                                        fontFamily: "sourcesanspro",
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                 widget.data.description==null?"---": widget.data.description,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: Color(0xFF343434),
                                    fontFamily: "sourcesanspro",
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: (){

       widget.data.isFeatured==0?showItemAlert("add","as Featured",
         OutlineButton(
                                   // color: Colors.greenAccent[400],
                                    child: new Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      
                                        
                                       Navigator.of(context).pop();
                                        _handleFeature();
                                    },
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 0.5),
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0)))):
            
              showItemAlert("remove","from Featured Products",
         OutlineButton(
                                   // color: Colors.greenAccent[400],
                                    child: new Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      
                                       Navigator.of(context).pop();
                                        _handleFeature();
                                    },
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 0.5),
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0))));

                      },
                      icon: Icon(Icons.edit,
                      color: appColor,),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

     void showItemAlert(String function,String productType, OutlineButton _buttonFunction){

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: 
              Text(
                                "Are you sure want to $function this product $productType?",
                               // textAlign: TextAlign.,
                                style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontFamily: "grapheinpro-black",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),

                              content:    Container(
                    height: 70,
                    width: 250,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              width: 110,
                              height: 45,
                              margin: EdgeInsets.only(
                                top: 25,
                                bottom: 15,
                              ),
                              child: OutlineButton(
                                child: new Text(
                                  "No",
                                  style: TextStyle(color: Colors.black),
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                borderSide:
                                    BorderSide(color: Colors.black, width: 0.5),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                              )),
                          Container(
                              decoration: BoxDecoration(
                                color:appColor.withOpacity(0.9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              width: 110,
                              height: 45,
                              margin: EdgeInsets.only(top: 25, bottom: 15),
                              child: _buttonFunction
                             
                                          )
                        ])),
            
        );
        //return SearchAlert(duration);
      },
    );
  }

      void _handleFeature() async{

 setState(() {
      _isLoading = true;
    });

    var data = {

      'id':'${widget.data.id}',
      'isFeatured':widget.data.isFeatured==0?1:0  
    };


    var res = await CallApi().postData(data, '/app/editProductNew');
    var body = json.decode(res.body);
   // print(body);


      if (body['success'] == true) {
     
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FeatureProductList()));

      }
       else {
         _showMsg("Something is wrong!! Try Again");
      }
   

    setState(() {
      _isLoading = false;
    });

    }
}
