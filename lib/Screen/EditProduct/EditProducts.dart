import 'dart:convert';

import 'package:bahrain_admin/Form/AddProductForm/AddProductForm.dart';
import 'package:bahrain_admin/Form/EditProductForm/EditProductForm.dart';
import 'package:bahrain_admin/Model/ShowProductModel/ShowProductModel.dart';
import 'package:bahrain_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProduct extends StatefulWidget {

  final data;
  EditProduct(this.data);
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {


var productsData;
var body;
//bool _userEmpty = true;


@override
  void initState() {
 // _getProducts();
    super.initState();
  }
  // void _getProducts() async{
  
  //   }

  
  // Future _getLocalBestProductsData(key) async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var localbestProductsData = localStorage.getString(key);
  //   if (localbestProductsData != null) {
  //     body = json.decode(localbestProductsData);
  //     _productsState();
  //   }
  // }

  //   void _productsState() {
  //   var products = ShowProductModel.fromJson(body);
  //   if (!mounted) return;
  //   setState(() {
  //     productsData = products.product;
  //    // _isLoading = false;
  //   });

  //   print(body);

  //  // print(productsData);
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

          appBar: AppBar(
        backgroundColor: appColor,
        title: Text("Edit Product"),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            
            child: EditProductform(widget.data),
          ),
        ),
      
    );
  }
}