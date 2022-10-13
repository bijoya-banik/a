import 'dart:convert';

import 'package:bahrain_admin/Screen/EditProduct/EditProducts.dart';
import 'package:bahrain_admin/Screen/HomePage/HomePage.dart';
import 'package:bahrain_admin/Screen/ProductPage/FeatureProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/NewProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_parser/youtube_parser.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../NewFeature.dart';

class ProductsDetailsPage extends StatefulWidget {
  final data;
  ProductsDetailsPage(this.data);
  @override
  State<StatefulWidget> createState() {
    return ProductsDetailsPageState();
  }
}

class ProductsDetailsPageState extends State<ProductsDetailsPage> {
  Animation<double> animation;
  AnimationController controller;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  List imgList = [];
  int _current = 0, active = 0;
  bool _isVideo = false;
  bool _isImage = true;
  bool _isShow = false;
  bool _changeDataNew = false;
    bool _isFullVideo = false;
  YoutubePlayerController _ucontroller;
  TextEditingController _idController = TextEditingController();
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  int count = 0;

  int c1 = 0, c2 = 0, idx = 0;
  int last = 1;
  int first = 1;

  Container saleStock(
    String title,
    String subtitle,
  ) {
    return Container(
      // height: 150,

      child: Card(
        elevation: 0,
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Colors.grey[100],
            //    border: Border.all(width: 0.2, color: Colors.grey),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey[200],
            //     blurRadius: 17,
            //     //offset: Offset(0.0,3.0)
            //   ),
            // ],
          ),
          // height: 150,
          width: MediaQuery.of(context).size.width / 2 - 50,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: appColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Future<bool> _onWillPop() async {
    _controller.pause();
    visitDetails == "product"
        ?  Navigator.push( context, FadeRoute(page: ProductList()))
        : visitDetails == "feature"
            ?  Navigator.push( context, FadeRoute(page: FeatureProductList()))
            : visitDetails == "new"
                ?  Navigator.push( context, FadeRoute(page: NewProductList()))
                : null;
  }

  bool _isLoading = false;
  List vidList = [];
  double disc = 0.0;
  double disPrice = 0.0;
  double newPrice = 0.0;
  @override
  void initState() {
    //   bool _isVideo = false;
    // bool _isImage = false;
    // bool _isShow = false;
//List imgList = [];

    playVideo(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    utubePlay("https://www.youtube.com/watch?v=49l3WFQe0Q4");
    disc = widget.data.discount.toDouble();
    disc = disc / 100;
    print(disc);
    disPrice = widget.data.price.toDouble() * disc;
    print(disPrice);
    newPrice = widget.data.price.toDouble() - disPrice;
    print(newPrice);

    if (widget.data.videos == null) {
      _isVideo = false; 
    } else {
      _isVideo = true;
      for (int i = 0; i < widget.data.videos.length; i++) {
        vidList.add({
          "vLink": "${widget.data.videos[i].link}",
          "type": "${widget.data.videos[i].type}",
        });
        vidList[idx]['type'] == "upload"
            ? playVideo(vidList[idx]['vLink'])
            : utubePlay(vidList[idx]['vLink']);
        //    playVideo('${vidList[idx]}'); 
        print(vidList);
      }
    }
    
    
    if (widget.data.photo != null) {
      for (var d in widget.data.photo) {
        imgList.add(d.link);
        // print(url + d.link);
      }
    }

// if(widget.data.photo!=null){

//   for (var d in widget.data.photo) {
//       imgList.add(url+d.link);
//       // print(url + d.link);
//     }

// }
      
    super.initState();
  }

  void choiceAction(String choice) {
    if (choice == ChangeProductType.FeaturedType) {
      widget.data.isFeatured == 0
          ? showItemAlert(
              "add",
              "as Featured",
              OutlineButton(
                  // color: Colors.greenAccent[400],
                  child: new Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _handleFeature();
                  },
                  borderSide: BorderSide(color: Colors.green, width: 0.5),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0))))
          : showItemAlert(
              "remove",
              "from Featured Products",
              OutlineButton(
                  // color: Colors.greenAccent[400],
                  child: new Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _handleFeature();
                  },
                  borderSide: BorderSide(color: Colors.green, width: 0.5),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0))));
    }
    if (choice == ChangeProductType.NewProductType) {
      widget.data.isNew == 0
          ? showItemAlert(
              "add",
              "as New",
              OutlineButton(
                  // color: Colors.greenAccent[400],
                  child: new Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _handleNew();
                  },
                  borderSide: BorderSide(color: Colors.green, width: 0.5),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0))))
          : showItemAlert(
              "remove",
              "from New Products",
              OutlineButton(
                  // color: Colors.greenAccent[400],
                  child: new Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _handleNew();
                  },
                  borderSide: BorderSide(color: Colors.green, width: 0.5),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0))));
    }
  }

  void _handleFeature() async {
//  setState(() {
//       _isLoading = true;
//     });

    var data = {
      'id': '${widget.data.id}',
      'isFeatured': widget.data.isFeatured == 0 ? 1 : 0,
    };

    var res = await CallApi().postData(data, '/app/editProductNew');
    var body = json.decode(res.body);
    print(body);
    print(widget.data.isFeatured);

    if (body['success'] == true) {
      setState(() {
        widget.data.isFeatured = body['product']['isFeatured'];
      });

      body['product']['isFeatured'] == 0
          ? Toast.show("Product has removed from featured products", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM)
          : Toast.show("Product has added to featured products", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      _showMsg("Something is wrong!! Try Again");
    }

    // setState(() {
    //   _isLoading = false;
    // });
  }

  void _handleNew() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'id': '${widget.data.id}',
      'isNew': widget.data.isNew == 0 ? 1 : 0,
    };

    // print(data);
    var res = await CallApi().postData(data, '/app/editProductNew');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      setState(() {
        widget.data.isNew = body['product']['isNew'];
      });

      body['product']['isNew'] == 0
          ? Toast.show("Product has removed from new products", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM)
          : Toast.show("Product has added to new products", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      // Navigator.push(
      //                   context, SlideLeftRoute(page:ProductList()));

    } else {
      _showMsg("Something is wrong!! Try Again");
    }

    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appColor,
          title: Center(
            child: Container(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Details",
                        style: TextStyle(fontSize: 20, color: Colors.white)),

                    //       _isVideo == true && _isImage == true && _isShow == false
                    // ? vidList.length==0?Container(): GestureDetector(
                    //     onTap: () {
                    //       setState(() {
                    //         _isShow = true;
                    //       });
                    //     },
                    //     child: Container(
                    //       child: Text(
                    //         "See Video",
                    //         style: TextStyle(color: Colors.white70, fontSize: 12),
                    //       ),
                    //     ),
                    //   )
                    // : Container(),
                  ],
                ),
              ),
            ),
          ),

          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  visitDetails == "product"
                      ?  Navigator.push( context, FadeRoute(page: ProductList()))
                      : visitDetails == "feature"
                          ?  Navigator.push( context, FadeRoute(page: FeatureProductList()))
                          : visitDetails == "new"
                              ?  Navigator.push( context, FadeRoute(page: NewProductList()))
                              : null;
                },
              );
            },
          ),

          // actions: <Widget>[
          //    Container(
          //             alignment: Alignment.topRight,
          //             child: PopupMenuButton<String>(
          //               onSelected: choiceAction,
          //               icon: Icon(
          //                 Icons.more_vert,
          //                 color: Colors.white,
          //               ),
          //               itemBuilder: (BuildContext context) {
          //                 return ChangeProductType.choices.map((String choice) {
          //                   return PopupMenuItem<String>(
          //                     value: choice,
          //                     child: Text(choice),
          //                   );
          //                 }).toList();
          //               },
          //             ),
          //           ),
          // ],
        ),
        body: SingleChildScrollView(
          //  physics: BouncingScrollPhysics(),
          child: Container(
            // height: MediaQuery.of(context).size.height,
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    _buildProductImagesWidgets(),

                    /////////////    product image start ////////////////
                    // Stack(
                    //   children: <Widget>[

                    // Container(
                    //     height: 300,
                    //     child: Container(
                    //       margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    //       width: MediaQuery.of(context).size.width,
                    //       decoration: BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(15.0)),
                    //           color: Colors.white,
                    //           border:
                    //               Border.all(width: 0.2, color: Colors.grey)),
                    //             child: Image.asset(
                    //    'assets/images/ecom.jpg',
                    //     height: 300,
                    //     width:  MediaQuery.of(context).size.width,
                    //     fit: BoxFit.cover,
                    //   ),

                    //     )),

                    //  imgList.length == 0?
                    //        Container(
                    //           height: 300,
                    //           child: Container(
                    //             margin: EdgeInsets.only(
                    //                 left: 20, right: 20, top: 10),
                    //             width: MediaQuery.of(context).size.width,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.all(
                    //                     Radius.circular(15.0)),
                    //                 color: Colors.white,
                    //                 border: Border.all(
                    //                     width: 0.2, color: Colors.grey)),
                    //             child: Image.asset(
                    //               'assets/images/placeholder-image.png',
                    //               //    height: 300,
                    //               //  width:  MediaQuery.of(context).size.width,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ))
                    //            : Stack(
                    //       children: <Widget>[
                    //         Container(
                    //             //height: 300,
                    //             //   width:  MediaQuery.of(context).size.width,
                    //             child: Container(
                    //               margin: EdgeInsets.only(
                    //                   left: 20, right: 20, top: 10),
                    //               width:
                    //                   MediaQuery.of(context).size.width,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.all(
                    //                       Radius.circular(5.0)),
                    //                   color: Colors.white,
                    //                   border: Border.all(
                    //                       width: 0.2,
                    //                       color: Colors.grey)),
                    //               child: CarouselSlider(
                    //                 //aspectRatio: 2.0,
                    //                 //height: 400.0,
                    //                 viewportFraction: 1.0,
                    //                 initialPage: 0,
                    //                 enlargeCenterPage: false,
                    //                 autoPlay: false,
                    //                 reverse: false,
                    //                 enableInfiniteScroll: false,
                    //                 autoPlayInterval:
                    //                     Duration(seconds: 2),
                    //                 autoPlayAnimationDuration:
                    //                     Duration(milliseconds: 2000),
                    //                 pauseAutoPlayOnTouch:
                    //                     Duration(seconds: 10),
                    //                 scrollDirection: Axis.horizontal,
                    //                 onPageChanged: (index) {
                    //                   setState(() {
                    //                     _current = index;
                    //                   });
                    //                 },
                    //                 items: imgList.map((imgUrl) {
                    //                   return Builder(
                    //                     builder:
                    //                         (BuildContext context) {
                    //                       return Container(
                    //                         // width:
                    //                         //     MediaQuery.of(context)
                    //                         //         .size
                    //                         //         .width,
                    //                         // margin:
                    //                         //     EdgeInsets.symmetric(
                    //                         //         horizontal: 10.0),
                    //                         decoration: BoxDecoration(
                    //                           color: Colors.white,
                    //                         ),
                    //                         child: GestureDetector(
                    //                           child: Image.network(
                    //                             imgUrl,
                    //                             fit: BoxFit.cover,
                    //                             height: 300,
                    //                             width: MediaQuery.of(
                    //                                     context)
                    //                                 .size
                    //                                 .width,
                    //                           ),
                    //                         ),
                    //                       );
                    //                     },
                    //                   );
                    //                 }).toList(),
                    //               ),
                    //             )),
                    //         Container(
                    //           margin: EdgeInsets.all(20),
                    //           child: Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.end,
                    //             children: <Widget>[
                    //               Container(
                    //                 padding: EdgeInsets.all(5),
                    //                 color: Colors.black,
                    //                 child: Text(
                    //                   "${_current + 1}/${imgList.length}",
                    //                   style: TextStyle(
                    //                       color: Colors.white),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20, top: 40),
                              padding: widget.data.isNew == 0
                                  ? EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0)
                                  : EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                              color: Color(0xFFffa900),
                              child: Text(
                                widget.data.isNew == 0 ? "" : "New",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, top: 10),
                              padding: widget.data.isFeatured == 0
                                  ? EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0)
                                  : EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                              color: Colors.grey[600],
                              child: Text(
                                widget.data.isFeatured == 0 ? "" : "Featured",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, top: 10),
                              padding: widget.data.discount == 0
                                  ? EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0)
                                  : EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                              color: appColor,
                              child: Text(
                                widget.data.discount == 0
                                    ? ""
                                    : "${widget.data.discount}% off",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),

                /////////////    product image end ////////////////

                //   ],
                // ),
                Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 8, bottom: 8),
                        //   margin: EdgeInsets.only(top: 15),
                        child: Text(
                          //name,
                          "Product id: ${widget.data.id}",
                          style: TextStyle(fontSize: 16.0, color: appColor),
                        ),
                      ),
 
                _buildSeeVideoWidgets(),
                /////////////    product name start ////////////////
                widget.data.name == null
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 3),
                        padding: EdgeInsets.only(
                            top: 10, left: 12, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Container(
                          //  width: MediaQuery.of(context).size.width,
                          child: Text(
                            widget.data.name == null ? "" : widget.data.name,
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),

                /////////////    product name end ////////////////

                /////////////    product price start ////////////////
                widget.data.price == null
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 3),
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: Colors.white,
                                // border: Border.all(width: 1, color: appColor)
                              ),
                              padding: EdgeInsets.only(
                                  top: 10, right: 10, bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  // Icon(
                                  //   Icons.attach_money,
                                  //   color: appColor,
                                  //   size: 20,
                                  // ),

                                  widget.data.discount == 0
                                      ? Text(
                                          widget.data.price == null
                                              ? ""
                                              : widget.data.price
                                                      .toStringAsFixed(2) +
                                                  " BHD",
                                          style: TextStyle(
                                              color: appColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Row(
                                          children: <Widget>[
                                            Text(
                                              widget.data.price == null
                                                  ? ""
                                                  : newPrice.toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: appColor,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              widget.data.price == null
                                                  ? ""
                                                  :
                                                  //  widget.data.discount/100
                                                  widget.data.price
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            )
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                /////////////    product price end ////////////////
                /////////////    product color start ////////////////
                widget.data.color == null
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 5, left: 20, right: 20, bottom: 3),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Color",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.data.color == null
                                  ? ""
                                  : widget.data.color,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),

                /////////////    product color end ////////////////

                /////////////    product size start ////////////////
                widget.data.size == null
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 5, left: 20, right: 20, bottom: 5),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Size",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.data.size == null ? "" : widget.data.size,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),

                /////////////    product size end ////////////////
                ///
                /////////////    product description start ////////////////
                widget.data.description == null
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 5, left: 20, right: 20, bottom: 5),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Product Description",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.data.description == null
                                  ? ""
                                  : widget.data.description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                      ),

                /////////////    product description end ////////////////

                /////////////    product warrenty start ////////////////
                widget.data.warranty == null
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 5, left: 20, right: 20, bottom: 5),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Product Warrenty",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.data.warranty == null
                                  ? ""
                                  : widget.data.warranty,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black45),
                            ),
                          ],
                        ),
                      ),

                /////////////    product warrenty end ////////////////
                ///////////  sale and stock
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.data.totalSale != null
                        ? saleStock(
                            widget.data.totalSale.toString(), 'Total Sales')
                        : Container(),
                    widget.data.stock != null
                        ? saleStock(
                            widget.data.stock.toString(), 'Total Stocks')
                        : Container(),
                    // saleStock("20","Total Stocks")
                  ],
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ////////// Delete button start ////////

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.data.isFeatured == 0
                          ? showItemAlert(
                              "add",
                              "as Featured",
                              OutlineButton(
                                  // color: Colors.greenAccent[400],
                                  child: new Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _handleFeature();
                                  },
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0))))
                          : showItemAlert(
                              "remove",
                              "from Featured Products",
                              OutlineButton(
                                  // color: Colors.greenAccent[400],
                                  child: new Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _handleFeature();
                                  },
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0))));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.blueGrey.withOpacity(0.9),
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Icon(
                            //   Icons.delete,
                            // //  size: 20,
                            //   color: Colors.white,
                            // ),
                            Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                    widget.data.isFeatured == 0
                                        ? "Make Feature"
                                        : "Remove Feature",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)))
                          ],
                        )),
                  ),
                ),

                /////////// Edit button

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.data.isNew == 0
                          ? showItemAlert(
                              "add",
                              "as New",
                              OutlineButton(
                                  // color: Colors.greenAccent[400],
                                  child: new Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _handleNew();
                                  },
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0))))
                          : showItemAlert(
                              "remove",
                              "from New Products",
                              OutlineButton(
                                  // color: Colors.greenAccent[400],
                                  child: new Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _handleNew();
                                  },
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0))));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.blueGrey.withOpacity(0.9),
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Icon(
                            //   Icons.edit,

                            //   color: Colors.white,
                            // ),
                            Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                    // _changeDataNew?

                                    widget.data.isNew == 0
                                        ? "Make New"
                                        : "Remove New",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)))
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showItemAlert(
      String function, String productType, OutlineButton _buttonFunction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Are you sure want to $function this product $productType?",
            // textAlign: TextAlign.,
            style: TextStyle(
                color: Color(0xFF000000),
                fontFamily: "grapheinpro-black",
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          content: Container(
              height: 70,
              width: 250,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        width: 110,
                        height: 45,
                        margin: EdgeInsets.only(
                          top: 25,
                          bottom: 15,
                        ),
                        child: OutlineButton(
                          child: new Text(
                            "No",
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          color: appColor.withOpacity(0.9),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        width: 110,
                        height: 45,
                        margin: EdgeInsets.only(top: 25, bottom: 15),
                        child: _buttonFunction
                        // OutlineButton(
                        //    // color: Colors.greenAccent[400],
                        //     child: new Text(
                        //       "Yes",
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //     onPressed: () {

                        //        Navigator.of(context).pop();
                        //        _deleteItem();
                        //     },
                        //     borderSide: BorderSide(
                        //         color: Colors.green, width: 0.5),
                        //     shape: new RoundedRectangleBorder(
                        //         borderRadius:
                        //             new BorderRadius.circular(20.0)))
                        )
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }

  void _deleteItem() async {
    var data = {
      'id': widget.data.id,
    };

    var res = await CallApi().postData(data, '/app/deleteProduct');
    var body = json.decode(res.body);

    if (body['success'] == true) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => ProductList()));
    }
  }

  _buildProductImagesWidgets() {
    return Container(
        child: _isVideo == true && _isImage == true && _isShow == false
            ? imgList.length == 0
                ? Container(
                    height: 300,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Colors.white,
                          border: Border.all(width: 0.2, color: Colors.grey)),
                      child: Image.asset(
                        'assets/images/placeholder-image.png',
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ))
                : imgList.length == 1
                    ? Container(
                        height: 300,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              color: Colors.white,
                              border:
                                  Border.all(width: 0.2, color: Colors.grey)),
                          child: Image.network(
                            imgList[0],
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                          ),
                        ))
                    : Stack(
                        children: <Widget>[
                          CarouselSlider(
                            height: 250.0,
                            //initialPage: 0,
                            enlargeCenterPage: true,
                            autoPlay: false,
                            reverse: false,
                            enableInfiniteScroll: true,
                            viewportFraction: 1.0,
                            autoPlayInterval: Duration(seconds: 2),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 2000),
                            pauseAutoPlayOnTouch: Duration(seconds: 10),
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index) {
                              setState(() {
                                _current = index;
                              });
                            },
                            items: imgList.map((imgUrl) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        //viewImage(_current);
                                      },
                                      child: Image.network(
                                        imgUrl,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  color: Colors.black,
                                  child: Text(
                                    "${_current + 1}/${imgList.length}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Oswald"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
            : _isVideo == false && _isImage == true && _isShow == false
                ? imgList.length == 0
                    ? Container(
                        height: 300,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              color: Colors.white,
                              border:
                                  Border.all(width: 0.2, color: Colors.grey)),
                          child: Image.asset(
                            'assets/images/placeholder-image.png',
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ))
                    : Stack(
                        children: <Widget>[
                          CarouselSlider(
                            height: 250.0,
                            //initialPage: 0,
                            enlargeCenterPage: true,
                            autoPlay: false,
                            reverse: false,
                            enableInfiniteScroll: true,
                            viewportFraction: 1.0,
                            autoPlayInterval: Duration(seconds: 2),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 2000),
                            pauseAutoPlayOnTouch: Duration(seconds: 10),
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index) {
                              setState(() {
                                _current = index;
                              });
                            },
                            items: imgList.map((imgUrl) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        //viewImage(_current);
                                      },
                                      child: Image.network(
                                        imgUrl,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  color: Colors.black,
                                  child: Text(
                                    "${_current + 1}/${imgList.length}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Oswald"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ):

/////////////////////////video////////////////
GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          // If the video is paused, play it.
                          _controller.play();
                        }
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Stack(
                        children: <Widget>[
                          vidList[idx]['type'] == "upload"
                              ? FutureBuilder(
                                  future: _initializeVideoPlayerFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Center(
                                        child: AspectRatio(
                                            aspectRatio:
                                                _controller.value.aspectRatio,
                                            child: VideoPlayer(_controller)),
                                      );
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                )
                              : YoutubePlayer(
                                  controller: _ucontroller,
                                  showVideoProgressIndicator: false,
                                  //progressIndicatorColor: Colors.blueAccent,
                                  topActions: <Widget>[
                                    SizedBox(width: 8.0),
                                  ],
                                  onReady :() {
                                    setState(() {
                                      _isPlayerReady = true;
                                    });
                                  },
                                ),
                          //     FutureBuilder(
                          //   future: _initializeVideoPlayerFuture,
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState ==
                          //         ConnectionState.done) {
                          //       return Center(
                          //         child: ,
                          //       );
                          //     } else {
                          //       return Center(
                          //           child: CircularProgressIndicator());
                          //     }
                          //   },
                          // ),

                          Column(
                            children: <Widget>[
                              _isVideo == true &&
                                      _isImage == false &&
                                      _isShow == false
                                  ? Container()
                                  : _isFullVideo
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isShow = false;
                                              if (_controller.value.isPlaying) {
                                                _controller.pause();
                                              } else {
                                                // If the video is paused, play it.
                                                //_controller.play();
                                              }
                                            });
                                          },
                                          child: Container(
                                              alignment: Alignment.topRight,
                                              padding: EdgeInsets.all(5),
                                              child: Container(
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                              _isVideo == true &&
                                      _isImage == false &&
                                      _isShow == false
                                  ? Container()
                                  : vidList[idx]['type'] == "upload"
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              //_isFullVideo = true;
                                              if (_isFullVideo == true) {
                                                _isFullVideo = false;
                                              } else {
                                                _isFullVideo = true;
                                              }
                                            });
                                          },
                                          child: 
                                          Container(
                                              alignment: Alignment.topRight,
                                              padding: EdgeInsets.all(5),
                                              // child: Container(
                                              //   padding: EdgeInsets.all(2),
                                              //   decoration: BoxDecoration(
                                              //       color: _isFullVideo
                                              //           ? Colors.grey
                                              //               .withOpacity(0.4)
                                              //           : Colors.black
                                              //               .withOpacity(0.4),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               15)),
                                              //   child: Icon(
                                              //     _isFullVideo
                                              //         ? Icons.fullscreen_exit
                                              //         : Icons.fullscreen,
                                              //     size: 25,
                                              //     color: Colors.white,
                                              //   ),
                                              // )
                                              ), 
                                        )
                                      : 
                                      Container(),
                            ],
                          ),
                          _controller.value.isPlaying
                              ? Container()
                              : Center(
                                  child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    vidList.length == 1
                                        ? Container()
                                        : idx < 0
                                            ? Container()
                                            : Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // print(vidList[idx].type);
                                                    setState(() {
                                                      //c1 = 0;
                                                      idx--;
                                                      if (idx <= 0) {
                                                        idx = 0;
                                                      }
                                                      idx < 0
                                                          ? null
                                                          : vidList[idx][
                                                                      'type'] ==
                                                                  "upload"
                                                              ? playVideo(
                                                                  vidList[idx]
                                                                      ['vLink'])
                                                              : utubePlay(
                                                                  vidList[idx][
                                                                      'vLink']);
                                                    });
                                                    print(idx);
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      decoration: BoxDecoration(
                                                          color: idx == 0
                                                              ? Colors
                                                                  .transparent
                                                              : _isFullVideo
                                                                  ? Colors.grey
                                                                      .withOpacity(
                                                                          0.4)
                                                                  : Colors.black
                                                                      .withOpacity(
                                                                          0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Icon(
                                                          Icons.chevron_left,
                                                          color: idx == 0
                                                              ? Colors
                                                                  .transparent
                                                              : Colors.white,
                                                          size: 30),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                    vidList[idx]['type'] == "upload"
                                        ? Icon(Icons.play_arrow,
                                            color: Colors.white, size: 45)
                                        : Container(),
                                    vidList.length == 1
                                        ? Container()
                                        : last > vidList.length
                                            ? Container()
                                            : Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      //c2 = 0;
                                                      //  print(vidList[idx]);
                                                      idx++;

                                                      print("idx");
                                                      print(idx);
                                                      print(
                                                          "vidList.length - 1");
                                                      print(vidList.length - 1);
                                                      if (idx >=
                                                          vidList.length - 1) {
                                                        last = vidList.length;
                                                        idx =
                                                            vidList.length - 1;
                                                        // playVideo(
                                                        //     vidList[vidList.length - 1]);
                                                      }
                                                      idx > vidList.length - 1
                                                          ? null
                                                          : vidList[idx][
                                                                      'type'] ==
                                                                  "upload"
                                                              ? playVideo(
                                                                  vidList[idx]
                                                                      ['vLink'])
                                                              : utubePlay(
                                                                  vidList[idx][
                                                                      'vLink']);
                                                    });
                                                    print(idx);
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      decoration: BoxDecoration(
                                                          color: idx ==
                                                                  vidList.length -
                                                                      1
                                                              ? Colors
                                                                  .transparent
                                                              : _isFullVideo
                                                                  ? Colors.grey
                                                                      .withOpacity(
                                                                          0.4)
                                                                  : Colors.black
                                                                      .withOpacity(
                                                                          0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Icon(
                                                          Icons.chevron_right,
                                                          color: idx ==
                                                                  vidList.length -
                                                                      1
                                                              ? Colors
                                                                  .transparent
                                                              : Colors.white,
                                                          size: 30),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                  ],
                                ))
                        ],
                      ),
                    ),
                  )


                      //////////////////////////////
                // :  vidList[idx]['type'] == "upload"
                //               ?GestureDetector(
                //     onTap: () {
                //       setState(() {
                //         if (_controller.value.isPlaying) {
                //           _controller.pause();
                //         } else {
                //           // If the video is paused, play it.
                //           _controller.play();
                //         }
                //       });
                //     },
                //     child: Container(
                //       width: MediaQuery.of(context).size.width,
                //       height: 250,
                //       margin: EdgeInsets.only(bottom: 10),
                //       child: Stack(
                //         children: <Widget>[
                //          FutureBuilder(
                //                   future: _initializeVideoPlayerFuture,
                //                   builder: (context, snapshot) {
                //                     if (snapshot.connectionState ==
                //                         ConnectionState.done) {
                //                       return Center(
                //                         child: AspectRatio(
                //                             aspectRatio:
                //                                 _controller.value.aspectRatio,
                //                             child: VideoPlayer(_controller)),
                //                       );
                //                     } 
                //                     else {
                //                       return Center(
                //                           child: CircularProgressIndicator());
                //                     }
                //                   },
                //                 )
                //               ,
                //           _isVideo == true &&
                //                   _isImage == false &&
                //                   _isShow == false
                //               ? Container()
                //               : GestureDetector(
                //                   onTap: () {
                //                     setState(() {
                //                       _isShow = false;
                //                       _controller.pause();
                //                     });
                //                   },
                //                   child: Container(
                //                       alignment: Alignment.topRight,
                //                       padding: EdgeInsets.all(5),
                //                       child: Container(
                //                         padding: EdgeInsets.all(2),
                //                         decoration: BoxDecoration(
                //                             color:
                //                                 Colors.black.withOpacity(0.4),
                //                             borderRadius:
                //                                 BorderRadius.circular(15)),
                //                         child: Icon(
                //                           Icons.close,
                //                           size: 25,
                //                           color: Colors.white,
                //                         ),
                //                       )),
                //                 ),
                //           _controller.value.isPlaying
                //               ? Container()
                //               : Center(
                //                   child: Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceEvenly,
                //                   children: <Widget>[
                //                     Expanded(
                //                       child: GestureDetector(
                //                         onTap: () {
                //                           setState(() {
                //                             c2--;
                //                             if (c2 == 0) {
                //                               first = 1;
                //                               vidList[idx]['type'] == "upload"
                //                                   ? playVideo(
                //                                       vidList[c2]['vLink'])
                //                                   : utubePlay(
                //                                       vidList[c2]['vLink']);
                //                               // playVideo(vidList[c2]);
                //                             } else {
                //                               vidList[idx]['type'] == "upload"
                //                                   ? playVideo(
                //                                       vidList[idx - 1]['vLink'])
                //                                   : utubePlay(vidList[idx - 1]
                //                                       ['vLink']);
                //                               // playVideo(vidList[idx - 1]);
                //                             }
                //                           });
                //                           print(first);
                //                         },
                //                         child: Container(
                //                           width:
                //                               MediaQuery.of(context).size.width,
                //                           alignment: Alignment.centerLeft,
                //                           child: Icon(Icons.chevron_left,
                //                               color: appColor, size: 45),
                //                         ),
                //                       ),
                //                     ),
                //                     Icon(Icons.play_arrow,
                //                         color: Colors.white, size: 45),
                //                     Expanded(
                //                       child: GestureDetector(
                //                         onTap: () {
                //                           setState(() {
                //                             //c2 = 0;
                //                             //   print("syfgdisuf");
                //                             if (c2 == vidList.length - 1) {
                //                               last = vidList.length;
                //                               // playVideo(
                //                               //     vidList[vidList.length - 1]);
                //                             } else {
                //                               print("syfgdisuf");
                //                               vidList[idx]['type'] == "upload"
                //                                   ? playVideo(
                //                                       vidList[idx + 1]['vLink'])
                //                                  :
                //                                    utubePlay(vidList[idx + 1]
                //                                       ['vLink']);

                //                               // playVideo(vidList[idx + 1]);
                //                             }
                //                             c2++;
                //                           });
                //                           print(last);
                //                         },
                //                         child: Container(
                //                           width:
                //                               MediaQuery.of(context).size.width,
                //                           alignment: Alignment.centerRight,
                //                           child: Icon(Icons.chevron_right,
                //                               color: appColor, size: 45),
                //                         ),
                //                       ),
                //                     ),
                //                   ],
                //                 ))
                //         ],
                //       ),
                //     ),
                //   ): YoutubePlayer(
                //                   controller: _ucontroller,
                //                   showVideoProgressIndicator: false,
                //                   //progressIndicatorColor: Colors.blueAccent,
                //                   topActions: <Widget>[
                //                     SizedBox(width: 8.0),
                //                   ],
                //                   onReady: () {
                //                     setState(() {
                //                       _isPlayerReady = true;
                //                     });
                //                   },
                //                 ) 
                              ////////////////////////////////////
                                );
  }

  _buildSeeVideoWidgets() {
    
    return Container(
      alignment: Alignment.bottomRight,
      child: _isVideo == true && _isImage == true && _isShow == false
          ? vidList.length == 0
              ? Container()
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _isShow = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.only(right: 20, top: 10),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 8, bottom: 8),
                        //   margin: EdgeInsets.only(top: 15),
                        child: Text(
                          //name,
                          "See Video >",
                          style: TextStyle(fontSize: 16.0, color: appColor),
                        ),
                      ),
                    ),
                  ),
                )
          : Container(),
    );
  }

  void playVideo(String link) {
    _controller = VideoPlayerController.network(
        //'https://www.youtube.com/watch?v=_SBucsSIkBU',
        link);
    print(link);
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  void utubePlay(String link) {
    String utubelink = getIdFromUrl(link);
    print("test link");
    print(utubelink);
    _ucontroller = YoutubePlayerController(
      initialVideoId: utubelink,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHideAnnotation: true,
      ),
    )..addListener(listener);

    // _initializeuTubeVideoPlayerFuture = _ucontroller..addListener(listener)
  }

  void listener() {
    if (_isPlayerReady && mounted && !_ucontroller.value.isFullScreen) {
      setState(() {
        _playerState = _ucontroller.value.playerState;
        _videoMetaData = _ucontroller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.

    _ucontroller.pause();
    super.deactivate();
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   _idController.dispose();
  //   _seekToController.dispose();
  //   super.dispose();
  // }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    _ucontroller.dispose();
    _idController.dispose();
    // _seekToController.dispose();
    // for (var vc in vidList) {
    //   vc.dispose();
    // }

    super.dispose();
  }
}
