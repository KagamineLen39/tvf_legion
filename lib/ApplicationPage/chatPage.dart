import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:tvf_legion/ApplicationPage/chatRoom.dart';
import 'package:tvf_legion/ApplicationPage/searchNewFriendPage.dart';
import 'package:tvf_legion/Function%20Classes/AddorRemoveFriends.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';

import 'displayUserProfile.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController searchController = new TextEditingController();
  Database databaseMethods = new Database();
  TextEditingController searchEditingController = new TextEditingController();
  friendSystem _fSystem = new friendSystem();
  QuerySnapshot searchResultSnapshot;
  QuerySnapshot requestSnapshot;
  QuerySnapshot friendListSnapshot;

  bool isLoading = false;
  bool hasFriends = false;
  bool hasRequest = false;
  bool friendRequestPage = false;
  int index = 0;
  String ownUserID, ownEmail, ownUsername;

  Map<String, String> ownMap;

  final List<String> chatPageOptions = ["Chats", "Friend Requests"];

  @override
  void initState() {
    super.initState();
    getUserPreferences();
    getRequestList();
  }

  //initializations
  getUserPreferences() async {
    Helper.getUserId().then((value) {
      setState(() => ownUserID = value);
    });
    Helper.getUserName().then((value) {
      setState(() => ownUsername = value);
    });
    Helper.getUserEmail().then((value) {
      setState(() => ownEmail = value);
    });

    ownMap = {
      "peerID": ownUserID,
      "peerUsername": ownUsername,
      "peerEmail": ownEmail,
    };
  }

  getFriendList() async {
    await _fSystem.getFriendList(ownUserID).then((val) {
      friendListSnapshot = val;
    });

    if (friendListSnapshot.documents.isEmpty) {
      setState(() {
        hasFriends = false;
      });
    } else {
      setState(() {
        hasFriends = true;
      });
    }
  }

  getRequestList() async {
    await _fSystem.getRequestList(ownUserID).then((val) {
      requestSnapshot = val;

      if (requestSnapshot.documents.isEmpty) {
        setState(() {
          hasRequest = false;
        });
      } else {
        setState(() {
          hasRequest = true;
        });
      }
    });
  }

  //Functions
  acceptRequest(peerID, peerMap) {
    _fSystem.acceptRequest(ownUserID, ownMap, peerID, peerMap);
  }

  deleteRequest(peerID) {
    _fSystem.deleteRequest(ownUserID, peerID);
  }

  Widget friendList() {
    return hasRequest
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: requestSnapshot.documents.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                  side: BorderSide(
                    color: Colors.black12,
                  ),
                ),
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: peerList(
                  friendListSnapshot.documents[index].data["peerUsername"],
                  friendListSnapshot.documents[index].data["peerEmail"],
                  friendListSnapshot.documents[index].data["peerID"],
                ),
              );
            })
        : Container(
            child: Expanded(
              child: Text(
                "No request",
                style: style.copyWith(
                  fontSize: 28,
                  color: Colors.white38,
                ),
              ),
            ),
          );
  }

  /*Widget friendList(){
    return StreamBuilder(
        stream: Firestore.instance.collection("friendSystem").document(ownUserID).collection("Friends").snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: Container(
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }else
          return ListView.builder(
                  shrinkWrap: true,
                  itemCount: friendListSnapshot.documents.length,
                  itemBuilder:(context, index){
                    return peerList(
                      friendListSnapshot.documents[index].data["peerUsername"],
                      friendListSnapshot.documents[index].data["peerEmail"],
                    );
                  },
              );
        },
    );
  }*/

  Widget peerList(String userName, String userEmail, String _peerID) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          viewUserProfile(userName),
          SizedBox(width: 5),
          Container(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(color: Colors.black38, fontSize: 16),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(color: Colors.black38, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatRoom(peerID: _peerID, peerUsername: userName),
                  ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.lightBlue[500],
                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  //Requests
  Widget requestList() {
    return hasRequest
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: requestSnapshot.documents.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                  side: BorderSide(
                    color: Colors.black12,
                  ),
                ),
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: userRequest(
                  requestSnapshot.documents[index].data["peerID"],
                  requestSnapshot.documents[index].data["peerUsername"],
                  requestSnapshot.documents[index].data["peerEmail"],
                ),
              );
            })
        : Container(
            child: Expanded(
              child: Text(
                "No request",
                style: style.copyWith(
                  fontSize: 28,
                  color: Colors.white38,
                ),
              ),
            ),
          );
  }

  Widget userRequest(String userID, String userName, String userEmail) {
    Map<String, String> peerMap = {
      "peerID": userID,
      "peerUsername": userName,
      "peerEmail": userEmail,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          viewUserProfile(userName),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  acceptRequest(userID, peerMap);
                  getRequestList();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(24)),
                  child: Text(
                    "Accept",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              GestureDetector(
                onTap: () {
                  deleteRequest(userID);
                  getRequestList();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(24)),
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  loadingContainer() {
    return Container(
      child: SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white60),
        ),
      ),
    );
  }

  viewUserProfile(userName) {
    return GestureDetector(
      child: CircleAvatar(
        radius: 30,
        //TODO
        //getUserProfilePic
        backgroundImage: AssetImage('assets/images/profilePic.png'),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    displayUserProfile(userProfileId: userName)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchNewFriend = Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      alignment: Alignment.center,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(45),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => searchNewFriendPage()));
        },
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Search New Friends",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: Icon(Icons.search),
            )
          ],
        ),
      ),
    );

    pageChanger() {
      return Container(
        height: 75,
        color: Colors.lightBlue[200],
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: chatPageOptions.length,
          itemBuilder: (BuildContext context, int _index) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    index = _index;
                  });

                  if (index == 0) {
                    setState(() {
                      friendRequestPage = false;
                    });
                  } else {
                    setState(() {
                      friendRequestPage = true;
                    });
                  }
                },
                child: RelativeBuilder(
                    builder: (context, screenHeight, screenWidth, sy, sx) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: sx(60), vertical: 25),
                    child: Text(
                      chatPageOptions[_index],
                      style: style.copyWith(
                        color: _index == index ? Colors.white : Colors.white54,
                        fontSize: 20,
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
            getRequestList();
            print(hasRequest);
            getFriendList();
          },
        ),
      );
    }

    contentPages() {
      return friendRequestPage
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
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Requests",
                              style: style.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                          refreshButton(),
                        ],
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: requestList(),
                        ),
                      ),
                    ],
                  ),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Recent",
                              style: style.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                          refreshButton(),
                        ],
                      ),
                      Container(
                        child: SingleChildScrollView(child: friendList()),
                      ),
                    ],
                  ),
                ),
              ),
            );
    }

    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        title: searchNewFriend,
        backgroundColor: Colors.lightBlue[600],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            pageChanger(),
            contentPages(),
          ],
        ),
      ),
    );
  }
}
