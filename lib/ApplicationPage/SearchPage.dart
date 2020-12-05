import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/interactionRoomPage.dart';
import 'package:tvf_legion/Function%20Classes/roomManagement.dart';
import 'package:tvf_legion/modal/room.dart';
import 'package:tvf_legion/services/helper.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  RoomManagement roomService = new RoomManagement();
  QuerySnapshot searchResultSnapshot;
  QuerySnapshot displayMemberResult;

  List<Room> room = new List();
  String ownUserID, ownEmail, ownUserName;
  final String checkState = "Public";
  bool isLoading = false;

  TextEditingController searchEditingController = new TextEditingController();
  int member = 0;
  int joinRoomPos = 0;
  bool hasRoomSearched = false;
  Map<String, String> ownMap;

  String filter;

  String name;
  String state;
  int maxPerson;


  initiateSearch() async {
   setState(() {
     isLoading = false;
     hasRoomSearched = false;
   });

    room = await roomService.searchRoomName(ownUserID);

    // if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
        hasRoomSearched = true;
      });
    print('${room[0].rName}');
        print('${room[1].rName}');
        print('${room[2].rName}');
        print('${room[3].rName}');
    // } else {
    //   setState(() {
    //     isLoading = false;
    //     hasRoomSearched = false;
    //   });
    // }
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
  memberDisplay() async{

    await roomService.displayMember().then((snapshot) {
      displayMemberResult = snapshot;

      setState(() {
        member = displayMemberResult.documents.length;
      });

    });
  }
  addMember(){
    ownMap = {
      "userID": ownUserID,
      "username": ownUserName,
      "email": ownEmail,
    };

    roomService.memberJoin(joinRoomPos, ownUserID, ownMap);

  }


  Widget roomList() {
    return hasRoomSearched
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: room.length,
        itemBuilder: (context, index) {
          print('$index');
          print('${room[index].rName}');

          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: roomListBuilder(
              room[index].rName,
              room[index].state,
              room[index].maxPerson,
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
    return filter == null || filter == ""
        ?Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            child: new Text(roomName[0]),
          ),
          SizedBox(width: 5),
          Expanded(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              roomName,
              maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black38, fontSize: 15),
              ),

              Text(
                (' $member / $maxPerson'),
                style: TextStyle(color: Colors.black38, fontSize: 15),
              )
            ],
          ),
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

                addMember();
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
    ) :
    roomName.toLowerCase().contains(filter.toLowerCase())
        ?Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            child: new Text(roomName[0]),
          ),
          SizedBox(width: 5),
          Expanded(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roomName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black38, fontSize: 15),
                ),

                Text(
                  (' $member / $maxPerson'),
                  style: TextStyle(color: Colors.black38, fontSize: 15),
                )
              ],
            ),
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

                addMember();
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
    ) : new Container();
  }
  @override
  void initState() {
    super.initState();
    getOwnDetail();
    initiateSearch();
    roomList();
    memberDisplay();

    searchEditingController.addListener(() {
      setState(() {
        filter = searchEditingController.text;
      });
    });
  }
  @override  void dispose() {
    searchEditingController.dispose();
    super.dispose();
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
          // SizedBox(
          //   child: Container(
          //     height: 45,
          //     width: 45,
          //     child: IconButton(
          //       icon: Icon(Icons.search, color: Colors.white),
          //       onPressed: initiateSearch,
          //     ),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(45),
          //       color: Colors.lightBlue[500],
          //     ),
          //   ),
          // ),
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
                searchBar,
                // FutureBuilder(
                //   future:initiateSearch(),
                //   builder:(context,snapshot){
                //     var key = snapshot.data.
                //     print('${room[0].rName}');
                //     print('${room[1].rName}');
                //     print('${room[2].rName}');
                //     print('${room[3].rName}');

                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
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
