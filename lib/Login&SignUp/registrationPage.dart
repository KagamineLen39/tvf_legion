//import 'package:tvf_legion/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/loginPage.dart';
import 'file:///C:/Users/James/Desktop/DetailBooking/Booking-Detail/tvf_legion/lib/Login&SignUp/registrationNextPage.dart';
import 'package:tvf_legion/services/auth.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final fKey = GlobalKey<FormState>();

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cPasswordController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    final firstNameTextField = TextFormField(
      validator: (val){
        return val.isEmpty && val.length<3? "Invalid Entry": null;
      },
        obscureText: false,
        controller: firstNameController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "First Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        )
    );

    final lastNameTextField = TextFormField(
        validator: (val){
          return val.isEmpty && val.length<3? "Invalid Entry": null;
        },
        obscureText: false,
        controller: lastNameController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Last Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        )
    );


    final emailTextField = TextFormField(
        validator: (val){
          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter a proper email";
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

    final passwordTextField = TextFormField(
        validator:  (val){
          return val.length < 6 ? "Please re-enter password" : null;
        },
        obscureText: true,
        controller: passwordController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        )
    );

    final confirmPasswordTextField = TextFormField(
        validator:  (val){
          return val.length < 6? "Please re-enter password" : null;
        },
        obscureText: true,
        controller: cPasswordController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Confirm Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        )
    );

    bool isLoading = false;
    AuthMethods authMethods= new AuthMethods();

    signUp()async{
      if(fKey.currentState.validate()){
        setState(() {
          isLoading = true;
        });

        await authMethods.signUp(emailController.text, passwordController.text).then(
            (result){
              if(result!=null){
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => LoginPage()
                ));
              }
            });
      }
    }

    newSignUp(){
      if(fKey.currentState.validate()){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Registration2()));
      }
    }

    final nextButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          newSignUp();
        },
        child: Text("Next",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff01A0C7),
        title: Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: ListView(
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
            key:fKey,
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
