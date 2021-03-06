import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/registrationNextPage.dart';
import 'package:tvf_legion/modal/user.dart';
import 'package:tvf_legion/services/auth.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final fKey = GlobalKey<FormState>();
  User userData = new User();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();

  //String _error;
  bool usedEmail;
  bool passVisible;

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cPasswordController = new TextEditingController();

  @override
  void initState() {
    passVisible = false;
  }

  signUp() async {
    dynamic result = await authMethods.signUp(
        emailController.text.trim(), passwordController.text);

    if (result == null) {
      setState(() {
        usedEmail = true;
      });
    } else {
      setState(() {
        usedEmail = false;
      });
    }

    if (fKey.currentState.validate()) {
      userData.userId = result.toString();
      userData.fName = firstNameController.text.trim();
      userData.lName = lastNameController.text.trim();
      userData.email = emailController.text.trim();

      if (result == null) {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = true;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Registration2(userData: userData),
            ));
      }
    }
  }

  String nameValidate(String name) {
    String fNValidate = r"^[a-zA-Z']+$";
    String error;
    if (name.isEmpty) {
      error = "This field is required";
    } else if (name.isNotEmpty) {
      if (!RegExp(fNValidate).hasMatch(name.trim()))
        error = "Enter a valid name";
      else
        error = null;
    }
    return error;
  }

  String eValidate(String e) {
    String eValidate =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    String error;
    if (e.isEmpty) {
      error = "Email is required";
    } else if (e.isNotEmpty) {
      if (!RegExp(eValidate).hasMatch(e.trim())) {
        error = "Invalid email address";
      } else {
        if (usedEmail == true) {
          error = "Email already in used";
        } else
          error = null;
      }
    }
    return error;
  }

  String pwdValidate(String p) {
    String passValidate =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String error;
    if (p.isEmpty) {
      error = "Password is required";
    } else if (p.isNotEmpty) {
      if (p.length < 8)
        error = "This field must have at least 8 characters";
      else if (!RegExp(passValidate).hasMatch(p.trim()))
        error =
            "Must contain at least an uppercase, lowercase, number, special character";
      else
        error = null;
    }
    return error;
  }

  String checkMatchPassword(String cP) {
    String error;
    if (cP.isEmpty) {
      error = "Confirm Password is required";
    } else if (cP.isNotEmpty) {
      if (cP != passwordController.text) {
        error = "Password is not match. Please re-enter";
      }
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstNameTextField = TextFormField(
        validator: (val) {
          return nameValidate(val);
        },
        obscureText: false,
        controller: firstNameController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "First Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final lastNameTextField = TextFormField(
        validator: (val) {
          return nameValidate(val);
        },
        obscureText: false,
        controller: lastNameController,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Last Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final emailTextField = TextFormField(
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
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final passwordTextField = TextFormField(
        validator: (val) {
          return pwdValidate(val);
        },
        obscureText: !passVisible,
        controller: passwordController,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          suffixIcon: IconButton(
            icon: Icon(
              passVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                passVisible = !passVisible;
              });
            },
          ),
        ));

    final passwordHint = Container(
      padding: EdgeInsets.all(10),
      child: Text(
        "Password minimum length must be 8 and must contain an uppercase,a lowercase, a number and a symbol",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.black38,
          fontSize: 13,
        ),
      ),
    );

    final confirmPasswordTextField = TextFormField(
        validator: (val) {
          return checkMatchPassword(val);
        },
        obscureText: !passVisible,
        controller: cPasswordController,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Confirm Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          suffixIcon: IconButton(
            icon: Icon(
              passVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                passVisible = !passVisible;
              });
            },
          ),
        ));

    final nextButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          signUp();
        },
        child: Text("Next",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: isLoading
          ? AppBar(
              centerTitle: true,
              backgroundColor: Color(0xff01A0C7),
              title: Text(
                "Loading...",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )
          : AppBar(
              centerTitle: true,
              backgroundColor: Color(0xff01A0C7),
              title: Text(
                "Sign Up",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView(
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
                  key: fKey,
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
                      passwordHint,
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
