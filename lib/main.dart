import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/navigationBar.dart';
import 'package:tvf_legion/Login&SignUp/loginPage.dart';
import 'package:tvf_legion/services/helper.dart';
import 'package:tvf_legion/services/pushNotification.dart';


void main(){
  runApp(TvfLegion());
}

class TvfLegion extends StatefulWidget {
  @override
  _TvfLegionState createState() => _TvfLegionState();
}

class _TvfLegionState extends State<TvfLegion> {
  bool isLoggedIn = false;
  PushNotificationService _noti = new PushNotificationService();

  @override
  void initState(){
    getLoggedInState();
    _noti.initialise();
    super.initState();
  }

  getLoggedInState() async{
    await Helper.getLogIn().then((value){
      setState(() {
        if(value == null){
          isLoggedIn = false;
          print("Is user logged in: $value");
        }else{
          print("Is user logged in: $value");
          isLoggedIn = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn? NavigationPage():LoginPage(),
    );
  }

}
