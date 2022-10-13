import 'package:bahrain_admin/Screen/OrderDetails/OrderDetails.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductDetails.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class OrderListCard extends StatefulWidget {
  var data;
  var list;
  var markList;
  OrderListCard(this.data, this.list, this.markList);

  @override
  _OrderListCardState createState() => _OrderListCardState();
}

class _OrderListCardState extends State<OrderListCard> {
  bool open = true;
  var orderedItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderDetails(widget.data)));
      },
      onLongPress: () {
        int index = 1;
        for (int i = 0; i < widget.list.length; i++) {
          if (widget.list[i]['id'] == widget.data.id) {
            widget.list.removeAt(i);
            widget.markList.removeAt(i);
            setState(() {
              index = 0;
              widget.data.isClick = null;
            });
          }
        }

        if (index == 1) {
          widget.list.add(
              {'id': widget.data.id, 'customerId': widget.data.customerId});
          widget.markList.add(widget.data.id);
          setState(() {
            widget.data.isClick = true;
          });
        }

        print(widget.markList);
      },
      child: Stack(
        children: <Widget>[
          Card(
            elevation: 1,
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
                  )
                ],
              ),
              padding:
                  EdgeInsets.only(right: 12, left: 12, top: 10, bottom: 10),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    widget.data.id == null
                                        ? Container()
                                        : Expanded(
                                            child: Container(
                                              child: Text(
                                                widget.data.id == null
                                                    ? "---"
                                                    : "Order Id: " +
                                                        widget.data.id
                                                            .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                    color: appColor,
                                                    fontFamily: "sourcesanspro",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                widget.data.status == null
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          widget.data.status == null
                                              ? "---"
                                              : 'Order Status is ' +
                                                  widget.data.status.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                              color: Color(0xFF343434),
                                              fontFamily: "sourcesanspro",
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                widget.data.mobile1 == null &&
                                        widget.data.mobile2 == null
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          widget.data.mobile1 == null
                                              ? 'Mobile: ' +
                                                  widget.data.mobile2.toString()
                                              : 'Mobile: ' +
                                                  widget.data.mobile1
                                                      .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                              color: Color(0xFF343434),
                                              fontFamily: "sourcesanspro",
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                widget.data.grandTotal == null
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          widget.data.grandTotal == null
                                              ? ''
                                              : "Total : " +
                                                  widget.data.grandTotal
                                                      .toString() +
                                                  " BHD",
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                              color: Color(0xFF343434),
                                              fontFamily: "sourcesanspro",
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                widget.data.date == null
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          widget.data.date == null
                                              ? ''
                                              : "Order Date : " +
                                                  widget.data.date.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                              color: Color(0xFF343434),
                                              fontFamily: "sourcesanspro",
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                widget.data.date == null
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          widget.data.status_updated_at == null
                                              ? ''
                                              : "Status Date : " +
                                                  widget.data.status_updated_at
                                                      .toString(),
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.markList.contains(widget.data.id)
              ? Container(
                  margin: EdgeInsets.all(8),
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.check_circle,
                    color: appColor,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
