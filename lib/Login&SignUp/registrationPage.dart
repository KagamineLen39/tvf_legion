//import 'package:tvf_legion/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/registrationNextPage.dart';
import 'package:tvf_legion/services/auth.dart';
import 'package:tvf_legion/services/database.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final fKey = GlobalKey<FormState>();

  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  Database database = new Database();

  signUp() async {

    if (fKey.currentState.validate()) {

      Map<String, String> userInfoMap = {
        "fName" : firstNameController.text,
        "lName" : lastNameController.text,
        "email" : emailController.text,
      };

      setState(() {
        isLoading = true;
      });

      authMethods
          .signUp(emailController.text, passwordController.text)
          .then((result) {

            database.uploadUserInfo(userInfoMap);
            
        if (result != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Registration2(),
              ));
        }
      });
    }
  }

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cPasswordController = new TextEditingController();

  String nameValidate(String name) {
    String fNValidate =
        r"^[a-zA-Z']+$";
    String error;
    if (name.isEmpty) {
      error = "This field is required" ;
    } else if (name.isNotEmpty) {
      if (!RegExp(fNValidate).hasMatch(name))
        error = "Enter a valid name";
      else
        error = null;
    }
    return error;
  }

  String eValidate(String e) {
    String eValidate =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    String error;
    if (e.isEmpty) {
      error = "Email is required" ;
    } else if (e.isNotEmpty) {
      //if(check value from the database if is it a valid email) INSERT AUTHENTICATION HERE <------------------------ JAMES
      //error = "This email is already been used by the other user";
      //else
      if (!RegExp(eValidate).hasMatch(e))
        error = "Invalid email address";
      else
        error = null;
    }
    return error;
  }

  String pwdValidate(String p) {
    String passValidate = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String error;
    if (p.isEmpty) {
      error = "Password is required";
    } else if (p.isNotEmpty) {
        if (p.length<8)
          error = "This field must have at least 8 characters";
        else if (!RegExp(passValidate).hasMatch(p))
          error = "Must contain at least an uppercase, lowercase, number, special character";
        else
          error = null;
    }
    return error;
  }

  String checkMatchPassword(String cP){
    String error;
    if (cP.isEmpty){
      error = "Confirm Password is required";
    }
    else if(cP.isNotEmpty){
      if(cP !=passwordController.text){
        error = "Password is not match. Please re-enter";
      }
      return error;
    }
  }


  @override
  Widget build(BuildContext context) {
    final firstNameTextField = TextFormField(
        validator: (val) {
          return nameValidate(val);
        },
        obscureText: false,
        controller: firstNameController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "First Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final lastNameTextField = TextFormField(
        validator: (val) {
          return nameValidate(val);
        },
        obscureText: false,
        controller: lastNameController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Last Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final emailTextField = TextFormField(
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
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final passwordTextField = TextFormField(
        validator: (val) {
          return pwdValidate(val);
        },
        obscureText: true,
        controller: passwordController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final confirmPasswordTextField = TextFormField(
        validator: (val) {
          return checkMatchPassword(val);
        },
        obscureText: true,
        controller: cPasswordController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Confirm Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final nextButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          signUp();
        },
        child: Text("Next",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: isLoading
          ? AppBar(
              centerTitle: true,
              backgroundColor: Color(0xff01A0C7),
              title: Text(
                "Loading...",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )
          : AppBar(
              centerTitle: true,
              backgroundColor: Color(0xff01A0C7),
              title: Text(
                "Sign Up",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Form(
                  key: fKey,
                  child: Column(
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(width: 5.0, height: 30.0),
                          new Flexible(child: firstNameTextField),
                          SizedBox(width: 5.0, height: 30.0),
                          new Flexible(child: lastNameTextField),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      emailTextField,
                      SizedBox(height: 15.0),
                      passwordTextField,
                      SizedBox(height: 15.0),
                      confirmPasswordTextField,
                    ],
                  ),
                ),
                SizedBox(height: 25.0),
                nextButton,
              ],
            ),
    );
  }
}
