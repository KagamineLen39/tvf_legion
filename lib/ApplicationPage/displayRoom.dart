import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tvf_legion/Function%20Classes/roomManagement.dart';
import 'package:tvf_legion/modal/room.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';

class DisplayRoomPage extends StatefulWidget {
  final int roomPosition;

  DisplayRoomPage({Key key, @required this.roomPosition}) : super(key: key);

  @override
  _DisplayRoomPage createState() => _DisplayRoomPage();
}

class _DisplayRoomPage extends State<DisplayRoomPage> {
  Database databaseMethods = new Database();
  QuerySnapshot userDetails;
  RoomManagement roomService = new RoomManagement();
  Room roomData = new Room();

  Timer timer;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String roomId;
  String password;
  int index = 0;
  int maxP = 1;
  int val = 0;
  String state = "Public";
  String creator = "Creator";

  String ownUserID, ownEmail, ownUserName;

  QuerySnapshot displayResult;

  TextEditingController nameController;
  TextEditingController passController;
  TextEditingController descriptionController;

  int stopToggleButtonPublic = 0;
  int stopToggleButtonPrivate = 1;
  bool isEditing = false;
  bool isEnabled = false;
  bool isPasswordEnabled = false;
  bool roomPage = false;
  bool hasRequest = false;
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

  updateRoom() async{
    ownMap = {
      "userID": ownUserID,
      "username": ownUserName,
      "email": ownEmail,
    };
    roomData.roomId = roomId;
    roomData.rName = nameController.text.trim();
    roomData.rDescription = descriptionController.text;
    roomData.maxPerson = maxP;
    roomData.state = state;

    if (state == "Public") {
      roomData.rPassword = null;
    } else {
      roomData.rPassword = passController.text;
    }

    roomInfoMap = {
      "RoomID": roomData.roomId,
      "Name": roomData.rName,
      "Password": roomData.rPassword,
      "Picture": roomData.rPic,
      "State": roomData.state,
      "Description": roomData.rDescription,
      "MaxPerson": maxP,
    };

    roomService.updateOwnerRoomInfo(
        ownUserID, ownMap, roomData.roomId, roomInfoMap);

    Navigator.of(context).pop();
  }

  roomDisplay() async {
    await roomService
        .displayOwnerRoomWithPosition(ownUserID, index)
        .then((snapshot) {
      displayResult = snapshot;

      setState(() {
        hasRequest = true;
        roomId = displayResult.documents[widget.roomPosition].data["RoomID"];
        nameController.text =
            displayResult.documents[widget.roomPosition].data["Name"];
        state = displayResult.documents[widget.roomPosition].data["State"];
        passController.text =
            displayResult.documents[widget.roomPosition].data["Password"];
        maxP = displayResult.documents[widget.roomPosition].data["MaxPerson"];
        descriptionController.text =
            displayResult.documents[widget.roomPosition].data["Description"];
        //rPic = displayResult.documents[widget.roomPosition].data["Name"];
        if (state == "Public") {
          val = 0;
          isEnabled = false;
        } else {
          val = 1;
          isEnabled = false;
        }
      });
    });
  }

  Widget roomDisplayInfo() {
    return Container(
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
                          color: Colors.black, fontWeight: FontWeight.bold)),
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
                        color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(width: 20),
                ToggleSwitch(
                    minWidth: 90.0,
                    cornerRadius: 20.0,
                    initialLabelIndex: val,
                    labels: ['Public', 'Private'],
                    activeBgColors: [Colors.green, Colors.red],
                    onToggle: (index) {
                      if(isEditing ==true) {
                        setState(() {
                          val = index;

                          if (index == 1) {
                            isPasswordEnabled = true;
                            state = "Private";
                          } else {
                            isPasswordEnabled = false;
                            state = "Public";
                          }
                        });
                      }

                    })
              ]),
              SizedBox(height: 20),
              Text("Password: ",
                  style: style.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextFormField(
                  enabled: isPasswordEnabled? true : false,
                  controller: passController,
                  style: style,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)))),
              SizedBox(height: 20),
              Row(children: <Widget>[
                Text("Max person: ",
                    style: style.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
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
                            if (isEnabled == true) {
                              if (maxP > 0) maxP--;
                            }
                          });
                        },
                        onTapDown: (TapDownDetails details) {
                          timer =
                              Timer.periodic(Duration(milliseconds: 100), (t) {
                            setState(() {
                              if (isEnabled == true) {
                                if (maxP > 0) maxP--;
                              }
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
                        color: Colors.black, fontWeight: FontWeight.bold)),
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
                      if (isEnabled == true) maxP++;
                    });
                  },
                  onTapDown: (TapDownDetails details) {
                    timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                      setState(() {
                        if (isEnabled == true) maxP++;
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
                      color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextFormField(
                  enabled: isEnabled ? true : false,
                  controller: nameController,
                  style: style,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)))),
              SizedBox(height: 20),
              Text("Description: ",
                  style: style.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                  maxLines: 8,
                  enabled: isEnabled ? true : false,
                  controller: descriptionController,
                  style: style,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)))),
              SizedBox(height: 20),
              isEditing
                  ? Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xff01A0C7),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () {
                          isEditing = false;
                          updateRoom();

                        },
                        child: Text("Confirm",
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  : Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.greenAccent,
                                child: MaterialButton(
                                  minWidth: 160,
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  onPressed: () {
                                    setState(() {
                                      isEnabled = true;
                                      isEditing = true;
                                    });
                                  },
                                  child: Text("Edit",
                                      textAlign: TextAlign.center,
                                      style: style.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(width: 20),
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color(0xff01A0C7),
                                child: MaterialButton(
                                  minWidth: 160,
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  onPressed: () {
                                    //message
                                  },
                                  child: Text("Message",
                                      textAlign: TextAlign.center,
                                      style: style.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.redAccent,
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () {
                                //leave
                              },
                              child: Text("Leave",
                                  textAlign: TextAlign.center,
                                  style: style.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    )
            ]),
      ),
    );
  }

  @override
  void initState() {
    nameController = new TextEditingController();
    passController = new TextEditingController();
    descriptionController = new TextEditingController();
    getOwnDetail();
    roomDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 25, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton,
                SizedBox(height: 5),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          roomDisplayInfo(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
