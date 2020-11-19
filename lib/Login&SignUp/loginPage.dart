import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/navigationBar.dart';
import 'package:tvf_legion/Login&SignUp/ForgotPassword.dart';
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
  AuthMethods _auth = new AuthMethods();
  Database _database = new Database();
  bool isLoading = false;
  QuerySnapshot userInfoSnapshot;

  bool hasUser;
  String email='';
  String password = '';

  bool passVisible;
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  final fKey = GlobalKey<FormState>();
  @override
  void initState() {
    passVisible = false;
  }
  loginCheck()async{

    email = loginEmailController.text.trimRight();
    password = loginPasswordController.text;

    print(email + password);
    dynamic result = await _auth.emailSignIn(email, password);

    if(result == null){
      setState(() {
        hasUser = false;
      });
    }else{
      setState(() {
        hasUser = true;
      });
    }

    if (fKey.currentState.validate()){

      if(result == null){
        setState(() {
          isLoading = false;
        });
      }else{

        setState(() {
          isLoading = true;
        });

        userInfoSnapshot = await _database.getUserByUserEmail(email);

       Helper.savedLoggedIn(true);
       Helper.savedUserName(userInfoSnapshot.documents[0].data["username"]);
       Helper.savedUserEmail(userInfoSnapshot.documents[0].data["email"]);
       Helper.savedUserId(userInfoSnapshot.documents[0].data["userID"]);

       Helper.getLogIn().then((value){
         print("User logged in: $value");
       });
       Helper.getUserEmail().then((value) {
         print("Email: $value");
       });

       Helper.getUserName().then((value){
         print("Username: $value");
       });

       Helper.getUserId().then((value){
         print("User ID: $value");
       });


        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>NavigationPage())
        );
      }
    }
  }

  signUpClicked() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Registration()));
  }

  emailLoginValidator() {}

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

      if(hasUser == false){
        error="Invalid email or password";
      }else{
        error = null;
      }
    }

    return error;
  }

  @override
  Widget build(BuildContext context) {

    final emailTextField = TextFormField(
      controller: loginEmailController,
        validator: (v) {
          return eValidate(v);
        },
        obscureText: false,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        )
    );

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
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          suffixIcon: IconButton(
        icon: Icon(
        passVisible
        ? Icons.visibility
          : Icons.visibility_off,
          color: Theme.of(context).primaryColorDark,
        ),
      onPressed: () {
        setState(() {
          passVisible = !passVisible;
        });
      },
    ),
    ));

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
      appBar:isLoading
          ? AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff01A0C7),
        title: Text(
          "Loading...",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      )
          :  AppBar(
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

      body: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : ListView(
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
