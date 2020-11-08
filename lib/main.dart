import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:tvf_legion/ApplicationPage/homePage.dart';
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
  bool isLoggedIn = false;

  @override
  void initState(){
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await Helper.getLogIn().then((value){
      setState(() {
        isLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn? HomePage():LoginPage(),
    );
  }

}
=======
import 'package:tvf_legion/Login&SignUp/loginPage.dart';

void main() => runApp(MaterialApp(
      home: LoginPage(),
    ));
>>>>>>> parent of 88b2cac... HomePage
