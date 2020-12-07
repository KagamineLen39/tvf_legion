import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Function%20Classes/AddorRemoveFriends.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';

// ignore: camel_case_types
class displayUserProfile extends StatefulWidget {
  final String userName;
  final bool isFriend,requestSent,requestReceived;

  displayUserProfile({this.userName,this.isFriend,this.requestSent,this.requestReceived});

  @override
  _displayUserProfileState createState() => _displayUserProfileState();
}

// ignore: camel_case_types
class _displayUserProfileState extends State<displayUserProfile> {
  TextStyle style = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  BoxDecoration buttonDeco = BoxDecoration(
    borderRadius: BorderRadius.circular(45),
    color: Colors.lightBlue[500],
  );

  Database databaseMethods = new Database();
  QuerySnapshot userDetails;

  bool isFriend;
  bool requestSent;
  bool requestReceived ;
  bool isLoading = false;

  String peerUsername, gender, peerEmail, doB, peerID;
  String ownUserID, ownEmail, ownUserName;

  String buttonText = "Loading...";

  Map<String, String> ownMap;
  Map<String, String> addPeerMap;
  Map<String, String> retrieveUserMap;
  Map<String, String> retrievePeerMap;

  friendSystem _fSystem = new friendSystem();


  @override
  void initState(){
    super.initState();

    getPeerDetails();
    getOwnDetail();

    isFriend = widget.isFriend;
    requestSent = widget.requestSent;
    requestReceived = widget.requestSent;

  }




  getPeerDetails() async {
    await databaseMethods.getUsername(widget.userName).then((value) {
      userDetails = value;

      setState(() {
        peerUsername = userDetails.documents[0].data["username"];
        gender = userDetails.documents[0].data["gender"];
        peerID = userDetails.documents[0].data["userID"];
        peerEmail = userDetails.documents[0].data["email"];
        doB = userDetails.documents[0].data["Date of Birth"];
      });

      addPeerMap = {
        "peerID": peerID,
        "peerUsername": peerUsername,
        "peerEmail": peerEmail,
      };

      retrievePeerMap = {
        "userID": peerID,
        "username": peerUsername,
        "email": peerEmail,
      };
    });
  }

  getOwnDetail() {

    Helper.getUserId().then((value) {
      setState(()=>ownUserID = value);
    });

    Helper.getUserEmail().then((value) {
      setState(()=>ownEmail = value);
    });
    Helper.getUserName().then((value) {
      setState(()=>ownUserName = value);
    });
  }


  addFriend() {

    setState(() {
      ownMap = {
        "userID": ownUserID,
        "username": ownUserName,
        "email": ownEmail,
      };
    });

    setState(() {
      retrieveUserMap = {
        "peerID": ownUserID,
        "peerUsername": ownUserName,
        "peerEmail": ownEmail,
      };
    });

    setState(() {
      requestSent = true;
    });

    _fSystem.sendFriendRequest(ownUserID, ownMap, peerID, addPeerMap);
    _fSystem.retrieveRequest(peerID, retrievePeerMap, ownUserID, retrieveUserMap);
  }

  cancelRequest() {
    setState(() {
      requestSent = false;
    });

    _fSystem.cancelRequest(ownUserID, peerID);
  }


  acceptRequest(){

    setState(() {
      ownMap = {
        "userID": ownUserID,
        "username": ownUserName,
        "email": ownEmail,
      };
    });

    setState(() {
      retrieveUserMap = {
        "peerID": ownUserID,
        "peerUsername": ownUserName,
        "peerEmail": ownEmail,
      };
    });

    _fSystem.acceptRequest(ownUserID,ownMap,peerID,retrievePeerMap);
  }

  deleteRequest(){
    _fSystem.deleteRequest(ownUserID, peerID);

  }

  buttonStateChange() {
    if (requestSent == true) {
      cancelRequest();
    } else {
      addFriend();
    }
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

  @override
  Widget build(BuildContext context) {
    final removeFriendButton = GestureDetector(
        onTap: () {
          //removeFriend,
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 75.0),
          height: 40,
          alignment: Alignment.center,
          decoration: buttonDeco.copyWith(
            color: Colors.red,
          ),
          child: isLoading
              ? loadingContainer()
              : Text(
                  "Remove Friend",
                  style: style,
                  textAlign: TextAlign.center,
                ),
        ));

    final acceptDeleteRequest = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () {
              acceptRequest();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              height: 40,
              alignment: Alignment.center,
              decoration: buttonDeco,
              child: Text(
                "Accept",
                style: style,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              deleteRequest();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              height: 40,
              alignment: Alignment.center,
              decoration: buttonDeco.copyWith(
                color: Colors.red,
              ),
              child: Text(
                "Delete",
                style: style,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );

    final addButton = GestureDetector(
      onTap: buttonStateChange,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 75.0),
        height: 40,
        alignment: Alignment.center,
        decoration: requestSent
            ? buttonDeco.copyWith(
                color: Colors.lightBlue[400],
              )
            : buttonDeco,
        child: requestSent
            ? Text(
                "Cancel Request",
                style: style,
                textAlign: TextAlign.center,
            ): Text(
                "Add",
                style: style,
                textAlign: TextAlign.center,
              ),
      ),
    );

    final profilePic = CircleAvatar(
      radius: 80,
      //TODO
      //getFromUserProfile
      backgroundImage: AssetImage('assets/images/profilePic.png'),
    );

    final userNameBar = Container(
        child: Text(
      "$peerUsername",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ));

    final backButton = GestureDetector(
      child: Icon(Icons.arrow_back_ios, color: Colors.black38),
      onTap: () {
        Navigator.pop(context);
      },
    );

    final genderBar = Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
        leading: Icon(
          Icons.person,
        ),
        title: Text(
          "$gender",
        ),
      ),
    );

    final emailBar = Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
        leading: Icon(
          Icons.mail,
        ),
        title: Text(
          "$peerEmail",
        ),
      ),
    );

    final birthDateBar = Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
          leading: Icon(
            Icons.cake,
          ),
          title: Text(
            "$doB",
          )),
    );

    profileCheck() {
      if (isFriend == true) {
        return removeFriendButton;
      } else {
        if (requestReceived == true) {
          return acceptDeleteRequest;
        } else {
          return addButton;
        }
      }
    }

    return Scaffold(
      body: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.fromLTRB(5, 35, 5, 0),
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                height: 20,
                child: backButton,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: profilePic,
              ),
              userNameBar,
              Container(
                child: profileCheck(),
              ),
              genderBar,
              emailBar,
              birthDateBar,

            ],
          )),
    );
  }
}
