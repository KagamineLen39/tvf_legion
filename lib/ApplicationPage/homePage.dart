import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/SearchPage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tvf_legion/services/database.dart';



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<String>room=[];
  int maxP = 0;
  int val = 0;

  TextEditingController nameController;
  TextEditingController passController;
  TextEditingController descriptionController;

  bool isEnabled = false;

  @override
  void initState(){
    nameController = new TextEditingController();
    super.initState();
  }
  void add(setState) {
    setState(() {
      maxP++;
    });
  }
  void minus(setState) {
    setState(() {
      if (maxP != 0)
        maxP--;
    });
  }
  @override
  Widget build(BuildContext context) {

    
    final profilePic =CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage(''),
    );

    final welcomeLabel = Text("Welcome, Username \nReady to make new friends :)",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ));

    final createRoomLabel = Text("Create a room",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ));


    final createButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (context, StateSetter setState) {
                      return Container(
                        child: Dialog(
                          child: SingleChildScrollView(
                            child: Padding(
                                padding: EdgeInsets.all(25.0),
                                child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text("Room Picture: ",
                                              style: style.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(width: 20),
                                          Stack(
                                            children: <Widget>[
                                          Container(
                                          child: CircleAvatar(

                                            radius:50,
                                            child: new Text("T"),
                                          ),
                                          ),
                                              Align(
                                                  alignment:Alignment.topRight,
                                                  child: Icon(Icons.add_circle)
                                              ),
                              ],
                                          ),
                                        ],

                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                          children: <Widget>[

                                            Text("State: ",
                                                style: style.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight
                                                        .bold)),
                                            SizedBox(width: 20),
                                            // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
                                            ToggleSwitch(
                                              minWidth: 90.0,
                                              cornerRadius: 20.0,
                                              initialLabelIndex: val,
                                              labels: ['Public', 'Private'],
                                              activeBgColors:[Colors.green, Colors.red],
                                              onToggle: (index) {
                                                setState(() {
                                                  val = index;

                                                  if (index == 1) {
                                                    isEnabled = true;
                                                  }
                                                  else {
                                                    isEnabled = false;
                                                  }
                                                });
                                              }
                                            )
                                          ]
                                      ),
                                      SizedBox(height: 20),
                                            Text("Password: ",
                                                style: style.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight
                                                        .bold)),
                                      SizedBox(height: 20),
                                      TextFormField(
                                          enabled: isEnabled?true:false,
                                          controller: passController,
                                          style: style,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets
                                                  .fromLTRB(
                                                  20.0, 15.0, 20.0, 15.0),
                                              hintText: "Password",
                                              border:
                                              OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(32.0)))),
                                      SizedBox(height: 20),
                                      Row(
                                          children: <Widget>[
                                            Text("Max person: ",
                                                style: style.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight
                                                        .bold)),
                                            SizedBox(width: 10),
                                            maxP != 0
                                                ? IconButton(
                                              onPressed: ()=> minus(setState),
                                              icon: Icon(Icons.remove,
                                                  color: Colors.black),)
                                                : SizedBox(width: 48), Container(),

                                            Text('$maxP', style: style.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                            IconButton(
                                              onPressed: ()=> add(setState),
                                              icon: Icon(Icons.add,
                                                  color: Colors.black),
                                            ),

                                          ]
                                      ),
                                      SizedBox(height: 20),
                                      Text("Room Name: ",
                                          style: style.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 20),
                                      TextFormField(
                                          controller: nameController,
                                          style: style,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets
                                                  .fromLTRB(
                                                  20.0, 15.0, 20.0, 15.0),
                                              hintText: "Name",
                                              border:
                                              OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(32.0)))),
                                      SizedBox(height: 20),
                                      Text("Description: ",
                                          style: style.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 20),
                                      TextField(
                                          maxLines: 8,
                                          controller: descriptionController,
                                          style: style,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets
                                                  .fromLTRB(
                                                  20.0, 15.0, 20.0, 15.0),
                                              hintText: "Description",
                                              border:
                                              OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(32.0)))),
                                      SizedBox(height: 20),
                                      Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(
                                            30.0),
                                        color: Color(0xff01A0C7),
                                        child: MaterialButton(
                                          minWidth: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          onPressed: () {
                                            setState(() {

                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text("Confirm",
                                              textAlign: TextAlign.center,
                                              style: style.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),

                                        ),
                                      ),

                                    ]
                                )
                            ),
                          ),
                        ),
                      );
                    });
              });
        },
          child:Icon(Icons.add),
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
    
    final noRoomLabel = Text("You have not yet join any room",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 15.0,
          color: Colors.grey,

        )
    );

    return Scaffold(
        body:Container(
      color: Colors.white,
      child: SingleChildScrollView(
          child: Column(

              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
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
                          child:Row(
                          children:<Widget>[
                            SizedBox(width:20),
                            //profilePic,
                            SizedBox(width:20),
                            welcomeLabel,

                          ],
                        ),

                        ),
                      ],
      ),
                ),
                SizedBox(height: 20),
                searchField,
                SizedBox(height: 20),
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
                roomNameLabel,

                Container(
                  height: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.max ,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      room.length == 0 ?
                      noRoomLabel:
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (_, index) => ListRoomItem(this.room[index]),
                        itemCount: this.room.length,
                      ),
                    ],
                  ),
                ),
              ])),
    ),
    );
  }
}
class ListRoomItem extends StatelessWidget{
  String roomName;

  ListRoomItem(this.roomName);
  @override
  Widget build(BuildContext context){
    return new Card(
      elevation: 7.0,
      child: new Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(25.0),
        child: new Row(
          children: <Widget>[
            new CircleAvatar(
              child: new Text(roomName[0]),
            ),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Text(roomName, style: TextStyle(fontSize: 25.0),)
          ],
        ),
      ),
    );
  }
}

