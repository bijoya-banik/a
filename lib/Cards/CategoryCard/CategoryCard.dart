
import 'package:bahrain_admin/Screen/SubCategoryList/SubCategoryList.dart';
import 'package:flutter/material.dart';

class CategoryListCard extends StatefulWidget {
  var data;
  CategoryListCard(this.data);

  @override
  _CategoryListCardState createState() => _CategoryListCardState();
}

class _CategoryListCardState extends State<CategoryListCard> {
  bool open = true;    
  var orderedItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { 
         Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>SubCategoryList(widget.data)));
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
              )
            ],
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
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 2 +
                                        10,
                                    child: Text(
                                      widget.data.name==null?"---": widget.data.name,
                                      overflow: TextOverflow.ellipsis,
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
    );
  }
}
