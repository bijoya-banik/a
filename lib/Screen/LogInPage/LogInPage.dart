
import 'package:bahrain_admin/Form/LogInForm/LogInForm.dart';
import 'package:flutter/material.dart';


class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: LogInForm(),
      
    );
  }
}