import 'dart:convert';

import 'package:bahrain_admin/Screen/EditProductVariation/EditProductVariation.dart';
import 'package:bahrain_admin/Screen/EditVariationCombination/EditVariationCombination.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductDetails.dart';
import 'package:bahrain_admin/Screen/ShowProductVariationList/ShowProductVariationList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VariableCombinationCard extends StatefulWidget {
  var data;
  VariableCombinationCard(this.data);

  @override
  _VariableCombinationCardState createState() => _VariableCombinationCardState();
}

class _VariableCombinationCardState extends State<VariableCombinationCard> {
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
                                    // width: MediaQuery.of(context).size.width / 2 +
                                    //     10,
                                    child: Text(
                                      widget.data.product.name == null
                                          ? ""
                                          : widget.data.product.name,
                                     // overflow: TextOverflow.ellipsis,
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
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                widget.data.combination == null
                                    ? ""
                                    : widget.data.combination,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: Color(0xFF343434),
                                    fontFamily: "sourcesanspro",
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                               Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                widget.data.stock == null
                                    ? ""
                                    : "Stock: "'${widget.data.stock}',
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
                    // IconButton(
                    //   onPressed: () {
                    //        Navigator.push(
                    //         context, SlideLeftRoute(page: EditVariationCombination(widget.data)));
                        
                    //   },
                    //   icon: Icon(
                    //     Icons.edit,
                    //     color: appColor,
                    //   ),
                    // ),
                    
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
    MaterialPageRoute(builder: (context) =>EditVariationCombination(widget.data)));


     })]
    );
  }



}
