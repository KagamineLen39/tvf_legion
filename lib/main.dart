import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/chatPage.dart';
import 'package:tvf_legion/Login&SignUp/loginPage.dart';
import 'package:tvf_legion/services/helper.dart';


void main(){
  runApp(tvfLegion());
}

class tvfLegion extends StatefulWidget {
  @override
  _tvfLegionState createState() => _tvfLegionState();
}

class _tvfLegionState extends State<tvfLegion> {
  bool isLoggedIn;

  /*@override
  void initState(){
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    isLoggedIn = await Helper.getLogIn();
  }

  _isLoggedIn(){
    if(isLoggedIn != null){
      isLoggedIn? HomePage(): LoginPage();
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }

}
