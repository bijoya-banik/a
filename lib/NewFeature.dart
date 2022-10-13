
import 'package:bahrain_admin/Screen/ProductPage/ProductDetails.dart';
import 'package:flutter/material.dart';

class ChangeProductType{


  static  String NewProductType='Make/Remove New Product';
  static  String FeaturedType="Make/Remove Feature Product";// = 'Make this product Featured';
 
  static  List<String> choices = <String>[
    NewProductType,
    FeaturedType
   
  ];
}