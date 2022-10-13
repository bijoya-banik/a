import 'dart:convert';

import 'package:bahrain_admin/Screen/HomePage/HomePage.dart';
import 'package:bahrain_admin/api/api.dart';
import 'package:bahrain_admin/customPlugin/routeTransition/routeAnimation.dart';
import 'package:bahrain_admin/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInForm extends StatefulWidget {
  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
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

  bool _isLoading = false;
  var appToken;
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String loginEmail = "", loginPass = "";

  @override
  void initState() {
    /// add firebase notification/////

    _firebaseMessaging.getToken().then((token) async {
      print("Notification app token");
      print(token);
      appToken = token;
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      //  localStorage.setString('firebaseToken',token);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/ecom.jpg"),
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.5), BlendMode.dstATop),
        ),
      ),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        content: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.transparent,
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(top: 35),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 25),
                            child: Text(
                              "Sign in to your account",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w400),
                            )),

                        ////////////////////////   log in phone start //////////////////

                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.white,
                              border:
                                  Border.all(width: 0.2, color: Colors.grey)),
                          child: TextFormField(
                            autofocus: false,
                            controller: loginEmailController,
                            cursorColor: Colors.grey,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              icon: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: const Icon(
                                  Icons.phone,
                                  color: Colors.black38,
                                  size: 17,
                                ),
                              ),
                              hintText: 'Email',
                              hintStyle: TextStyle(fontSize: 14),
                              //labelText: 'Enter E-mail',
                              contentPadding:
                                  EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 13.0),
                              border: InputBorder.none,
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Field is empty' : null,
                            onSaved: (val) => loginEmail = val,
                            //validator: _validateEmail,
                          ),
                        ),

                        ////////////////////////   log in phone end //////////////////

                        SizedBox(
                          height: 2,
                        ),
                        ////////////////////////   log in password start //////////////////

                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.white,
                              border:
                                  Border.all(width: 0.2, color: Colors.grey)),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            autofocus: false,
                            obscureText: true,
                            controller: loginPasswordController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              icon: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: const Icon(
                                  Icons.lock,
                                  color: Colors.black38,
                                  size: 17,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(fontSize: 14),

                              //labelText: 'Enter E-mail',
                              contentPadding:
                                  EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 13.0),
                              border: InputBorder.none,
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Field is empty' : null,
                            onSaved: (val) => loginPass = val,
                            //validator: _validateEmail,
                          ),
                        ),

                        ////////////////////////   log in password end //////////////////

                        ////////////////////////   log in Button start //////////////////

                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _isLoading ? null : _logInButton();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 10,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                          color: appColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Text(
                                        _isLoading ? "Please wait..." : "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'BebasNeue',
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ////////////////////////   log in button end //////////////////

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ////////////////////////   skip login start //////////////////
                            // GestureDetector(
                            //   onTap: (){

                            //    Navigator.pop(context);
                            //   },
                            //                               child: Container(
                            //       margin: EdgeInsets.only(
                            //           left: 0, top: 15, bottom: 0),
                            //       child: Text(
                            //         "Skip",
                            //         style: TextStyle(
                            //             color: Colors.black54,
                            //             fontSize: 12,
                            //             fontWeight: FontWeight.w400),
                            //       )),
                            // ),

                            ////////////////////////   skip login  end //////////////////

                            ////////////////////////   forget password start //////////////////
                            //          GestureDetector(
                            //           onTap: (){

                            // //              Navigator.push(
                            // // context, SlideLeftRoute(page: VerifyEmail()));
                            //           },
                            //                                       child: Container(
                            //               margin: EdgeInsets.only(
                            //                   left: 0, top: 15, bottom: 0),
                            //               child: Text(
                            //                 "Forget password?",
                            //                 style: TextStyle(
                            //                     color: appColor,
                            //                     fontSize: 12,
                            //                     fontWeight: FontWeight.w400),
                            //               )),
                            //         ),
                          ],
                        ),

                        ////////////////////////   forget password end //////////////////
                      ],
                    ),
                  ),

                  ////////////////////////   Dont have account start //////////////////
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   padding: EdgeInsets.all(15),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(5)),
                  //   margin: EdgeInsets.only(top: 10, bottom: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Container(
                  //           child: Text(
                  //         "Don't have an account?",
                  //         style: TextStyle(
                  //             color: Colors.black54,
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.w300),
                  //       )),

                  //       ///////////   Sign up from log in start //////////////
                  //       GestureDetector(
                  //         onTap: () {
                  //           //Navigator.of(context).pop();

                  //     //         Navigator.push(
                  //     // context, SlideLeftRoute(page: Registration()));

                  //         },
                  //         child: Container(
                  //             margin: EdgeInsets.only(left: 5),
                  //             child: Text(
                  //               "Sign up",
                  //               style: TextStyle(
                  //                   color: appColor,
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w400),
                  //             )),
                  //       ),

                  //         ///////////   Sign up from log in end //////////////
                  //     ],
                  //   ),
                  // ),

                  ////////////////////////   Dont have account end //////////////////
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logInButton() async {
    if (loginEmailController.text.isEmpty) {
      return _showMsg("Email is empty");
    } else if (loginPasswordController.text.isEmpty) {
      return _showMsg("Password is empty");
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': loginEmailController.text,
      'password': loginPasswordController.text,
      // 'app_token':appToken
    };
    print(data);
    var res = await CallApi().postData(data, '/app/loginUser');
    print(res);
    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      localStorage.setString('user', json.encode(body['user']));

      Navigator.push(context, FadeRoute(page: HomePage()));
    } else {
      _showMsg("Invalid Email or Password");
    }

    setState(() {
      _isLoading = false;
    });
  }
}
