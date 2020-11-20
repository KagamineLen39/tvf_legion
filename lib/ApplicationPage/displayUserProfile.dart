
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Function%20Classes/AddorRemoveFriends.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';

// ignore: camel_case_types
class displayUserProfile extends StatefulWidget {
  final String userProfileId;
  displayUserProfile({this.userProfileId});

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
  String peerUsername,gender,peerEmail,doB,peerID;
  bool isFriend = false;
  bool requestSent;
  bool isLoading = false;
  String ownUserID,ownEmail,ownUserName;
  String buttonText;

  Map<String,String> ownMap;
  Map<String,String > addPeerMap;
  Map<String,String> retrieveUserMap;
  Map<String,String> retrievePeerMap;

  TextEditingController buttonTextController = new TextEditingController();
  friendSystem _fSystem = new friendSystem();
  QuerySnapshot requestChecker;

  @override
  void initState(){
    super.initState();
    getPeerDetails();
    getOwnDetail();
    checkRequest();
    nullChecker();
  }

  nullChecker(){
  if(buttonText == null && requestSent == null){
    setState(() {
      requestSent = false;
      isLoading = true;
    });
  }else{
    setState(() {
      isLoading = false;
    });
  }
  }

  checkRequest()async{
    String hasSent;

    requestChecker = await _fSystem.checkRequestSent(ownUserID, peerID);
    requestChecker.documents[0].data["peerID"].then((value){
      hasSent = value;

      if(hasSent != peerID){
        setState(() {
          requestSent = false;
          isLoading = false;
          buttonText = "Add";
        });
      }else{
        setState(() {
          requestSent = true;
          isLoading = true;
          buttonText = "Cancel Request";
        });
      }

    });
  }

  getPeerDetails() async{

    await databaseMethods.getUsername(widget.userProfileId).then((value){
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
        "email":peerEmail,
      };

    }
    );
  }

  getOwnDetail(){
    Helper.getUserId().then((value){
      setState(() {
        ownUserID = value;
      });
    });

    Helper.getUserEmail().then((value){
      setState(() {
        ownEmail = value;
      });
    });
    Helper.getUserName().then((value){
      setState(() {
        ownUserName = value;
      });
    });
  }

  addFriend() async{

    ownMap = {
      "userID" : ownUserID,
      "username": ownUserName,
      "email": ownEmail,
    };

    retrieveUserMap={
      "peerID": ownUserID,
      "peerUsername":ownUserName,
      "peerEmail": ownEmail,
    };

    setState(() {
      buttonText = "Cancel Request";
      requestSent = true;
    });

    _fSystem.sendFriendRequest(ownUserID,ownMap,peerID,addPeerMap);
    _fSystem.retrieveRequest(peerID, retrievePeerMap, ownUserID, retrieveUserMap);
  }

  cancelRequest(){
    setState(() {
      buttonText = "Add";
     requestSent = false;
    });

    _fSystem.cancelRequest(ownUserID,peerID);
  }

  buttonStateChange(){
    if(requestSent == true){
      setState(() {
        cancelRequest();
      });
    }else{
      setState(() {
        addFriend();
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    final addButton = GestureDetector(
      onTap: buttonStateChange,
      child: requestSent ?
      Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 75.0),
        height: 40,
        alignment: Alignment.center,
        decoration: buttonDeco.copyWith(
          color: Colors.lightBlue[300],
        ),
        child: isLoading?
        Container(
          child: SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white60),
            ),
          ),
        ):
        Text(
            buttonText,
          style: style,
          textAlign: TextAlign.center,
        ),
      ):
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 75.0),
            height: 40,
            alignment: Alignment.center,
            decoration: buttonDeco,
            child: isLoading?
            Container(
              child: SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white60),
                ),
              ),
            ):
            Text(
                buttonText,
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
    );

    final profilePic =CircleAvatar(
      radius: 80,
      backgroundImage: AssetImage(''),
    );

    final userNameBar =  Container(
      child: Text(
          "$peerUsername",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      )
    );

    final backButton = GestureDetector(
      child: Icon(Icons.arrow_back_ios,
            color: Colors.black38 ),
      onTap: (){
        Navigator.pop(context);
      },
    );


    final genderBar= Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
          leading:Icon(
            Icons.person,
          ),
          title: Text("$gender",
      ),
      ),
    );

    final emailBar= Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
          leading:Icon(
            Icons.mail,
          ),
          title: Text("$peerEmail",
      ),
      ),
    );

    final  birthDateBar = Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
          leading:Icon(
            Icons.cake,
          ),
          title: Text("$doB",
          )
      ),
    );

    return Scaffold(
      body:Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.fromLTRB(5, 35, 5, 0),
            children:<Widget>[
              Container(
                alignment: Alignment.topLeft,
                height: 15,
                child: backButton,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: profilePic,
              ),


              userNameBar,


              addButton,

              genderBar,
              emailBar,
              birthDateBar,

            ],
          )
      ),
    );
  }
}
