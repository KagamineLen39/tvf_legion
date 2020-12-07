import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/displayUserProfile.dart';
import 'package:tvf_legion/ApplicationPage/profilePage.dart';
import 'package:tvf_legion/Function%20Classes/AddorRemoveFriends.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';

// ignore: camel_case_types
class searchNewFriendPage extends StatefulWidget {
  @override
  _searchNewFriendPageState createState() => _searchNewFriendPageState();
}

// ignore: camel_case_types
class _searchNewFriendPageState extends State<searchNewFriendPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool isLoading = false;
  bool hasUserSearched = false;
  String ownUserName,ownUserID;
  String peerID;

  bool isFriend;
  bool requestReceived;
  bool requestSent;

  friendSystem _fSystem = new friendSystem();

  Database databaseMethods = new Database();
  QuerySnapshot searchResultSnapshot;
  TextEditingController searchEditingController = new TextEditingController();

  @override
  void initState(){
    super.initState();

    Helper.getUserName().then((value) {
      setState(() {
        ownUserName = value;
      });
    });

    Helper.getUserId().then((value){
      setState(() {
        ownUserID = value;
      });
    });

  }

  initiateSearch() async {

    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByUsername(searchEditingController.text.trimRight())
          .then((QuerySnapshot snapshot) {
        searchResultSnapshot = snapshot;
        print(snapshot);

        if (searchResultSnapshot.documents.isEmpty) {
          setState(() {
            isLoading = false;
            hasUserSearched = false;
          });
        } else {
          setState(() {
            isLoading = false;
            hasUserSearched = true;
          });
        }
      });
    } else {
      setState(() {
        isLoading = false;
        hasUserSearched = false;
      });
    }
  }

  Widget userList() {
    return hasUserSearched
        ? SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchResultSnapshot.documents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: peerList(
                          searchResultSnapshot.documents[index].data["userID"],
                        searchResultSnapshot.documents[index].data["username"],
                        searchResultSnapshot.documents[index].data["email"]
                      ),
                    );
                  }
                  ),
            ],
          ),
        )
        : Container(
            padding: EdgeInsets.all(25),
            child: Text(
              "No user found",
              style: style.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white60,
              ),
            ),
          );
  }

  checkSentRequest(peerID) async {
    bool _requestSent = false;

    if(_requestSent == false){
      _fSystem.requestSentChecker(ownUserID, peerID)
          .then((val) {
        if (val.documents.isEmpty) {
          setState(() {
            _requestSent = false;
          });
        } else {
          print(val.documents[0].data["peerID"]);
          setState(() {
            _requestSent = true;
          });
        }
      });
    }

    return _requestSent;
  }

  checkReceivedRequest(peerID) async {
    bool _requestReceived;

    if(_requestReceived == false){
      _fSystem.receivedRequestChecker(ownUserID, peerID)
          .then((val) {
        if (val.documents.isEmpty) {
          setState(() {
            _requestReceived = false;
          });
        } else {
          setState(() {
            _requestReceived = true;
          });
        }
      });
    }

    return _requestReceived;

  }

  checkFriend(peerID) async {
    bool _isFriend;

    if(_isFriend == false){
      _fSystem.friendChecker(ownUserID, peerID).then((val) {
        if (val.documents.isEmpty) {
          setState(() {
            _isFriend = false;
          });
        } else {
          setState(() {
            _isFriend = true;
          });
        }
      });
    }

    return _isFriend;
  }

  Widget peerList(String userID,String userName, String userEmail) {



    checkReceivedRequest(userID).then((value){
      setState(() {
        requestReceived = value;
      });
    });
    checkFriend(userID).then((value){
      setState(() {
        isFriend = value;
      });
    });
    checkSentRequest(userID).then((value){
      setState(() {
        requestSent = value;
      });
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            child: CircleAvatar(
              radius: 25,
              //TODO
              //getUserProfilePic
              backgroundImage: AssetImage('assets/images/profilePic.png'),
            ),
            onTap: () {
              print(peerID);

              if (userName == ownUserName) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            displayUserProfile(userName: userName,requestSent: requestSent,requestReceived: requestReceived,isFriend: isFriend),
                    ),
              );
              }
            },
          ),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.white70,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    final searchLabel = TextFormField(
      controller: searchEditingController,
      autofocus: true,
      cursorColor: Colors.white,
      style: style.copyWith(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: IconButton(
            icon: Icon(Icons.clear),
            color: Colors.white38,
            onPressed: () {
              searchEditingController.clear();
            }),
        hintText: 'Search User',
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
        color: Colors.lightBlue[500],
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 25, 10, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton,
                  SizedBox(height: 5),
                  Column(
                    children: <Widget>[
                      searchBar,
                      Container(
                        child: userList(),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
