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
  bool isLoading = false;
  bool hasUser;

  passReset()async{

    dynamic outcome = await authMethods.resetPassword(emailController.text.trimRight());

    if(outcome == 0){
      setState(() {
        hasUser = true;
      });
    }else{
      setState(() {
        hasUser = false;
      });
    }

    if(fKey.currentState.validate()){
      if(outcome == 0){
        setState(() {
          isLoading = false;
        });
      }else{
        setState(() {
          isLoading = true;
        });
        Navigator.pop(context);
      }
    }
  }

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
<<<<<<< HEAD
      body:isLoading? Container(
    child: Center(
      child: CircularProgressIndicator(),
    ),
    ):Center(
        child: new ListView(
        padding: EdgeInsets.all(30),
=======
      body:Center(
        child: new ListView(
          padding: EdgeInsets.all(30),
>>>>>>> parent of 88b2cac... HomePage

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

<<<<<<< HEAD
=======
  passReset()async{
    if(fKey.currentState.validate()){
      authMethods.resetPassword(emailController.text);

      setState(() {
        isLoading = true;
      });

      Navigator.pushReplacement(
        context,
          MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
>>>>>>> parent of 88b2cac... HomePage

  String eValidate(String e) {
    String eValidate =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    String error;
    if (e.isEmpty) {
      error = "Email is required" ;
    } else if (e.isNotEmpty) {
      if (!RegExp(eValidate).hasMatch(e)) {
        error = "Please enter a valid email address";
      }else{
        if(hasUser == true){
          error = "Invalid email. User not existing";
        }else
          error = null;
      }
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

<<<<<<< HEAD
/*Widget showAlert(){
    _error = authMethods.errors;

    if( _error != null){
      usedEmail = true;
      return Container(
        color: Colors.red,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: (){
                  setState(() {
                    _error = null;
                  });
                },
              ),
            ),
            Expanded(
              child: Text(_error,maxLines: 3,),
            ),
            Icon(Icons.error_outline),
          ],
        ),
      );
    }
  }*/

=======
>>>>>>> parent of 88b2cac... HomePage
}
