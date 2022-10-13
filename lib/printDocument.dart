import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';


double userDiscount=0.00;
double couponDiscount=0.00;
 var textFont;
  var timeFormat =
        formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, '  ', HH, ':', nn]);
Future<pdf.Document> generatePdf(PdfPageFormat format,List list,var taxStatus,var taxAmount) async {

  final font = await rootBundle.load("assets/font/Roboto_Condensed/RobotoCondensed-Regular.ttf");
  textFont = pdf.Font.ttf(font);
  final Document doc = Document();

 
       final PdfImage profileImage = kIsWeb
          ? null
          : await pdfImageFromImageProvider(
              pdf: doc.document,
              image: AssetImage('assets/images/bahrain.jpg'),
              onError: (dynamic exception, StackTrace stackTrace) {
                print('Unable to download image');
              });

              for( var d in list){

             // if(d['data'].customer.discount!=null){
                 userDiscount = (taxAmount/100)*double.parse(d['data'].subTotal);
                  //print(userDiscount);

                  //  couponDiscount =double.parse(d['data'].subTotal)- ((double.parse(taxAmount))/100)*double.parse(d['data'].subTotal);
                  // print(couponDiscount.toString());
             // }
//               if(d['data'].used_vaoucher!=null){
//  couponDiscount = (d['data'].used_vaoucher.voucher.discount/100)*double.parse(d['data'].subTotal);
//               }

              
               
                  doc.addPage(pdf.Page(
    pageFormat: PdfPageFormat
              .roll80,
    build: (pdf.Context context) => 
    pdf.Container(
             // color: PdfColors.grey,
              margin: pdf.EdgeInsets.only(top:15,bottom: 15),
              child: pdf.Column(
                //mainAxisAlignment: pdf.MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <pdf.Widget>[
                    pdf.Container(
                      height: 60,
                      width: 60,
                      child: pdf.Image(profileImage,
                          height: 3, width: 3, fit: pdf.BoxFit.contain),
                    ),
                    pdf.SizedBox(height:7),
                    pdf.Text("Thank you for Order",style: pdf.TextStyle(font:textFont)),
                    pdf.Text("website: www.bahrainUnique.com",style: pdf.TextStyle(font:textFont),textAlign: pdf.TextAlign.center),
                    pdf.Text(timeFormat.toString(),style: pdf.TextStyle(font:textFont)),
                                        pdf.SizedBox(height: 4),
                    pdf.Text(d['data'].id==null?"":"Order No: "+d['data'].id.toString(),style: pdf.TextStyle(font:textFont)),
                     pdf.SizedBox(height: 10),
                    pdf.Text(
                        "................................................................................",style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)),
                    pdf.SizedBox(height: 5),
                  
                  pdf.Container(
                    alignment:  pdf.Alignment.topLeft, 
                    child:  pdf.Column(
                      crossAxisAlignment:  pdf.CrossAxisAlignment.start,
                      children: < pdf.Widget>[
                       // pdf.Text("Customer Details",style:  pdf.TextStyle(fontWeight: pdf.FontWeight.bold),),
                         pdf.SizedBox(height: 5),
                         pdf.Text(
                         d['data'].firstName==null && d['data'].lastName==null? "":
                         d['data'].firstName+" "+d['data'].lastName,
                         style:  pdf.TextStyle(font:textFont,fontWeight: pdf.FontWeight.bold),),
                         pdf.SizedBox(height: 2),
                         pdf.Text(d['data'].mobile1==null?"":"Mobile: "+d['data'].mobile1,style: pdf.TextStyle(font:textFont)),
                         pdf.SizedBox(height: 2),
                         pdf.Text(d['data'].house==null?"":"House: "+d['data'].house,style: pdf.TextStyle(font:textFont)),
                         pdf.SizedBox(height: 2),
                         pdf.Text(d['data'].road==null?"":"Road: "+d['data'].road,style: pdf.TextStyle(font:textFont)),
                         pdf.SizedBox(height: 2),
                         pdf.Text(d['data'].block==null?"":"Block: "+d['data'].block,style: pdf.TextStyle(font:textFont)),
                         pdf.SizedBox(height: 2),
                         pdf.Text(d['data'].area==null?"":"Area: "+d['data'].area,style: pdf.TextStyle(font:textFont)),
                      ],
                    ),
                  ),

                  //////add to invoice////
                   
                    pdf.SizedBox(height: 18),
                    pdf.Text(taxStatus==1?"Tax Invoice":"Invoice",style: pdf.TextStyle(font:textFont,fontSize:13,fontWeight:pdf.FontWeight.bold)),
                    pdf.SizedBox(height: 8), pdf.Text(
                        "................................................................................",style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)),
                    pdf.SizedBox(height: 10),
                    pdf.Row(
          mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
          children: <pdf.Widget>[
            pdf.Container(
               alignment: pdf.Alignment.topLeft,
                width: 30 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 2.5,
                child: pdf.Text("Description",style: pdf.TextStyle(font:textFont))),
            pdf.Expanded(
              child: pdf.Container(
                alignment: pdf.Alignment.center,
                  width: 8 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 5,
                  child: pdf.Text("Qty",style: pdf.TextStyle(font:textFont))),
            ),
            pdf.Expanded(
              child: pdf.Container(
                 alignment: pdf.Alignment.topLeft,
                  width: 10 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 4,
                  child: pdf.Text("Price",style: pdf.TextStyle(font:textFont))),
            ),
            pdf.Expanded(
              child: pdf.Container(
               
                  alignment: pdf.Alignment.bottomRight,
                  margin: pdf.EdgeInsets.only(right:6),
                  width: 10 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 4,
                  child: pdf.Text("Total",style: pdf.TextStyle(font:textFont))),
            ),
          ]),
           pdf.SizedBox(height: 8),
           pdf.Text(
                        "................................................................................",style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.bold,font:textFont)),
                    pdf.SizedBox(height: 10),
                    pdf.Column(

                    children: _showItemList(d['data'])),
                      // productDetailsPrint(),
                      // productDetailsPrint(),
                      // productDetailsPrint(),
                      // productDetailsPrint(),
                      // productDetailsPrint(),
                      
                      
                    
                    pdf.SizedBox(height: 10),
                    pdf.Container(
                        // margin: pdf.EdgeInsets.only(right:30),
                        child: pdf.Column(children: <pdf.Widget>[
                      pdf.Container(
                          alignment: pdf.Alignment.bottomRight,
                          child: pdf.Text(
                              "................................................................................",style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.bold,font:textFont))),
                      pdf.SizedBox(height: 5),
                      pdf.Row(
                        mainAxisAlignment: pdf.MainAxisAlignment.end,
                        children: <pdf.Widget>[
                         taxStatus==0? pdf.Text("Total:  ",
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)):pdf.Text("Total (vat Included):  ",
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)),
                          pdf.Text(d['data'].subTotal==null?"0.00":d['data'].subTotal.toString(),
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)),
                        ],
                      ),
                      pdf.SizedBox(height: 3),
                      d['data'].used_vaoucher==null?pdf.Container():pdf.Row(
                        mainAxisAlignment: pdf.MainAxisAlignment.end,
                        children: <pdf.Widget>[
                          pdf.Text(d['data'].used_vaoucher.voucher.code==null?"Coupon :  ":"Coupon ("+d['data'].used_vaoucher.voucher.code+" : "+d['data'].used_vaoucher.voucher.discount.toString()+"%) : ",
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)),
                          pdf.Text(d['data'].used_vaoucher.voucher.discount==null?"":(couponDiscount = (d['data'].used_vaoucher.voucher.discount/100)*double.parse(d['data'].subTotal)).toStringAsFixed(2),
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)),
                        ],
                      ),
                      pdf.SizedBox(height: 3),
                    //d['data'].customer==null?pdf.Container(): 
                     pdf.Row(
                        mainAxisAlignment: pdf.MainAxisAlignment.end,
                        children: <pdf.Widget>[
                          pdf.Text(d['data'].discount==null?"":"User Discount (${d['data'].discount.toString()}%) : ",
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)),
                          pdf.Text(d['data'].discount==null?"":(((d['data'].discount)/100)*double.parse(d['data'].subTotal)).toStringAsFixed(2),
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)),
                        ],
                      ),
                      pdf.SizedBox(height: 3),
                      pdf.Row(
                        mainAxisAlignment: pdf.MainAxisAlignment.end,
                        children: <pdf.Widget>[
                          pdf.Text(d['data'].shippingPrice==null?"":"Shipping Cost :  ",
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)),
                          pdf.Text(d['data'].shippingPrice==null?"0.00":d['data'].shippingPrice.toString(),
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont)),
                        ],
                      ),
                       pdf.SizedBox(height: 8),
                      pdf.Container(
                          alignment: pdf.Alignment.bottomRight,
                          child: pdf.Text(
                              "...................................",style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.normal,font:textFont))),
                      pdf.SizedBox(height: 3),
                      pdf.Row(
                        mainAxisAlignment: pdf.MainAxisAlignment.end,
                        children: <pdf.Widget>[
                          pdf.Text("Net Total :  ",
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.bold,font:textFont)),
                          pdf.Text(d['data'].grandTotal==null?"BHD 0.00":"BHD "+d['data'].grandTotal.toString(),
                              style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.bold,font:textFont)),
                        ],
                      ),
                    ])),
                    pdf.SizedBox(height: 15),
                     pdf.Text(
                        "................................................................................",style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.bold,font:textFont)),
                    pdf.SizedBox(height: 8),

                   taxStatus==0?pdf.Container(): pdf.Column( children: <pdf.Widget>[


                       pdf.Text("Vat Details",style: pdf.TextStyle(fontSize:13,font:textFont,fontWeight:pdf.FontWeight.bold)),
                     pdf.SizedBox(height: 8),
                     pdf.Text(
                        "................................................................................",style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.bold,font:textFont)),
                   
                  
                         pdf.SizedBox(height: 15),
                    pdf.Row(
                        mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pdf.CrossAxisAlignment.start,
                        children: <pdf.Widget>[
                          pdf.Expanded(
                            child: pdf.Container(
                                alignment: pdf.Alignment.center,
                                width: 25 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 3,
                                child: pdf.Column(
                                  children: <pdf.Widget>[
                                    pdf.Text(
                                      "Vat %",
                                      style: pdf.TextStyle(
                                          fontWeight: pdf.FontWeight.bold,font:textFont),
                                    ),
                                   
                                  ],
                                )),
                          ),
                          pdf.Expanded(
                            child: pdf.Container(
                                alignment: pdf.Alignment.center,
                                width:25 * PdfPageFormat.mm,// MediaQuery.of(context).size.width / 3,
                                child: pdf.Column(
                                  children: <pdf.Widget>[
                                    pdf.Text(
                                      "Excluded Vat ",
                                       textAlign:pdf.TextAlign.center,
                                      style: pdf.TextStyle(
                                       
                                          fontWeight: pdf.FontWeight.bold,font:textFont),
                                    ),
                                    
                                  ],
                                )),
                          ),
                          pdf.Expanded(
                            child: pdf.Container(
                                alignment: pdf.Alignment.center,
                                width: 25 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 3,
                                child: pdf.Column(
                                  children: <pdf.Widget>[
                                    pdf.Text(
                                      "Total Vat",
                                      style: pdf.TextStyle(
                                          fontWeight: pdf.FontWeight.bold,font:textFont),
                                    ),
                                   
                                    
                                  ],
                                )),
                          ),
                        ]),

                          pdf.Row(
                        mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pdf.CrossAxisAlignment.start,
                        children: <pdf.Widget>[
                          pdf.Expanded(
                            child: pdf.Container(
                                alignment: pdf.Alignment.center,
                                width: 25 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 3,
                                child: pdf.Column(
                                  children: <pdf.Widget>[
                                  
                                    pdf.Padding(
                                      padding:
                                          const pdf.EdgeInsets.only(top: 8.0),
                                      child: pdf.Text(
                                        taxAmount.toString() +" %",
                                        style: pdf.TextStyle(
                                            fontWeight: pdf.FontWeight.normal,font:textFont),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          pdf.Expanded(
                            child: pdf.Container(
                                alignment: pdf.Alignment.center,
                                width:25 * PdfPageFormat.mm,// MediaQuery.of(context).size.width / 3,
                                child: pdf.Column(
                                  children: <pdf.Widget>[
                                 
                                    pdf.Padding(
                                      padding:
                                          const pdf.EdgeInsets.only(top: 8.0),
                                      child: pdf.Text(
                                        (double.parse(d['data'].subTotal)-((taxAmount/100)*double.parse(d['data'].subTotal))).toStringAsFixed(2),
                                        style: pdf.TextStyle(
                                            fontWeight: pdf.FontWeight.normal,font:textFont),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          pdf.Expanded(
                            child: pdf.Container(
                                alignment: pdf.Alignment.center,
                                width: 25 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 3,
                                child: pdf.Column(
                                  children: <pdf.Widget>[
                                  
                                    pdf.Padding(
                                      padding:
                                          const pdf.EdgeInsets.only(top: 8.0),
                                      child: pdf.Text(
                                        ((taxAmount/100)*double.parse(d['data'].subTotal)).toStringAsFixed(2),
                                        style: pdf.TextStyle(
                                            fontWeight: pdf.FontWeight.normal,font:textFont),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ]),
                         pdf.SizedBox(height: 8),

                    
                    pdf.Text(
                        "................................................................................",style: pdf.TextStyle(
                                  fontWeight: pdf.FontWeight.bold,font:textFont)),
                    pdf.SizedBox(height: 12),
                    ]),


                          pdf.Container(
                    alignment:  pdf.Alignment.topCenter,
                    child:  pdf.Text(d['data'].note==null?"":"*Note: "+d['data'].note,
                    style: pdf.TextStyle(font:textFont),
                    textAlign: pdf.TextAlign.center),
                    ),
                       pdf.SizedBox(height: 12),
                   
                    pdf.Container(
                    alignment:  pdf.Alignment.topCenter,
                    child:  pdf.Text("Thanks for shopping with us",
                    style: pdf.TextStyle(font:textFont),
                    textAlign: pdf.TextAlign.center),
                    ),
                     
                     pdf.SizedBox(height: 7),
                      pdf.Container(
                    alignment:  pdf.Alignment.topCenter,
                    child: 
                    pdf.Text("Kindly follow us on instagram@bahrain_unique",
                     style: pdf.TextStyle(font:textFont),
                    textAlign: pdf.TextAlign.center),)
                  ]),
            )
   
  ));
              }


  
  return doc;
}

 List<pdf.Widget> _showItemList(var d) {
    List<pdf.Widget> itemList = [];
    // int checkIndex=0;
    for (var i in d.details) {

      itemList.add(
        productDetailsPrint(i)
      );

    }

    return itemList;
    }

  pdf.Container productDetailsPrint(var d) {
    return pdf.Container(
      margin: pdf.EdgeInsets.only(top: 15),
      child: pdf.Row(
          mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
          children: <pdf.Widget>[
          pdf.Column(
          mainAxisAlignment: pdf.MainAxisAlignment.start,
          children: <pdf.Widget>[
        pdf.Container(
               alignment: pdf.Alignment.topLeft,
                width: 30 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 2.5,
                child: pdf.Text(d.product==null?"":d.product.name==null?"":d.product.name,style: pdf.TextStyle(font:textFont))),
        pdf.Container(
               alignment: pdf.Alignment.topLeft,
                width: 30 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 2.5,
                child: pdf.Text(d.variation==null?"":
                d.variation.combination==null?"":
                d.variation.combination,style: pdf.TextStyle(font:textFont))),
          ]
          ),pdf.Expanded(
              child: pdf.Container(
                alignment: pdf.Alignment.center,
                  width: 8 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 5,
                  child: pdf.Text(d.quantity==null?"":d.quantity.toString(),style: pdf.TextStyle(font:textFont))),
            ),
            pdf.Expanded(
              child: pdf.Container(
                 alignment: pdf.Alignment.topLeft,
                  width: 10 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 4,
                  child: pdf.Text(d.price==null?"":d.price,style: pdf.TextStyle(font:textFont))),
            ),
            pdf.Expanded(
              child: pdf.Container(
               
                  alignment: pdf.Alignment.bottomRight,
                  width: 10 * PdfPageFormat.mm,//MediaQuery.of(context).size.width / 4,
                  child: pdf.Text(d.totalPrice==null?"":d.totalPrice,style: pdf.TextStyle(font:textFont))),
            ),
          ]),
    );
  }

