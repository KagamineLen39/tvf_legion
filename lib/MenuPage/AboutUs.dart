import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {

  title(){
    return Text("About Us");
  }

  contents(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("TVF_Legion "),
          Text("TVF_Legion is an app that focus on the social side of things. We made this app to encourages people to social, maintain the relationships and find new friends amongst many other users inside our app. ")
        ],
      ),
    );
  }

  space(){
    return SizedBox(
      height: 10,
    );
  }

  @override 
  Widget build(BuildContext context) {

    final backButton = IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.black26 ,
      ),
      onPressed: (){
        Navigator.pop(context);
      },
    );

    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 30, 10, 20),
        child: SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              backButton,
              title(),
              space(),
              contents(),
            ],
          )
        ),
      ),
    );
  }
}
