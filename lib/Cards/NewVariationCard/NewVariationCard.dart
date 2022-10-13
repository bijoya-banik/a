import 'dart:convert';

import 'package:bahrain_admin/Screen/EditNewVariation/EditNewVariation.dart';
import 'package:bahrain_admin/Screen/EditProductVariation/EditProductVariation.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductDetails.dart';
import 'package:bahrain_admin/Screen/ShowNewVariationList/ShowNewVariationList.dart';
import 'package:bahrain_admin/Screen/ShowProductVariationList/ShowProductVariationList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewVariationCard extends StatefulWidget {
  var data;
  NewVariationCard(this.data);

  @override
  _NewVariationCardState createState() => _NewVariationCardState();
}

class _NewVariationCardState extends State<NewVariationCard> {
  bool open = true;
  var orderedItem;

  bool _isLoading = false;
  //final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    return Slidable(

      actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
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
          padding: EdgeInsets.only(right: 12, left: 20, top: 15, bottom: 15),
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
                    Expanded(
                      child: Container(
                        //color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5),
                                     width: MediaQuery.of(context).size.width,
                                    //     10,
                                    child: Text(
                                      widget.data.name == null
                                          ? ""
                                          : widget.data.name,
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
                              ],
                            ),
                           
                          ],
                        ),
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //        Navigator.push(
                    //         context, SlideLeftRoute(page: EditNewVariation(widget.data)));
                        
                    //   },
                    //   icon: Icon(
                    //     Icons.edit,
                    //     color: appColor,
                    //   ),
                    // ),
                    // IconButton(
                    //   onPressed: () {

                    //     _deleteOrder();
                    //   },
                    //   icon: Icon(
                    //     Icons.delete,
                    //     color: appColor,
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
         secondaryActions: <Widget>[
   
    IconSlideAction(
      caption: 'Edit',
      color: Colors.grey[350],
      icon: Icons.edit,
     onTap: (){
           Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>EditNewVariation(widget.data)));
     }
     ),
       IconSlideAction(
      caption: 'Remove',
      color: Colors.red[100],
      icon: Icons.delete,
     onTap: (){
        _deleteOrder();
       
     }
     )
     ]
    );
  }

  
  void _deleteOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Are you sure want to delete this variation?",
            // textAlign: TextAlign.,
            style: TextStyle(
                color: Color(0xFF000000),
                fontFamily: "grapheinpro-black",
                fontSize: 14,
                fontWeight: FontWeight.w500),
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
                              borderRadius: new BorderRadius.circular(20.0)),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          color: appColor.withOpacity(0.9),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        width: 110,
                        height: 45,
                        margin: EdgeInsets.only(top: 25, bottom: 15),
                        child: OutlineButton(
                            // color: Colors.greenAccent[400],
                            child: new Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _deleteOrders();
                            },
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0))))
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }

    void _deleteOrders() async{

   // print(widget.data.id);

 var data = {
      'id': widget.data.id,
    };

    var res = await CallApi().postData(data, '/app/deletevariation');
    var body = json.decode(res.body);

    if (body['success'] == true) {

     
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => ShowNewVariationList()));
    }



  }

}
