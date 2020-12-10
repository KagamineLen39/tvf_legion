import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {

  header(){
    return Container(

      alignment: Alignment.center,
      margin: EdgeInsets.all(5),

      child: Text(
      "TVF Legion",
        style: TextStyle(
          fontSize:  25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  header2(){
    return Container(

      alignment: Alignment.center,
      margin: EdgeInsets.all(5),

      child: Text(
        "Our Team ",
        style: TextStyle(
          fontSize:  25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  header3(){
    return Container(

      alignment: Alignment.center,
      margin: EdgeInsets.all(5),

      child: Text(
        "The Idea",
        style: TextStyle(
          fontSize:  25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  header4(){
    return Container(

      alignment: Alignment.center,
      margin: EdgeInsets.all(5),

      child: Text(
        "Our Mission ",
        style: TextStyle(
          fontSize:  25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  header5(){
    return Container(

      alignment: Alignment.center,
      margin: EdgeInsets.all(5),

      child: Text(
        "Our Vision  ",
        style: TextStyle(
          fontSize:  25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  firstPara(){
    return Container(
      
      padding: EdgeInsets.all(5),
      child: Text(
        "TVF Legion is an app that focus on the social side of things. "
            "We made this app to encourages people to social, maintain the relationships and find new friends amongst many other users inside our app. ",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize:  16,
        ),
      ),
    );
  }


  secondPara(){
    return Container(

      padding: EdgeInsets.all(5),
      child: Text(
        "Our team that consists of 4 people, "
            "2 mainly focus on the coding part while the others focus on the documentation part of the application "
            "start of making this application at the final semester of our diploma studies. "
            "It took us 3 months to complete this application and are proud of what we had made. "
            "Our team focus on the usability of the application to socialize with other people "
            "and gain a unique experience using the application. ",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize:  16,
        ),
      ),
    );
  }

  thirdPara(){
    return Container(

      padding: EdgeInsets.all(5),
      child: Text(
        "When we first start to make the application, "
            "we had one thing in mind, it is to make a useful application for the people who is inside their houses bored with facing "
            "just the screen alone with no easier way to communicate with their friends. "
            "We decided to make an application focus on ease the communication with people. We design it as simple as possible and with the right number of functions for communication.  ",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize:  16,
        ),
      ),
    );
  }

  forthPara(){
    return Container(

      padding: EdgeInsets.all(5),
      child: Text(
        "When we first start to make the application, "
            "we had one thing in mind, it is to make a useful application for the people who is inside their houses bored with facing "
            "just the screen alone with no easier way to communicate with their friends. "
            "We decided to make an application focus on ease the communication with people. We design it as simple as possible and with the right number of functions for communication.  ",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize:  16,
        ),
      ),
    );
  }

  fifthPara(){
    return Container(

      padding: EdgeInsets.all(5),
      child: Text(
        "To ease the communication with each other  \n"
            "As communication becoming less of a convenience because of the pandemic,"
            " we aim to get a better way to communicate with people and maintain the strong connection between the people with the best user experiences. "
            "We are amateurs in creating the best socializing application out there, but we are improving day by day to achieve the goal for the people. ",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize:  16,
        ),
      ),
    );
  }

  contents() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          header(),
          firstPara(),
          header2(),
          secondPara(),
          header3(),
          thirdPara(),
          header4(),
          forthPara(),
          header5(),
          fifthPara(),

        ],
      ),
    );
  }

  space() {
    return SizedBox(
      height: 10,
    );
  }

  @override
  Widget build(BuildContext context) {

    final backButton = MaterialButton(
      height: 50,
      color: Colors.blue,

      child: Text(
        "Back",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.blue,
        title: Text(
          "About Us",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                contents(),
                Container(
                  margin: EdgeInsets.all(5),
                  alignment: Alignment.center,
                    child: backButton,
                ),
          ],
        )),
      ),
    );
  }
}
