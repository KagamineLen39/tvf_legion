import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //-------------------------------------App Bar---------------------------------------------------//
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff01A0C7),
        title: Text(
          "Verification",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white, //body color

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: OTPRow(),
          ),
        ],
      ),
    );
  }
}

class OTPRow extends StatefulWidget {
  @override
  _OTPRowState createState() => _OTPRowState();
}

class _OTPRowState extends State<OTPRow> {
  List<String> currentCode = ["", "", "", "", "", ""];

  TextEditingController code1Control = TextEditingController();
  TextEditingController code2Control = TextEditingController();
  TextEditingController code3Control = TextEditingController();
  TextEditingController code4Control = TextEditingController();
  TextEditingController code5Control = TextEditingController();
  TextEditingController code6Control = TextEditingController();

  var outlineInputBor = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.transparent),
  );

  int codeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: <Widget>[
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OTPText(),
            bottomRequest,
            buildOTPRow(),
            SizedBox(
              height: 10,
            ),
            buildButton(),
            buildNumpad(),
          ],
        )),
      ],
    ));
  }

  buildOTPRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        OTPNum(
          outlineInputBorder: outlineInputBor,
          textEditingController: code1Control,
        ),
        OTPNum(
          outlineInputBorder: outlineInputBor,
          textEditingController: code2Control,
        ),
        OTPNum(
          outlineInputBorder: outlineInputBor,
          textEditingController: code3Control,
        ),
        OTPNum(
          outlineInputBorder: outlineInputBor,
          textEditingController: code4Control,
        ),
        OTPNum(
          outlineInputBorder: outlineInputBor,
          textEditingController: code5Control,
        ),
        OTPNum(
          outlineInputBorder: outlineInputBor,
          textEditingController: code6Control,
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  OTPText() {
    return Text(
      "Enter OTP",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }


  //Update
  Padding bottomRequest = new Padding(
    padding: EdgeInsets.symmetric(vertical: 14),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Didn't receive code?",
          style: TextStyle(
              fontSize: 15, color: Colors.black26, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          width: 8,
        ),
        GestureDetector(
          //Apply Firebase Authenticator Codes Here afterward
          onTap: () {
            print("Resent the code to the user");
          },
          //Apply Firebase Authenticator Codes Here afterward

          child: Text(
            "Request Again",
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );

  codeIndexTransition(String text) {
    if (codeIndex == 0) {
      codeIndex = 1;
    } else if (codeIndex < 6) {
      codeIndex++;
    }

    setCode(codeIndex, text);
    currentCode[codeIndex - 1] = text;
    String strCode = "";
    currentCode.forEach((e) {
      strCode += e;
    });

    if (codeIndex == 6) {
      print(strCode);
    }
  }

  backspace() {
    if (codeIndex == 0) {
      codeIndex = 0;
    } else if (codeIndex == 6) {
      setCode(codeIndex, "");
      currentCode[codeIndex - 1] = "";
      codeIndex--;
    } else {
      setCode(codeIndex, "");
      currentCode[codeIndex - 1] = "";
      codeIndex--;
    }
  }

  setCode(int n, String text) {
    switch (n) {
      case 1:
        code1Control.text = text;
        break;
      case 2:
        code2Control.text = text;
        break;
      case 3:
        code3Control.text = text;
        break;
      case 4:
        code4Control.text = text;
        break;
      case 5:
        code5Control.text = text;
        break;
      case 6:
        code6Control.text = text;
        break;
    }
  }

  buildButton() {
    return SizedBox(
      width: 400,
      height: 50,
      child: RaisedButton(
        child: Text(
          "NEXT",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Color(0xff01A0C7),
        onPressed: () {},
      ),
    );
  }

  buildNumpad() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNum(
                    n: 1,
                    onPressed: () {
                      codeIndexTransition("1");
                    },
                  ),
                  KeyboardNum(
                    n: 2,
                    onPressed: () {
                      codeIndexTransition("2");
                    },
                  ),
                  KeyboardNum(
                    n: 3,
                    onPressed: () {
                      codeIndexTransition("3");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNum(
                    n: 4,
                    onPressed: () {
                      codeIndexTransition("4");
                    },
                  ),
                  KeyboardNum(
                    n: 5,
                    onPressed: () {
                      codeIndexTransition("5");
                    },
                  ),
                  KeyboardNum(
                    n: 6,
                    onPressed: () {
                      codeIndexTransition("6");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNum(
                    n: 7,
                    onPressed: () {
                      codeIndexTransition("7");
                    },
                  ),
                  KeyboardNum(
                    n: 8,
                    onPressed: () {
                      codeIndexTransition("8");
                    },
                  ),
                  KeyboardNum(
                    n: 9,
                    onPressed: () {
                      codeIndexTransition("9");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 60,
                      child: MaterialButton(
                        onPressed: null,
                        child: SizedBox(),
                      )),
                  KeyboardNum(
                    n: 0,
                    onPressed: () {
                      codeIndexTransition("0");
                    },
                  ),
                  Container(
                    width: 60,
                    child: MaterialButton(
                      height: 60,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      onPressed: () {
                        backspace();
                      },
                      child: Image(
                        image: NetworkImage(
                            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmaxcdn.icons8.com%2FShare%2Ficon%2Fwin8%2FArrows%2Fback1600.png&f=1&nofb=1'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KeyboardNum extends StatelessWidget {
  final int n;
  final Function() onPressed;

  KeyboardNum({this.n, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff01A0C7),
      ),
      alignment: Alignment.center,
      child: MaterialButton(
          padding: EdgeInsets.all(8),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          height: 90,
          child: Text("$n",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24 * MediaQuery.of(context).textScaleFactor,
                fontWeight: FontWeight.bold,
              ))),
    );
  }
}

class OTPNum extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;

  OTPNum({this.textEditingController, this.outlineInputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        /*keyboardType: TextInputType.number,
        maxLength: 1,*/
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          border: outlineInputBorder,
          filled: true,
          fillColor: Colors.black12,
          counterText: "",
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}
