import 'package:bahrain_admin/Form/AddOrderForm/AddOrderForm.dart';
import 'package:bahrain_admin/Form/AddOrderGuestForm/AddOrderGuestForm.dart';
import 'package:bahrain_admin/Screen/OrderPage/OrderList.dart';
import 'package:bahrain_admin/Screen/OrderType/OrderType.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class AddOrderGuest extends StatefulWidget {
  @override
  _AddOrderGuestState createState() => _AddOrderGuestState();
}

class _AddOrderGuestState extends State<AddOrderGuest> {

  Future<bool> _onWillPop() async {
Navigator.push( context, FadeRoute(page: OrderType()));
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
         onWillPop: _onWillPop,
      child: Scaffold(

            appBar: AppBar(
          backgroundColor: appColor,
          title: Text("Add Order for guest"),

           leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { 
   Navigator.push( context, FadeRoute(page:OrderType()));

           },
          
        );
      },
  ),
),
          

          body: SafeArea( 
            child: AddOrderGuestForm(),
          ),
        
      ),
    );
  }
}