import 'package:flutter/material.dart';
import 'package:tvf_legion/registrationPage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final emailTextField = TextField(
        obscureText: false,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        )
    );

    final passwordTextField = TextField(
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
        onPressed: () {},
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold
            )),
      ),
    );

    final forgetPasswordText = Text("Forget Password",
        textAlign: TextAlign.right,
        style: style.copyWith(
            color: Colors.blue, fontWeight: FontWeight.bold
        )

    );

    final registrationText = Text("Do not have an account??",
          textAlign: TextAlign.center,
          style: style.copyWith(
          color: Colors.black, fontWeight: FontWeight.bold
          ),
    );

    final signUpText = Text("Sign Up Now",
      textAlign: TextAlign.center,
        style: style.copyWith(
          color:Colors.blue, fontWeight: FontWeight.bold
        ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                emailTextField,
                SizedBox(height: 25.0),
                passwordTextField,
                SizedBox(
                  width: double.infinity,
                  height: 25.0,
                    child: GestureDetector(
                        onTap: (){print("Forget Password Page");},
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
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder:(context)=>Registration()));},
                    child: signUpText,
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

