import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:relative_scale/relative_scale.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tvf_legion/ApplicationPage/SearchPage.dart';
import 'package:tvf_legion/Function%20Classes/roomManagement.dart';
import 'package:tvf_legion/modal/room.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';

import 'interactionRoomPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Database databaseMethods = new Database();
  QuerySnapshot userDetails;
  RoomManagement roomService = new RoomManagement();
  Room roomData = new Room();

  Timer timer;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);


  int index = 0;
  int maxP = 1;
  int val = 0;

  List<int>member = new List();
  String state = "Public";
  String creator = "Creator";

  String ownUserID, ownEmail, ownUserName;
  String roomID;


  QuerySnapshot displayRoomResult;
  QuerySnapshot displayMemberResult;
  TextEditingController nameController;
  TextEditingController descriptionController;

  bool isEnabled = false;
  bool roomPage = false;


  final String checkState = "Public";

  final List<String> homePageOptions = ["Create/Popular", "Interaction "];

  Map<String, dynamic> roomInfoMap;
  Map<String, String> ownMap;

  getOwnDetail() {
    Helper.getUserId().then((value) {
      setState(() {
        ownUserID = value;
      });
    });

    Helper.getUserEmail().then((value) {
      setState(() {
        ownEmail = value;
      });
    });
    Helper.getUserName().then((value) {
      setState(() {
        ownUserName = value;
      });
    });
  }

  roomCreate() async {
    ownMap = {
      "userID": ownUserID,
      "username": ownUserName,
      "email": ownEmail,
    };
    roomData.roomId = roomService.getRoomId(ownUserID);
    roomData.rName = nameController.text.trim();
    roomData.rDescription = descriptionController.text;
    roomData.maxPerson = maxP;
    roomData.state = state;
    roomInfoMap = {
      "RoomID": roomData.roomId,
      "Name": roomData.rName,
      "Picture": roomData.rPic,
      "State": roomData.state,
      "Description": roomData.rDescription,
      "MaxPerson": maxP,
    };


   roomService.createOwnerRoomInfo(
        ownUserID, ownMap, roomData.roomId, roomInfoMap);

    Navigator.of(context).pop();
  }

  roomDisplay() async {
    await roomService.displayOwnerRoom(ownUserID).then((snapshot) {
      displayRoomResult = snapshot;

    });
    member = await roomService.displayOwnerRoomMember(ownUserID);
  }


  Widget roomListBuilder(String roomName, String state, int maxPerson, int member) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            child: new Text(roomName[0]),
          ),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                roomName,
                style: TextStyle(color: Colors.black38, fontSize: 20),
              ),

              Text(
                ('$member / $maxPerson'),
                style: TextStyle(color: Colors.black38, fontSize: 20),
              )
            ],
          ),
          Spacer(),
          SizedBox(
            width: 10,
          ),
          checkState != state ? Icon(Icons.lock):new Container(),
        ],
      ),
    );
  }

  @override
  void initState() {
    nameController = new TextEditingController();
    descriptionController = new TextEditingController();
    getOwnDetail();
    roomDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profilePic = CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage(''),
    );

    final welcomeLabel = Text("Welcome Back, $ownUserName",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontSize: 30.0,
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
      color: Colors.lightBlue[300],
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
                                              radius: 50,
                                              child: new Text("T"),
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Icon(Icons.add_circle)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(children: <Widget>[
                                    Text("State: ",
                                        style: style.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(width: 20),
                                    // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
                                    ToggleSwitch(
                                        minWidth: 90.0,
                                        cornerRadius: 20.0,
                                        initialLabelIndex: val,
                                        labels: ['Public', 'Private'],
                                        activeBgColors: [
                                          Colors.green,
                                          Colors.red
                                        ],
                                        onToggle: (index) {
                                          setState(() {
                                            val = index;

                                            if (index == 1) {
                                              isEnabled = true;
                                              state = "Private";
                                            } else {
                                              isEnabled = false;
                                              state = "Public";
                                            }
                                          });
                                        })
                                  ]),

                                  SizedBox(height: 20),
                                  Row(children: <Widget>[
                                    Text("Max person: ",
                                        style: style.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(width: 10),
                                    maxP != 1
                                        ? GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              width: 60,
                                              height: 60,
                                              child: Center(
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 20.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                if (maxP > 0) maxP--;
                                              });
                                            },
                                            onTapDown:
                                                (TapDownDetails details) {
                                              timer = Timer.periodic(
                                                  Duration(milliseconds: 100),
                                                  (t) {
                                                setState(() {
                                                  if (maxP > 0) maxP--;
                                                });
                                              });
                                            },
                                            onTapUp: (TapUpDetails details) {
                                              timer.cancel();
                                            },
                                            onTapCancel: () {
                                              timer.cancel();
                                            },
                                          )
                                        : SizedBox(width: 60),
                                    Container(),
                                    Text('$maxP',
                                        style: style.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            size: 20.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          maxP++;
                                        });
                                      },
                                      onTapDown: (TapDownDetails details) {
                                        timer = Timer.periodic(
                                            Duration(milliseconds: 100), (t) {
                                          setState(() {
                                            maxP++;
                                          });
                                        });
                                      },
                                      onTapUp: (TapUpDetails details) {
                                        timer.cancel();
                                      },
                                      onTapCancel: () {
                                        timer.cancel();
                                      },
                                    ),
                                  ]),
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
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          hintText: "Name",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      32.0)))),
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
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          hintText: "Description",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      32.0)))),
                                  SizedBox(height: 20),
                                  Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.lightBlue[400],
                                    child: MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      onPressed: () {
                                        roomCreate();
                                        nameController.clear();
                                        descriptionController.clear();
                                        val = 0;
                                        maxP = 1;
                                      },
                                      child: Text("Confirm",
                                          textAlign: TextAlign.center,
                                          style: style.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ])),
                      ),
                    ),
                  );
                });
              });
        },
        child: Icon(Icons.add,
        color: Colors.white,),
      ),
    );

    final searchField = Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      alignment: Alignment.center,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(45),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        },
        child: Row(
          children: [
            Expanded(
                child: TextField(
                    enabled: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Search for group to join",
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: Icon(Icons.search,
                      color: Colors.white
                      ),
                    ))),
          ],
        ),
      ),
    );

    final popularNameLabel = Text("Popular",
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
        ));

    pageChanger() {
      return Container(
        height: 75,
        color: Colors.lightBlue[200],
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: homePageOptions.length,
          itemBuilder: (BuildContext context, int _index) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    index = _index;
                  });

                  if (index == 0) {
                    setState(() {
                      roomPage = false;
                    });
                  } else {
                    setState(() {
                      roomPage = true;
                    });
                    roomDisplay();
                  }
                },
                child: RelativeBuilder(
                    builder: (context, screenHeight, screenWidth, sy, sx) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: sx(60), vertical: 25),
                    child: Text(
                      homePageOptions[_index],
                      style: style.copyWith(
                        color: _index == index ? Colors.white : Colors.white54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      );
    }

    refreshButton() {
      return Container(
        child: GestureDetector(
          child: Icon(Icons.refresh),
          onTap: () {

            roomDisplay();

          },
        ),
      );
    }

    contentPages() {
      return roomPage
          ? Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Room Chats",
                            style: style.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        refreshButton(),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            displayRoomResult.documents.length == 0
                                ? noRoomLabel
                                : Expanded(
                                    child: Container(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: displayRoomResult
                                                    .documents.length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    color: Colors.white,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 8),
                                                    child: InkWell(
                                                      onTap: () {

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    InteractingRoomPage(roomId:displayRoomResult
                                                                        .documents[index]
                                                                        .data["RoomID"],
                                                                        roomName: displayRoomResult
                                                                            .documents[index]
                                                                            .data["Name"],)));
                                                      },
                                                      child: roomListBuilder(
                                                        displayRoomResult
                                                            .documents[index]
                                                            .data["Name"],
                                                        displayRoomResult
                                                            .documents[index]
                                                            .data["State"],
                                                        displayRoomResult
                                                            .documents[index]
                                                            .data["MaxPerson"],
                                                        member[index]
                                                      ),
                                                    ),
                                                  );
                                                })
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Create Your Desired Room",
                        style: style.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(25),
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/discussion.jpg'),
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.dstATop),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            createRoomLabel,
                            SizedBox(width: 10, height: 100),
                            createButton,
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      popularNameLabel,
                    ],
                  ),
                ),
              ),
            );
    }

    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        title: searchField,
        backgroundColor: Colors.lightBlue[600],
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
            child: welcomeLabel,
          ),
          preferredSize: Size(0.0, 50.0),
        ),
      ),
      body: Container(
          color: Colors.lightBlue[200],
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                pageChanger(),
                contentPages(),
              ])),
    );
  }
}
