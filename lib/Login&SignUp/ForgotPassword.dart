import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/loginPage.dart';
import 'package:tvf_legion/services/auth.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final fKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController emailController = new TextEditingController();
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff01A0C7),
        title: Text(
          "Password Reset",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body:Center(
        child: new ListView(
          padding: EdgeInsets.all(30),

          children: <Widget>[
            Logo(),

            spacing(),

            Form(
              key: fKey,
              child: emailEntry(),
            ),

            spacing(),

            passwordResetButton(),
          ],
        ),
      ),
    );
  }

  spacing(){
    return SizedBox(
      height: 20,
    );
  }

  Logo(){
    return SizedBox(
      height: 150,
      child: Image.asset(
        "assets/images/logo.png",
        fit: BoxFit.contain,
      ),
    );
  }

  passReset()async{
    if(fKey.currentState.validate()){
      authMethods.resetPassword(emailController.text);

      setState(() {
        isLoading = true;
      });

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  String eValidate(String e) {
    String eValidate =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    String error;
    if (e.isEmpty) {
      error = "Email is required" ;
    } else if (e.isNotEmpty) {
      if (!RegExp(eValidate).hasMatch(e))
        error = "Please enter a valid email address";
      else
        error = null;
    }
    return error;
  }

  emailEntry(){
    return  TextFormField(
        validator: (val) {
          return eValidate(val);
        },
        obscureText: false,
        controller: emailController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        )
    );
  }

  passwordResetButton(){
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          passReset();
        },
        child: Text("Request",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

}
