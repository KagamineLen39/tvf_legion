import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/ForgotPassword.dart';
import 'package:tvf_legion/Login&SignUp/registrationPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final fKey = GlobalKey<FormState>();

  loginCheck(){
    if(fKey.currentState.validate()){

    }
  }

  signUpClicked(){
    Navigator.push(context,
        MaterialPageRoute(builder:(context)=> Registration()));
  }

  @override
  Widget build(BuildContext context) {
    final emailTextField = TextFormField(
        validator: (v){
          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(v) ? null:"Enter a valid email";
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
      validator: (v){
        return v.length<6 ?'Please enter a proper password' : null;
      },
        obscureText: true,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        )
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          loginCheck();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold
            )),
      ),
    );

    final forgetPasswordText = Text("Forgot Password",
        textAlign: TextAlign.right,
        style: style.copyWith(
            color: Colors.blue, fontWeight: FontWeight.bold
        )

    );

    final registrationText = Text("Don't have an account??",
      textAlign: TextAlign.center,
      style: style.copyWith(
          color: Colors.black, fontWeight: FontWeight.bold
      ),
    );

    final signUpText = Text("Sign Up Now",
      textAlign: TextAlign.center,
      style: style.copyWith(
          color: Colors.blue, fontWeight: FontWeight.bold
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff01A0C7),
        centerTitle: true,
        title: Text(
          "Enter Phone Number",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

        body: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            SizedBox(
              height: 155.0,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(
              child:Form(
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
                    Navigator.push(context,
                        MaterialPageRoute(builder:(context)=> ForgotPassword()));
                    },
                  child: forgetPasswordText,
                )
            ),

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

