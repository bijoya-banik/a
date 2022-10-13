import 'package:bahrain_admin/Form/AddOrderForm/AddOrderForm.dart';
import 'package:bahrain_admin/Screen/OrderType/OrderType.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  Future<bool> _onWillPop() async {
    Navigator.push(context, FadeRoute(page: OrderType()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          title: Text("Add Order"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(context, FadeRoute(page: OrderType()));
                },
              );
            },
          ),
        ),
        body: SafeArea(
          child: AddOrderForm(),
        ),
      ),
    );
  }
}
