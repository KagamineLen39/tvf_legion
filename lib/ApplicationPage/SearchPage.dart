import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/interactionRoomPage.dart';
import 'package:tvf_legion/Function%20Classes/roomManagement.dart';
import 'package:tvf_legion/services/helper.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  RoomManagement databaseMethods = new RoomManagement();
  QuerySnapshot searchResultSnapshot;

  final String checkState = "Public";
  String ownUserID, ownEmail, ownUserName;
  bool isLoading = false;

  TextEditingController searchEditingController = new TextEditingController();

  bool hasRoomSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchRoomName(searchEditingController.text.trimRight())
          .then((snapshot) {
        searchResultSnapshot = snapshot;

        setState(() {
          isLoading = false;
          hasRoomSearched = true;
        });
      });
    } else {
      setState(() {
        isLoading = false;
        hasRoomSearched = false;
      });
    }
  }

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

  addMember(){

  }

  Widget roomList() {
    return hasRoomSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: roomListBuilder(
                  searchResultSnapshot.documents[index].data["Name"],
                  searchResultSnapshot.documents[index].data["State"],
                  searchResultSnapshot.documents[index].data["MaxPerson"],
                ),
              );
            })
        : Container(
            padding: EdgeInsets.all(25),
            child: Text(
              "Please enter a room ID",
              style: style.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
            ),
          );
  }

  Widget roomListBuilder(String roomName, String state, int maxPerson) {
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
                (' 1 / $maxPerson'),
                style: TextStyle(color: Colors.black38, fontSize: 20),
              )
            ],
          ),
          Spacer(),
          if (checkState != state) Icon(Icons.lock),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              //joinRoom(roomID);
              if(checkState == state){
                // Go to chatting page Firebase -from Room to Member
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => InteractingRoomPage()));

              }
              else{
                // pop up dialog ( show give invitation button) Firebase - from Room to joinRequest, acceptRequest then Member.
              }

            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.lightBlue[500],
                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Join",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    final searchLabel = TextField(
      controller: searchEditingController,
      cursorColor: Colors.white,
      style: style.copyWith(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search Room',
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final searchBar = Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: searchLabel,
          ),
          SizedBox(
            child: Container(
              height: 45,
              width: 45,
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: initiateSearch,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                color: Colors.lightBlue[500],
              ),
            ),
          ),
        ],
      ),
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
                          searchBar,
                          roomList(),
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
