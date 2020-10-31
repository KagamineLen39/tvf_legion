import 'dart:async';
//import 'package:tvf_legion/registrationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/phoneNumber.dart';
import 'package:tvf_legion/modal/user.dart';
import 'package:tvf_legion/services/database.dart';

class Registration2 extends StatefulWidget {
  @override
  _Registration2State createState() => _Registration2State();
}

class _Registration2State extends State<Registration2> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List gender = ["Male", "Female","Prefer not to say"];
  String select;
  User _user = User();

  TextEditingController userNameController = new TextEditingController();
  DateTime selectedDate = DateTime.now();

  final fKey = GlobalKey<FormState>();
  final db = Firestore.instance;
  Database database = new Database();
  /*DocumentSnapshot _currentDocument;*/

  signUpUpdate() async {

    Map<String, String> userInfoMap = {
      "fName": _user.fName,
      "lName": _user.lName,
      "email": _user.email,
      "username": _user.userName,
      "gender": _user.gender,
      "Date of Birth": _user.DoB,
    };

    if (fKey.currentState.validate()) {

      database.uploadUserInfo(userInfoMap);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneNumber(),
            ),
        );
    }
  }


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }


  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: Color(0xff01A0C7),
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title,
        style: TextStyle(
          fontSize:18,
          fontFamily: 'Montserrat',
        ),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {

    _user.userName = userNameController.text.trimRight();
    _user.gender = select;
    _user.DoB = "$selectedDate.toLocal()}".split(' ')[0];


    String nameValidate(String uName) {
      String nameValidate =
          r"^[a-zA-Z0-9']+$";
      String error;
      if (uName.isEmpty) {
        error = "This field is required" ;
      } else if (uName.isNotEmpty) {
        //if(check in the database if there is the same username)
        //error = "The username has been used by other user";
        if (!RegExp(nameValidate).hasMatch(uName))
          error = "Enter a valid name! Only numbers and alphabets";
        else
          error = null;
      }
      return error;
    }



    final userNameTextField = TextFormField(
        validator: (val) {
          return nameValidate(val);
        },
        obscureText: false,
        controller: userNameController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Username",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final genderRadioButton = Container(
      
      padding: EdgeInsets.fromLTRB(10,5,10,5),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text('Gender:',
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              addRadioButton(0, 'Male'),
              addRadioButton(1, 'Female'),
              addRadioButton(2, "Prefer not to say"),
            ],
          ),
        ],
      ),
    );

    final nextButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          signUpUpdate();
        },
        child: Text("Next",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff01A0C7),
        centerTitle: true,
        title: Text(
          "Profile",
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
        height: 150.0,
             child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.contain,
        ),
      ),

        Form(
          key: fKey,
          child: userNameTextField,
        ),

          SizedBox(height: 15.0),

          genderRadioButton,

          SizedBox(height: 15.0),

          birthdayRow(),

          SizedBox(height: 15.0),

          nextButton,
        ],
      ),
    );
  }


  birthdayRow(){
    return  Row(

      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: <Widget>[

        Text('Birth date:',
            textAlign: TextAlign.left,
            style: style.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold)),

        Text("${selectedDate.toLocal()}".split(' ')[0],
            style: style.copyWith(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold
            ),
        ),

        dateButton()
      ],
    );
  }

  dateButton(){
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () =>_selectDate(context),
          child: Text("Select date",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold
              ),
          ),
      ),
    );
  }

}
