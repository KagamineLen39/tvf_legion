import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/SearchPage.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {

    final welcomeLabel = Text("Welcome, \nUsername",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
        ));

    final createRoomLabel = Text("Create a room",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ));

    final createButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text(
          "Create Group",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    final searchField = GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage())
          );
        },
        child: TextField(
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Search for group to join",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
            )));

    final roomNameLabel = Text("Rooms",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
        ));

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
          child: Column(

              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.blue],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.5, 0.0),
                      stops: [0.0, 1.0],


                    ),
                  ),
                  child: Column(

                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
                          child:welcomeLabel,
                        ),
                        
                      ]),
                ),
                Container(
                  height: 300.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/discussion.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.4), BlendMode.dstATop),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      createRoomLabel,
                      SizedBox(width: 10, height: 200),
                      createButton,
                    ],
                  ),
                ),
                SizedBox(height: 20),
                searchField,
                SizedBox(height: 20),
                roomNameLabel
              ])),
    );
  }
}
