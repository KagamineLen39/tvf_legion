import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/ForgotPassword.dart';
import 'package:tvf_legion/Login&SignUp/homePage.dart';
import 'package:tvf_legion/Login&SignUp/registrationPage.dart';
import 'package:tvf_legion/services/auth.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  final fKey = GlobalKey<FormState>();

  Database _database = new Database();
  AuthMethods authMethods = new AuthMethods();
  bool isLoading = false;
  bool isLogin;
  QuerySnapshot snapshotUserInfo;

  loginCheck() async{

    if (fKey.currentState.validate()) {

      await authMethods.emailSignIn(loginEmailController.text, loginPasswordController.text).then((result)async {

        if(result != null) {
          isLogin = true;

          setState(() {
            isLoading=true;
          });

          snapshotUserInfo = await _database.getUserByUserEmail(loginEmailController.text);

          Helper.savedLoggedIn(true);
          Helper.savedUserName(snapshotUserInfo.documents[0].data["username"]);
          Helper.savedUserEmail(snapshotUserInfo.documents[0].data["email"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage())
          );
        }else{
          isLogin = false;
          setState(() {
            isLoading = false;
          });
        }

      });
    }
  }

  signUpClicked() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Registration()));
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

  String pwdValidate(String pass) {

    String error;
    if (pass.isEmpty) {
      error = "Password is required";
    } else if (pass.isNotEmpty) {
        if(isLogin == false){
          error ="Invalid email or password";
        }else
          error = null;
    }
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final emailTextField = TextFormField(
        validator: (v) {
          return eValidate(v);
        },
        obscureText: false,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final passwordTextField = TextFormField(
        controller: loginPasswordController,
        validator: (v) {
          return pwdValidate(v);
        },
        obscureText: true,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          loginCheck();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final forgetPasswordText = Text("Forgot Password",
        textAlign: TextAlign.right,
        style: style.copyWith(color: Colors.blue, fontWeight: FontWeight.bold));

    final registrationText = Text(
      "Don't have an account??",
      textAlign: TextAlign.center,
      style: style.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
    );

    final signUpText = Text(
      "Sign Up Now",
      textAlign: TextAlign.center,
      style: style.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
    );

    return Scaffold(
      appBar: isLoading
          ? AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff01A0C7),
        title: Text(
          "Loading...",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),)
          : AppBar(
        backgroundColor: Color(0xff01A0C7),
        centerTitle: true,
        title: Text(
          "Login",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body:isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),)
          :  ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          SizedBox(
            height: 150.0,
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            child: Form(
              key: fKey,
              child: Column(
                children: <Widget>[
                  emailTextField,
                  SizedBox(height: 10),
                  passwordTextField,
                ],
              ),
            ),
          ),
          SizedBox(
              width: double.infinity,
              height: 25.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                },
                child: forgetPasswordText,
              )),
          SizedBox(
            height: 15.0,
          ),
          loginButton,
          SizedBox(
            height: 15.0,
          ),
          registrationText,
          SizedBox(
            height: 25.0,
            child: GestureDetector(
              onTap: () {
                signUpClicked();
              },
              child: signUpText,
            ),
          ),
        ],
      ),
    );
  }
}
