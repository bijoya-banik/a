import 'package:bahrain_admin/Model/ShowOrderModel/ShowOrderModel.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatefulWidget {
  final data;
  final index;
  final length;
  OrderItem(this.data,this.index,this.length);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
 // bool _isLoading = true;
  var itemReview;

  @override
  void initState() {
  // print(widget.data.product.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: Colors.red,
        borderRadius: BorderRadius.circular(15),
        // boxShadow:[
        //    BoxShadow(color:Colors.grey[300],
        //    blurRadius: 6,
        //     //offset: Offset(0.0,3.0)
        //     )

        //  ],
      ),
      // margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.only(
        left: 5,
        top: 6,
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      //color: Colors.blue,
      child: Column(
        children: <Widget>[
          Container(
            //color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[


                 Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 10.0, left: 10),
                          child: ClipOval(
                              child: widget.data.photo.length==0?
                                   Image.asset(
                                      'assets/images/placeholder-image.png',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )
                                  :
                                  // Image.asset(
                                  //   'assets/images/placeholder-image.png',
                                  //   height: 50,
                                  //   width: 50,
                                  //   fit: BoxFit.cover,
                                  // ))
                                  Image.network(
                                     widget.data.photo[0].link,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                Expanded(
                  child: Container(
                    // color: Colors.red,
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        widget.data.product==null?Container(): Container(
                          child: Text(
                           widget.data.product.name==null?"":widget.data.product.name,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "DINPro",
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                         Container(
                            margin: EdgeInsets.only(top: 4),
                            child: Text(
                              widget.data.quantity==null?"":
                              'Quantity: ${widget.data.quantity}x',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: "DINPro",
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal))),
                        Container(
                            margin: EdgeInsets.only(top: 4),
                            child: Text(
                              widget.data.variation==null?"":
                           
                               '${widget.data.variation.combination}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: "DINPro",
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal))),
                      ],
                    ),
                  ), 
                ), 
                Column(       
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        widget.data.price == null
                            ? ""
                            : '${widget.data.price} BHD',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: appColor,               
                          fontSize: 16.0,
                          decoration: TextDecoration.none,
                          fontFamily: 'MyriadPro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

         widget.index== widget.length?
          Container():
          Padding(
            padding: const EdgeInsets.only(left: 60,top: 10),
            child: Divider(
              color: Colors.grey[350],
            ),
          )
        ],
      ),
    );
  }  
}
