
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/verificationPage.dart';

class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
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

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          entryRow(),

          SizedBox(height:10),

          enteredNumberButton(),

        ],
      ),
    );

  }

  entryRow(){
    return Row(
      children: <Widget>[
        Expanded(
          child: phoneNumberLabel(),
        ),
          Flexible(
            child:numberTextBox(),
          ),


      ],
    );
  }

  phoneNumberLabel(){
    return Text(
        "Phone Number:",
        style: TextStyle(
          fontSize:20,
          fontWeight: FontWeight.bold,
    ),
    );
  }

  /*dropDownButton(){
    return SizedBox(),
  }*/

  numberTextBox(){
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20, top: 10,bottom:10),
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

      keyboardType: TextInputType.number,
      maxLength: 10,

    );
  }

  enteredNumberButton(){

    return SizedBox(
        height:50,
        width:400,

        child:RaisedButton(
          color: Color(0xff01A0C7),
          child:Text(
            "Next",
            style: TextStyle(
              fontSize:24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed:(){
            Navigator.push(context,MaterialPageRoute(builder:(context)=>Verification()));
          },

        ),
    );
  }
}
