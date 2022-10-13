import 'package:bahrain_admin/Screen/AddNote/AddNote.dart';
import 'package:bahrain_admin/Screen/AssignDriver/AssignDriver.dart';
import 'package:bahrain_admin/Screen/ChangeStatus/ChangeStatus.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:bahrain_admin/redux/thunk.dart';
import 'package:flutter/material.dart';

class EditOrder extends StatefulWidget {

   final data;
 // final driver;
  EditOrder(this.data);
  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {

  @override
  void initState() {
   print( widget.data.status);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text("Edit Order"),
         backgroundColor: appColor,
      ),

      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 12),
                        child: ListView(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                            Navigator.push( context, FadeRoute(page: ChangeStatus(widget.data)));
                              },
                              child: Container(
                                child: ListTile(
                                  title: Container(
                                      child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.settings_backup_restore,
                                        color: Colors.black54,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        child: Text(
                                          'Change Status',
                                          style: TextStyle(
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  )),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                              ),
                            ),
                            Divider(height: 0,color: Colors.grey,),
                          widget.data.status=="Under processing" ||  widget.data.status=="Delivered"?
                          Container():
                            GestureDetector(
                              onTap: () {
                          Navigator.push( context, FadeRoute(page: AssignDriver(widget.data)));
                              },
                              child: ListTile(
                                title: Container(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.drive_eta,
                                      color: Colors.black54,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 8),
                                      child: Text(
                                         widget.data.status=="Under processing"?"":'Assign Driver',
                                        style:
                                            TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                )),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),

                                Divider(height: 0,color: Colors.grey,),

                            GestureDetector(
                              onTap: () {
                            Navigator.push( context, FadeRoute(page: AddNote(widget.data)));
                              },
                              child: Container(
                                child: ListTile(
                                  title: Container(
                                      child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.note_add,
                                        color: Colors.black54,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        child: Text(
                                          'Edit Note',
                                          style: TextStyle(
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  )),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                              ),
                            ),
                          


                            ////////////   pre-order list start  ////////////////////
                          
                           //  Divider(height: 0,color: Colors.grey,),
                          
                           




                      
                          
                          ],
                        ),
                      )
        ,
      ),
      
    );
  }
}