//import 'package:tvf_legion/registrationPage.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/James/Desktop/DetailBooking/Booking-Detail/tvf_legion/lib/Login&SignUp/phoneNumber.dart';

class Registration2 extends StatefulWidget {
  @override
  _Registration2State createState() => _Registration2State();
}

class _Registration2State extends State<Registration2> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    List gender = ["Male", "Female"];
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

    final userNameTextField = TextField(
        obscureText: false,
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
            ],
          ),
        ],
      ),
    );

    DateTime selectedDate = DateTime.now();
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    final dateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => _selectDate(context),
        child: Text("Select date",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
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
                      height: 100.0,
                      child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                    ),
                  SizedBox(height: 15.0),
                    userNameTextField,
                  SizedBox(width: double.infinity, height: 15.0),
                    genderRadioButton,
                  new Row(
                    children: <Widget>[
                      Flexible(
                        child: Text('Birth date:',
                          textAlign: TextAlign.left,
                          style: style.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        child: Text("${selectedDate.toLocal()}".split(' ')[0],
                            style: style.copyWith(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold))),
                    SizedBox(height: 20.0, width: 30),
                    Flexible(
                      child: dateButton,
                    ),
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
