import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/verificationPage.dart';

class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {

  final fKey = GlobalKey<FormState>();

  phoneSignUp(){
    if(fKey.currentState.validate()){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Verification()));
    }
  }


  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              child:SizedBox(
                height: 155.0,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            entryRow(),

            SizedBox(height: 10),

            enteredNumberButton(),
          ],
        ),
      ),
    );
  }

  entryRow() {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: phoneNumberLabel(),
          ),
          Flexible(
            child: numberTextBox(),
          ),
        ],
      ),
    );
  }

  phoneNumberLabel() {
    return Text(
      "Phone Number:",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /*dropDownButton(){
    return SizedBox(),
  }*/

  numberTextBox() {
    return Form(
      key: fKey,
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          counterText: "",
        ),

        style: TextStyle(
          fontSize: 24,
        ),
        validator:(val){
          return val.length<10? "Enter a valid phone number":null;
        },
        keyboardType: TextInputType.number,
        maxLength: 10,
      ),
    );
  }

  enteredNumberButton() {
    return SizedBox(
      height: 50,
      width: 400,
      child: RaisedButton(
        color: Color(0xff01A0C7),
        child: Text(
          "Next",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          phoneSignUp();
        },
      ),
    );
  }
}
