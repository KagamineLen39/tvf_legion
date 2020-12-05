import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Function%20Classes/roomManagement.dart';

class InteractingRoomPage extends StatefulWidget {
  @override
  _InteractingRoomPage createState() => _InteractingRoomPage();
}

class _InteractingRoomPage extends State<InteractingRoomPage>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final String checkState = "Public";
  bool isLoading = false;
  TextEditingController searchEditingController = new TextEditingController();
  RoomManagement databaseMethods = new RoomManagement();
  QuerySnapshot searchResultSnapshot;
  bool hasRoomSearched = false;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 25, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              ],
            )),
      ),
    );
  }
}
