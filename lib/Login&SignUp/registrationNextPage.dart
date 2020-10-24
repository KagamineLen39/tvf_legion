import 'dart:async';
//import 'package:tvf_legion/registrationPage.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/phoneNumber.dart';

class Registration2 extends StatefulWidget {
  @override
  _Registration2State createState() => _Registration2State();
}

class _Registration2State extends State<Registration2> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final fKey = GlobalKey<FormState>();

  TextEditingController userNameController = new TextEditingController();

  DateTime selectedDate = DateTime.now();

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

  List gender = ["Male", "Female", "Prefer not to say"];
  String select;
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Gender:',
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              addRadioButton(0, 'Male'),
              addRadioButton(1, 'Female'),
              addRadioButton(2, 'Prefer not to say')
            ],
          ),
        ],
      ),
    );

    final dateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        //minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () =>_selectDate(context),
          child: Text("Select date",
          textAlign: TextAlign.center,
          style: style.copyWith(
          color: Colors.white, fontWeight: FontWeight.bold
          )
          )
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PhoneNumber()));
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

      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   SizedBox(
                  height: 300.0,
                       child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                  SizedBox(height: 15.0),
                    userNameTextField,
                  SizedBox(height: 15.0),
                    genderRadioButton,
                   new Row(
                     children: <Widget>[
                    SizedBox(height: 20.0, width: 20),
                    Text('Birth date:',
                          textAlign: TextAlign.left,
                          style: style.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    SizedBox(height: 20.0, width: 20),
                    Text("${selectedDate.toLocal()}".split(' ')[0],
                              style: style.copyWith(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold)),
                    SizedBox(height: 20.0, width: 20),
                    dateButton,
                ],
                ),
                   SizedBox(height: 15.0),
                     nextButton,
                ],
            )),
          ),
        ),
      ),
    );
  }
}
