import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:bahrain_admin/Model/CategoryModel/CategoryModel.dart';
import 'package:bahrain_admin/Model/SubCategoryModel/SubCategoryModel.dart';
import 'package:bahrain_admin/Screen/ProductPage/FeatureProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/NewProductList.dart';
import 'package:bahrain_admin/Screen/ProductPage/ProductList.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:bahrain_admin/redux/action.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as imgPick;
import 'package:mime_type/mime_type.dart';
import 'package:multi_media_picker/multi_media_picker.dart';
import 'package:path/path.dart' as Path;
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_parser/youtube_parser.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../KeyValueModel.dart';

enum PhotoCrop {
  free,
  picked,
  cropped,
}

class EditProductform extends StatefulWidget {
  final data;
  EditProductform(this.data);
  @override
  _EditProductformState createState() => _EditProductformState();
}

class _EditProductformState extends State<EditProductform> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController costController = new TextEditingController();
  TextEditingController colorController = new TextEditingController();
  TextEditingController sizeController = new TextEditingController();
  TextEditingController stockController = new TextEditingController();
  TextEditingController warrentyController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();

  // var _address = ['Pending', 'Cancel'];

  // var _currentAddressSelected = 'Pending';
  // void _educationDropDownSelected(String newValueSelected) {
  //   setState(() {
  //     this._currentAddressSelected = newValueSelected;
  //   });
  // }


  bool _isImage = false;
  bool _isVideo = false;
  bool _isCancelImg = false;
  bool _isCancelVideo = false;
  bool _subDrop = false;

  String categoryName = "";
  var categoryId = "";
  var userId;
  var customerId;
  var categorysData;
  KeyValueModel categoryModel;
  List<KeyValueModel> categoryList = <KeyValueModel>[];
  var _showImage;
  String subcategoryName = "";
  var subcategoryId = "";
  var subuserId;
  var subcustomerId;
  var subcategoryData;
  SubKeyValueModel subcategoryModel;
  List<SubKeyValueModel> subcategoryList = <SubKeyValueModel>[];

  File _video;

  //VideoPlayerController _videoPlayerController;
  bool _isLoading = false;
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

  ////////// Image Picker//////
  PhotoCrop state;
  File imageFile;
  String image;
  var imagePath;
  var newValue;
  var featureValue;

    int imgPercent=0;
  int videoPercent=0;

  String date="";

  DateTime selectedDate = DateTime.now();
  var format;

  Container addProductCon(String label, String hint,
      TextEditingController control, TextInputType type, ) {
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        child: Column(
          children: <Widget>[  
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 10, bottom: 8),
                child: Text(label,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: appColor, fontSize: 13))),

                    Container(
                          margin: EdgeInsets.only(left: 8, top: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.grey[100],
                    border: Border.all(width: 0.2, color: Colors.grey)),
                      child: new SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        //reverse: true,
                        child: new TextField(   
                          textInputAction: TextInputAction.newline,
                       //  keyboardType: TextInputType.multiline,
                         maxLines: type==TextInputType.multiline?null:1,     
                          autofocus: false, 
                          controller: control,
                         keyboardType: type,
                          decoration: InputDecoration(
                            hintText: hint,
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                              
                        ),
                      ),
                    ),
           
          ],
        ));
  }

  var categoryData;
  var body;
 TextEditingController utubeController = new TextEditingController();
   ////////////// video //////////

  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String _sound = "";

  /////////////// video/////////////////

  String videoType = "";
  // List imgListEdit = [];
  List videoListEdit = [];
  int imgNum=0;
  List imgList = [];
  List videoList = [];
   VideoPlayerController _controller;
     Future<void> _initializeVideoPlayerFuture;
       YoutubePlayerController _ucontroller;

  @override
  void initState() {

      utubeController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = YoutubeMetaData();
    _playerState = PlayerState.unknown;
     imgPercent = 0;
    videoPercent=0;

    print(widget.data.cost);
    _showCategory();

    if (widget.data.photo != null) {
      for (var d in widget.data.photo) {
          imgNum++;
        imgList.add({'link': d.link});
      }
    }

    if (widget.data.videos != null) {
        for (int i = 0; i < widget.data.videos.length; i++) {
        videoList.add({
          "link": "${widget.data.videos[i].link}",
          "type": "${widget.data.videos[i].type}",
        });
     //   videoList.add({'link': d.link});

        // _videoPlayerController = VideoPlayerController.network(d.link)
        //   ..initialize().then((_) {
        //     setState(() {});
        //     // _videoPlayerController.play();
        //   });
      }
    }

    if (store.state.categoryListsRedux.length != 0) {
      // categoryModel = store.state.categoryListsRedux[0];
      for (int i = 0; i < store.state.categoryListsRedux.length; i++) {
        categoryList.add(
            //{
            // 'name' : "${store.state.categoryListsRedux[i].categoryName}",
            // 'id' : "${store.state.categoryListsRedux[i].id}",
            //  },
            KeyValueModel(
                key: "${store.state.categoryListsRedux[i].name}",
                value: "${store.state.categoryListsRedux[i].id}"));
      }
    }
    state = PhotoCrop.free;
    format = DateFormat("yyyy-MM-dd").format(selectedDate);

    // print(widget.data.category.name);
    nameController.text = widget.data.name == null ? "" : '${widget.data.name}';
    descriptionController.text =
        widget.data.description == null ? "" : '${widget.data.description}';
    priceController.text =
        widget.data.price == null ? "" : '${widget.data.price}';
    costController.text = widget.data.cost == null ? "" : '${widget.data.cost}';
    // colorController.text = '${widget.data.color}';
    // sizeController.text = '${widget.data.size}';
    stockController.text =
        widget.data.stock == null ? "" : '${widget.data.stock}';
         costController.text =
        widget.data.cost == null ? "" : '${widget.data.cost}';
    newValue = widget.data.isNew == null ? "" : '${widget.data.isNew}';
    featureValue =
        widget.data.isFeatured == null ? "" : '${widget.data.isFeatured}';
    warrentyController.text = widget.data.warranty == null ? "" : '${widget.data.warranty}';
    categoryName = widget.data.category == null
        ? ""
        : widget.data.category.name != null
            ? '${widget.data.category.name}'
            :
            // store.state.zoneInitClick
            //     ? _dropDownZoneItems[0].value
            //     :
            "Select Category";

    categoryId = widget.data.category == null
        ? ""
        : widget.data.category.id != null ? '${widget.data.category.id}' : "";

    subcategoryName = widget.data.subcategory == null
        ? ""
        : widget.data.subcategory.name != null
            ? '${widget.data.subcategory.name}'
            :
            // store.state.zoneInitClick
            //     ? _dropDownZoneItems[0].value
            //     :
            "Select Sub-Category";

    subcategoryId = widget.data.subcategory == null
        ? ""
        : widget.data.subcategory.id != null
            ? '${widget.data.subcategory.id}'
            : "";
    _showsubCategory();
    // super.initState();
  }

    @override
  void deactivate() {
    // Pauses video while navigating to next page.
    print("object_deactivate");
    // _ucontroller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
   
    super.dispose();
  }

    void sound() {
    // _ucontroller.dispose();
    print("sound");
    print(_sound);
  }

    void _addToYoutube() {
    videoList.add({'link': utubeController.text, 'type': 'youtubelink'});

    setState(() {
      _isVideo = false;
      utubeController.text = "";
    });

    print(videoList);
  }


  void utube(String link) {
    String utubelink = getIdFromUrl(link);
    // print("test link");
    // print(utubelink);
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
  }
    void listener() {
    if (_isPlayerReady && mounted && !_ucontroller.value.isFullScreen) {
      setState(() {
        _playerState = _ucontroller.value.playerState;

        _videoMetaData = _ucontroller.metadata;
      });
    }
  }


      void initVideo(String link) {
    _controller = VideoPlayerController.network(

        link);
     //  _controller.play();

     _initializeVideoPlayerFuture = _controller.initialize();

   // _controller.setLooping(true);
  }

  ////////////// get  category start ///////////////

  Future _getLocalCategoryData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localCategoryData = localStorage.getString(key);
    if (localCategoryData != null) {
      body = json.decode(localCategoryData);
      _categoryState();
    }
  }

  void _categoryState() {
    var category = CategoryModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      categoryData = category.category;
      _isLoading = false;
    });

    store.dispatch(CategoryListRedux(categoryData));
  }

  Future<void> _showCategory() async {
    var key = 'category-list';
    await _getLocalCategoryData(key);

    var res = await CallApi().getData('/app/indexCategory');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      _categoryState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
  }

  // //////////////// get  category end ///////////////

  Future<void> _showsubCategory() async {
    // var key = 'subcategory-list';
    // await _getLocalsubCategoryData(key);

    setState(() {
      _subDrop = true;
    });
    print(categoryId);
    var res = await CallApi()
        .getData('/app/showsubCategoryforProduct?categoryId=$categoryId');
    body = json.decode(res.body);

    if (res.statusCode == 200) {
      //_subcategoryState();
        print(body);
      var subcategory = SubCategoryModel.fromJson(body);
      if (!mounted) return;
      setState(() {
        subcategoryData = subcategory.subCategoryforProduct;
        _isLoading = false;
      });
      // store.dispatch(SubCategoryListRedux(subcategoryData));

      // print(subcategoryData);
      // print(body);
      //  if (subcategoryData.length != 0) {
      // categoryModel = store.state.categoryListsRedux[0];
      for (int i = 0; i < subcategoryData.length; i++) {
        subcategoryList.add(SubKeyValueModel(
            key: "${subcategoryData[i].name}",
            value: "${subcategoryData[i].id}"));
        //  }

        //  store.dispatch(SubCategoryInitClick(false));
        // }
      }

      setState(() {
        _subDrop = false;
        print(_subDrop);
      });

      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString(key, json.encode(body));
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        //  locale: Locale("yyyy-MM-dd"),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = "${DateFormat("dd - MMMM - yyyy").format(selectedDate)}";
      });
  }

  File _image;

    void cancelImg() async {
    print("object");

   // token.cancel("cancelled");
 

    //     Response response;
    // try {
    //   response=await dio.get('https://admin.bahrainunique.com/app/upload', cancelToken: token);
    //   print(response);
    // }catch (e){
    //   if (CancelToken.isCancel(e)) {
    //     print(' $e');
    //   }
    // }

    setState(() {
      _isImage = false;
      _isCancelImg = true;
    });
  }

  void cancelVideo() async {




    setState(() {
      _isVideo = false;
      _isCancelVideo = true;
    });
  }

  void _uploadImg(filePath, int len, int idx) async {

    //   setState(() {
    //   _isImage = true;
    // });
    //Get base file name

  
    try {
        String fileName = Path.basename(filePath.path);
    print("File base name: $fileName");

      // FormData formData =
      //     new FormData.from({"img": new UploadFileInfo(filePath, fileName)});
     // print(formData);
  //    String mimeType = mime(fileName);
  // String mimee = mimeType.split('/')[0];
  // String type = mimeType.split('/')[1];
         FormData formData = FormData.fromMap({
        "img": await MultipartFile.fromFile(
          filePath.path, filename: fileName,
         // contentType: MediaType(mimee,type)
          ),
      });
      Response response =
          // await CallApi().postData(formData, '/app/storeProduct');

          await Dio().post('https://admin.bahrainunique.com/app/upload', data: formData,
            onSendProgress: (int sent, int total) {
         //   print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
           setState(() {
             
              imgPercent=((sent/total)*100).toInt();
           });
    print(imgPercent);
          });

      if(_isCancelImg ==true){
         _isCancelImg = false;
    }
   else {
         setState(() {
        _showImage = response.data['imageUrl'];
       //  _isImage = false;
           imgPercent=0;

        // imgListEdit.add(url+_showImage);
      });
      imgList.add({'link': response.data['imageUrl']});


  print("index");
  print(idx);
  print("len");
  print(len);
        if ((imgList.length-imgNum) == len ) {
          print("if");
          imgNum= imgNum+len;
          setState(() {
              imgPercent = 100;
            _isImage = false;
          
          });
        }
   }
      print(imgList);

      // Show the incoming message in snakbar
      //_showMsg(response.data['message']);
    } catch (e) {
      // print("Exception Caught: $e");
    }
  }

  _pickVideo() async {
    File video = await imgPick.ImagePicker.pickVideo(source: imgPick.ImageSource.gallery);
    if (video == null) {
    } else {
      // videoList.add('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
      _uploadVideo(video);
      _video = video;

      //  for(int i=0;i<videoList.length;i++){

      // _videoPlayerController = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')
      //   ..initialize().then((_) {
      //     setState(() {});
      //     _videoPlayerController.play();
      //   });
      //  }
    }
  }

  void _uploadVideo(filePath) async {
    //Get base file name
    // print("object");
    // print(filePath);

     setState(() {
      _isVideo = true;
    });

    String fileName = Path.basename(filePath.path);
    print("File base name: $fileName");

    try {
      // FormData formData =
      //     new FormData.from({"video": new UploadFileInfo(filePath, fileName)});
  //      String mimeType = mime(fileName);
  // String mimee = mimeType.split('/')[0];
  // String type = mimeType.split('/')[1];
         FormData formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(
          filePath.path, filename: fileName,
         // contentType: MediaType(mimee,type)
          ),
      });
      print(formData);
      Response response = await Dio()
          .post('https://admin.bahrainunique.com/app/videoUpload', data: formData,
                  onSendProgress: (int sent, int total) {
            print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
          
           setState(() {
              
              videoPercent=((sent/total)*100).toInt();
           });
   // print("$sent $total");
          });
            print(response);
            print(videoPercent);
      print("File upload response: $response");

      // videoList.add(response.data['videoUrl']);
         if(_isCancelVideo ==true){
         _isCancelVideo = false;
    }
   else {
       videoList.add({'link': response.data['videoUrl'], 'type': 'upload'});
        setState(() {
            _isVideo = false;
          videoPercent = 0;
        });
   }


      // _videoPlayerController = VideoPlayerController.network(
      //      response.data['videoUrl'])
      //   ..initialize().then((_) {
      //     setState(() {});
      //     // _videoPlayerController.play();
      //   });

        setState(() {
      _isVideo = false;
       videoPercent =0;
    });

      print(videoList);

      // Show the incoming message in snakbar
      _showMsg(response.data['message']);
    } catch (e) {
      // print("Exception Caught: $e");
    }
  }

  Future getImages() async {
    var images = await MultiMediaPicker.pickImages(source: ImageSource.gallery);

   if(images!=null){

     
    setState(() {
      _isImage = true;
    });
       for (int i = 0; i < images.length; i++) {
      _uploadImg(images[i], images.length, i);

      
  print("index1");
  print(i);
  print("len1");
  print(images.length);

      
    }
   }
   

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        children: <Widget>[
          //////////////// Picture Button Start/////////////////

          // Container(
          //     alignment: Alignment.center,
          //     margin: EdgeInsets.only(top: 18, bottom: 10),
          //     //color: Colors.red,
          //     child: _profilePictureButton()),
          //////////////// Picture Button End/////////////////

          SizedBox(height: 15),

          _isImage
                  ?  Container(
                     padding: const EdgeInsets.all(12.0),
                  margin: EdgeInsets.only(top: 20),
                  decoration:BoxDecoration(
                    shape: BoxShape.circle,
                 
                    border:Border.all(
                      color: appColor,width: 2
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(imgPercent.toString()+"%"),
                  )
                )
                      :imgList.length == 0
              ? Container()
              : Container(
                  height: 150,
                  margin: EdgeInsets.only(top: 5, bottom: 10),
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  shape: BoxShape.rectangle),
                              child: Container(
                                child: Image.network(
                                  // 'assets/images/camera.jpg',
                                   imgList[index]['link'],
                                  height: 120,
                                  width: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              
                              decoration: BoxDecoration(     
                                color: Colors.grey.withOpacity(.5),
                                borderRadius:BorderRadius.circular(50)
                              ),
                              //   alignment: Alignment.topRight,
                              child: GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(Icons.close),
                                ),
                                onTap: () {
                                    _deleteImg(index);
                                  // imgList.removeAt(index);
                                  // setState(() {});
                                },
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: imgList.length,
                  )),

           _isImage
                  ? RaisedButton.icon(
                      color: Colors.blueGrey,
                      onPressed: () {
                        cancelImg();
                      },
                      icon: new Icon(Icons.image, color: Colors.white),
                      label: new Text(
                        "Cancel Uploading",
                        style: TextStyle(color: Colors.white),
                      ))
                  : RaisedButton.icon(
              color: Colors.blueGrey,
              onPressed: () {
                getImages();
              },
              icon: new Icon(Icons.image, color: Colors.white),
              label: new Text(
                "Add Product Image",
                //    _imageFile==null?"Add Product Image":"Add Product Image",
                style: TextStyle(color: Colors.white),
              )),

          SizedBox(
            height: 5,
          ),

          _isVideo
                  ? Container(
                     padding: const EdgeInsets.all(12.0),
                  margin: EdgeInsets.only(top: 20),
                  decoration:BoxDecoration(
                    shape: BoxShape.circle,
                 
                    border:Border.all(
                      color: appColor,width: 2
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(videoPercent.toString()+"%"),
                  )
                ): videoList.length == 0
              ? Container()
              : 
              Container(
                          height: 150,
                          margin: EdgeInsets.only(top: 5, bottom: 10),
                          padding: EdgeInsets.only(top: 2, bottom: 2),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              _sound == ""
                                  ? videoList[index]['type'] == "upload"
                                      ? initVideo(videoList[index]['link'])
                                      : utube(videoList[index]['link'])
                                  : sound();
                              //  : _playUtubeVideo(videoList[index]['link']);

                              return Stack(
                                children: <Widget>[
                                  videoList[index]['type'] == "upload"
                                      ? Container(
                                          margin: EdgeInsets.only(left: 12),
                                          child: AspectRatio(
                                            aspectRatio:
                                                _controller.value.aspectRatio,
                                            child: VideoPlayer(_controller),
                                          ))
                                      :
                                      // Container(

                                      //   child: Text("you tube"),
                                      // )
                                      YoutubePlayer(
                                          controller: _ucontroller,
                                          showVideoProgressIndicator: false,
                                          //progressIndicatorColor: Colors.blueAccent,
                                          topActions: <Widget>[
                                            SizedBox(width: 8.0),
                                          ],
                                          onReady: () {
                                            // print("dfsifugsdf");
                                            if (_sound == "") {
                                              setState(() {
                                                _isPlayerReady = true;
                                              });
                                            } else if (_sound == "no") {
                                              setState(() {
                                                _isPlayerReady = false;
                                                print("no sound for paly");
                                              });
                                            }

                                            // print(_isPlayerReady);
                                          },
                                        ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        _deleteVideo(index);
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
                                 BorderRadius.circular(15)),
                                            child: Icon(
                                              Icons.close,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: videoList.length,
                          )),
                           videoType == "gallery"
                  ? _isVideo
                      ? Container(
                          //  color: appColor,
                          child: RaisedButton.icon(
                              color: Colors.blueGrey,
                              onPressed: () {
                                cancelVideo();
                              },
                              icon:
                                  new Icon(Icons.videocam, color: Colors.white),
                              label: new Text(
                                "Cancel Uploading",
                                style: TextStyle(color: Colors.white),
                              )))
                      : Container(
                          //  color: appColor,
                          child: RaisedButton.icon(
                              color: Colors.blueGrey,
                              onPressed: () {
                                _pickVideo();
                              },
                              icon:
                                  new Icon(Icons.videocam, color: Colors.white),
                              label: new Text(
                                "Add Product Video From gallery",
                                style: TextStyle(color: Colors.white),
                              )))
                  : videoType == "youtube"
                      ? Container(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 5),
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(left: 10, bottom: 8),
                                  child: Text("You tube Video url",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: appColor, fontSize: 13))),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.topLeft,
                                      width: (MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2) +
                                          (MediaQuery.of(context).size.width /
                                              4),
                                      margin: EdgeInsets.only(left: 8, top: 0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          color: Colors.grey[100],
                                          border: Border.all(
                                              width: 0.2, color: Colors.grey)),
                                      child: TextField(
                                        cursorColor: Colors.grey,
                                        controller: utubeController,
                                        keyboardType: TextInputType.text,
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              15.0, 10.0, 20.0, 15.0),
                                          border: InputBorder.none,
                                        ),
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                          icon: Icon(Icons.add_box,
                                              color: appColor),
                                          onPressed: () {
                                             utubeController.text.isEmpty?_showMsg("Add video url"):
                                            _addToYoutube();
                                          })),
                                ],
                              ),
                            ],
                          )),
                        )
                      : Container(),
                        Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                videoType = "gallery";
                              });
                            },
                            child: Icon(
                              videoType == "gallery"
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: appColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              //"\$ 5678",
                              "Add video from gallery",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "sourcesanspro",
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 10),
                      child: Row(         
                        children: <Widget>[
                          GestureDetector(                     
                            onTap: () {
                              setState(() {
                                videoType = "youtube";      
                              });
                            },
                            child: Icon(                    
                              videoType == "youtube"
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: appColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              //"\$ 5678",
                              "Add video from you tube",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: appColor,
                                  fontFamily: "sourcesanspro",
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //                     height: 150,
              //                     margin: EdgeInsets.only(top: 5, bottom: 10),
              //                     padding: EdgeInsets.only(top: 2, bottom: 2),
              //                     child: ListView.builder(
              //                       physics: BouncingScrollPhysics(),
              //                       scrollDirection: Axis.horizontal,
              //                       itemBuilder:
              //                           (BuildContext context, int index){

                                        
              //                              initVideo(videoList[index]['link']);

                     
                           
              //                            return   Stack(
              //                                 children: <Widget>[

                                   
              //                                   Container(
              //                         margin: EdgeInsets.only(left: 12),
                   
              //           child: 
              //          AspectRatio(
              //           aspectRatio: _controller.value.aspectRatio,
              //         child: VideoPlayer(_controller),
                     
                       
              //         )
                    
                  
              //                       ),
                                    

              //               Positioned(
              //                 right: 0 ,
              //                   child: GestureDetector(
              //                       onTap: () {
              //                           _deleteVideo(index);
                                     
              //                       },
              //                       child: Container(
              //                           alignment: Alignment.topRight,
              //                           padding: EdgeInsets.all(5),
              //                           child: Container(
              //                             padding: EdgeInsets.all(2),
              //                             decoration: BoxDecoration(
              //                                 color:
              //                                     Colors.black.withOpacity(0.4),
              //                                 borderRadius:
              //                                     BorderRadius.circular(15)),
              //                             child: Icon(
              //                               Icons.close,
              //                               size: 25,
              //                               color: Colors.white,
              //                             ),
              //                           )),
              //                     ),
              //                 ),
              //                                 ],
              //                             );
              //                           },
              //                       itemCount: videoList.length,
              //                     )),
              
              // Container(
              //     height: 150,
              //     margin: EdgeInsets.only(top: 5, bottom: 10),
              //     padding: EdgeInsets.only(top: 2, bottom: 2),
              //     child: ListView.builder(
              //       physics: BouncingScrollPhysics(),
              //       scrollDirection: Axis.horizontal,
              //       itemBuilder: (BuildContext context, int index) {
              //         //                    print('videoList');
              //         //                     print(videoList.length);
              //         print(videoList[index]['link']);
              //                       _videoPlayerController = VideoPlayerController.network(
              //                         videoList[index]['link']
              //                        )
              //         ..initialize().then((_) {
              //           if (!mounted) return; setState(() {}
              //           );
              //          // _videoPlayerController.play();
              //         });

              //         return Stack(
              //           children: <Widget>[
              //             GestureDetector(
              //               onTap: () {},
              //               child: Container(
              //                 margin: EdgeInsets.only(left: 12),
              //                 child: _videoPlayerController.value.initialized
              //                     ? AspectRatio(
              //                         aspectRatio: _videoPlayerController
              //                             .value.aspectRatio,
              //                         child:
              //                             VideoPlayer(_videoPlayerController),
              //                       )
              //                     : Container(),
              //               ),
              //             ),
              //             Container(
              //            alignment: Alignment.center,
              //               child: IconButton(
              //               onPressed: () {
              //               setState(() {
              //                 if (_videoPlayerController.value.isPlaying) {
              //                   _videoPlayerController.pause();
              //                 } else {
              //                   // If the video is paused, play it.
              //                   _videoPlayerController.play();
              //                 }
              //               });
              //               },
              //               icon: Center(
              //                 child: _videoPlayerController.value.isPlaying
              //                   ? Icon(
              //                       Icons.play_arrow,
              //                       color: Colors.transparent,
              //                     )
              //                   : Icon(Icons.play_arrow),
              //               ),
              //             ),
              //             ),
              //             Positioned(
              //               child: Container(
              //                 //   alignment: Alignment.topRight, 
              //                 child: IconButton(
              //                   icon: Icon(Icons.close),
              //                   onPressed: () {
              //                     _deleteVideo(index);
              //                     // videoList.removeAt(index);
              //                     // setState(() {});
              //                   },
              //                 ),
              //               ),
              //             )
              //           ],
              //         );
              //       },
              //       itemCount: videoList.length,
              //     )),

          //  _isVideo? Container(
          //         //  color: appColor,
          //         child: RaisedButton.icon(
          //             color: Colors.blueGrey,
          //             onPressed: () {
          //              cancelVideo();
          //             },
          //             icon: new Icon(Icons.videocam, color: Colors.white),
          //             label: new Text(
          //               "Cancel Uploading",
          //               style: TextStyle(color: Colors.white),
          //             ))): Container(
          //     //  color: appColor,
          //     child: RaisedButton.icon(
          //         color: Colors.blueGrey,
          //         onPressed: () {
          //           _pickVideo();
          //         },
          //         icon: new Icon(Icons.videocam, color: Colors.white),
          //         label: new Text(
          //           "Add Product Video",
          //           style: TextStyle(color: Colors.white),
          //         ))),

          addProductCon(
              " Product Name", "", nameController, TextInputType.text),
          addProductCon(
              " Description", "", descriptionController, TextInputType.multiline),
          addProductCon(" Price", "", priceController, TextInputType.number),
          addProductCon(" Cost", "", costController, TextInputType.number),
          // addProductCon(" Size", "", sizeController, TextInputType.text),
          // addProductCon(" Color", "", colorController, TextInputType.text),
          addProductCon(" Stock", "", stockController, TextInputType.number),

          GestureDetector(
            onTap: () {
              !store.state.categoryInitClick ? initState() : null;
              setState(() {
                // _iscategoryClick = true;
                store.dispatch(CategoryInitClick(true));
                //_category = true;
              });
            },
            child: Column(
              children: <Widget>[
                Container(
                  //  color: Colors.blue,
                  margin:
                      EdgeInsets.only(right: 15, left: 30, bottom: 0, top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Category: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: appColor,
                        fontFamily: "sourcesanspro",
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  //color: Colors.yellow,
                  margin:
                      EdgeInsets.only(left: 20, right: 15, top: 6, bottom: 6),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.grey[100],
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    //  borderRadius: BorderRadius.circular(20),
                    // color: Colors.white),
                   // alignment: Alignment.center,
                   width:MediaQuery.of(context).size.width,
                    height: 42,
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,                             
                        child: DropdownButton<KeyValueModel>(   
                          items: categoryList
                              .map((KeyValueModel user) {
                            return new DropdownMenuItem<
                                KeyValueModel>(
                              value: user,
                               child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: new Text(
                    user.key,
                    style: new TextStyle(
                        color: Colors.grey[600],fontSize: 15),
                    ),
                    )
                            );
                          }).toList(),
                          // items: categoryNameList
                          //     .map((data) => DropdownMenuItem<String>(
                          //           child: Text(data.key),
                          //          // key: data.key.,
                          //           value: data.key,
                          //         ))
                          //     .toList(),
                          onChanged: (KeyValueModel value) {
                            setState(() {
                              categoryModel = value;
                              categoryName = categoryModel.key;
                              categoryId = categoryModel.value;
                              subcategoryList = [];
                              subcategoryName = "";
                            });

                            print(categoryId);

                            _showsubCategory();
                          },
                            hint:  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: new Text(
                    categoryName,
                    style: new TextStyle(
                        color: Colors.grey[600],fontSize: 15),
                    ),
                    )
                        ),

                     
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /////////// sub

            _subDrop? Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(bottom: 8, top: 30),
                      child: Text("Please wait to select sub-category...",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 15))):  Column(
                            children: <Widget>[
                              Container(
                                //  color: Colors.blue,
                                margin:
                                    EdgeInsets.only(right: 15, left: 30, bottom: 0, top: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Sub-Category: ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: appColor,
                                      fontFamily: "sourcesanspro",
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Container(
                                //color: Colors.yellow,
                                margin:
                                    EdgeInsets.only(left: 20, right: 15, top: 6, bottom: 6),
                                child: Container(
                                  width:MediaQuery.of(context).size.width,
                                   height: 42,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5.0)),
                                      color: Colors.grey[100],
                                      border: Border.all(width: 0.2, color: Colors.grey)),
                                  //  borderRadius: BorderRadius.circular(20),
                                  // color: Colors.white),
                                //  alignment: Alignment.center,
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      //alignedDropdown: true,
                                      child: DropdownButton<SubKeyValueModel>(
                                        items: subcategoryList
                                            .map((SubKeyValueModel subuser) {
                                          return new DropdownMenuItem<
                                              SubKeyValueModel>(
                                            value: subuser,
                                             child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: new Text(
                                  subuser.key,
                                  style: new TextStyle(
                                      color: Colors.grey[600],fontSize: 15),
                                ),
                              )
                                          );
                                        }).toList(),
                                        // items: categoryNameList
                                        //     .map((data) => DropdownMenuItem<String>(
                                        //           child: Text(data.key),
                                        //          // key: data.key.,
                                        //           value: data.key,
                                        //         ))
                                        //     .toList(),
                                        onChanged: (SubKeyValueModel value) {
                                          setState(() {
                                            subcategoryModel = value;
                                            subcategoryName =
                                                subcategoryModel.key;
                                            subcategoryId =
                                                subcategoryModel.value;
                                          });

                                          //_showsubCategory();
                                        },
                                          hint:  Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: new Text(
                                 subcategoryName,
                                  style: new TextStyle(
                                      color: Colors.grey[600],fontSize: 15),
                                ),
                              ),
                                        value: subcategoryModel,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
          ////////////   warrenty start
           addProductCon(
              " Warranty", "", warrentyController, TextInputType.text),
          // Column(
          //   children: <Widget>[
          //     Container(
          //         alignment: Alignment.topLeft,
          //         margin: EdgeInsets.only(left: 25, top: 5, bottom: 8),
          //         child: Text("Warranty",
          //             textAlign: TextAlign.left,
          //             style: TextStyle(color: appColor, fontSize: 13))),
          //     Container(
          //       margin: EdgeInsets.only(left: 20, right: 20),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
          //           color: Colors.grey[100],
          //           border: Border.all(width: 0.2, color: Colors.grey)),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: <Widget>[
          //           Container(
          //             padding: EdgeInsets.only(left: 20),
          //             child: Text(
          //               date.toString(),
          //               textAlign: TextAlign.right,
          //               style: TextStyle(color: Colors.grey[600]),
          //             ),
          //           ),
          //           IconButton(
          //             onPressed: () {
          //               _selectDate(context);
          //             },
          //             icon: Icon(Icons.calendar_today),
          //           )
          //         ],
          //       ),
          //     ),
          //   ],
          // ),

          /////////////////   profile editing save start ///////////////

          GestureDetector(
            onTap: () {
              _isLoading ? null : _editProducts();
            },
            child: Container(
              margin: EdgeInsets.only(left: 25, right: 15, bottom: 20, top: 25),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: appColor.withOpacity(0.9),
                  border: Border.all(width: 0.2, color: Colors.grey)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.save,
                    size: 20,
                    color: Colors.white,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(_isLoading ? "Saving..." : "Save",
                          style: TextStyle(color: Colors.white, fontSize: 17)))
                ],
              ),
            ),
          ),

          /////////////////   profile editing save end ///////////////
        ],
      ),
    );
  }



  void _editProducts() async {
//print(descriptionController.text);
    if (nameController.text.isEmpty) {
      return _showMsg("Product Name is empty");
    } else if (descriptionController.text.isEmpty) {
      return _showMsg("Product Description is empty");
    } else if (priceController.text.isEmpty) {
      return _showMsg("Product Price is empty");
    } else if (costController.text.isEmpty) {
      return _showMsg("Product Cost is empty");
    }
    // else if (sizeController.text.isEmpty) {
    //   return _showMsg("Product Size is empty");
    // }
    // else if (colorController.text.isEmpty) {
    //   return _showMsg("Product Color is empty");
    // }
    else if (stockController.text.isEmpty) {
      return _showMsg("Product stock is empty");
    } else if (categoryId == "") {
      return _showMsg("Product Category is empty");
    } 
    else if (subcategoryId == "") {
      return _showMsg("Product Sub-Category is empty");
    }
    //  else if (date.isEmpty) {
    //   return _showMsg("Product warrenty is empty");
    // } 
    else if (imgList.length == 0) {
      return _showMsg("Upload Product Image");
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      'id': '${widget.data.id}',
      'name': nameController.text,
      'description': descriptionController.text,
      // 'color': colorController.text,
      // 'size': sizeController.text,
      'price': priceController.text,
      'cost': costController.text,
      'stock': stockController.text,
      'warranty': warrentyController.text,
      'isNew': newValue,
      'isFeatured': featureValue,
      'categoryId': categoryId,
      'subCategoryId': subcategoryId,
      'image': imgList[0]['link'],
      'uploadList': imgList,
      'videotList': videoList,
    };

    print("videoList");
    print(videoList);
    print(data);

    var res = await CallApi().postData(data, '/app/editProduct');
    // print(res);
    var body = json.decode(res.body);
     print(body);

     if(res.statusCode == 422){
   
    _showMsg(body['message']);
     }
   // print(body);
else{
  //  if (body['success'] == true) {
      if (res.statusCode == 200) {
      //SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('token', body['token']);
      //  localStorage.setString('pass', loginPasswordController.text);
      // localStorage.setString('products', json.encode(body['product']));

     _showSuccess();
    } else {
      _showMsg("Something is wrong! Try Again");
    }
}

    setState(() {
      _isLoading = false;
    });
  }

      void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  ////////////   Address  start ///////////

                  ///////////// Address   ////////////

                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 25, top: 5, bottom: 8),
                      child: Text("Your Product has been edited successfully",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColor, fontSize: 15))),
                ],
              ),
            ],
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
                        width: 80,
                        height: 45,
                        margin: EdgeInsets.only(
                          top: 25,
                          bottom: 15,
                        ),
                        child: OutlineButton(
                          child: new Text(
                            "Ok",
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                              visitDetails == "product"?
                       Navigator.push( context, FadeRoute(page: ProductList())):
                               visitDetails == "new"?
                               Navigator.push( context, FadeRoute(page: NewProductList())):
                               visitDetails == "feature"?
Navigator.push( context, FadeRoute(page: FeatureProductList())):
                              null;
                          },
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                        )),
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }


  
    void _deleteImg(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Are you sure want to remove this?",
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
                        child: OutlineButton(
                            // color: Colors.greenAccent[400],
                            child: new Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              imgList.removeAt(index);
                              setState(() {
                                 imgNum = imgNum -1;
                              });
                             Navigator.pop(context);
                              // _deleteOrders();
                            },
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0))))
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }

     void _deleteVideo(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Are you sure want to remove this?",
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
                        child: OutlineButton(
                            // color: Colors.greenAccent[400],
                            child: new Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              videoList.removeAt(index);
                                  setState(() {});
                             Navigator.pop(context);
                              // _deleteOrders();
                            },
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0))))
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }
}
