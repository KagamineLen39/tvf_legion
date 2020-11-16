
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Function%20Classes/AddorRemoveFriends.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';

class displayUserProfile extends StatefulWidget {
  final String userProfileId;
  displayUserProfile({this.userProfileId});

  @override
  _displayUserProfileState createState() => _displayUserProfileState();
}

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
  String username,gender,email,doB;
  bool isFriend = false;
  bool requestSent = false;
  String ownUsername;

  Map<String, String> peerInfoMap;
  TextEditingController buttonTextController = new TextEditingController();
  friendSystem _fSystem = new friendSystem();

  @override
  void initState(){
    super.initState();
    getPeerDetails();
    getOwnDetail();
  }


  getPeerDetails() async{

    await databaseMethods.searchByUsername(widget.userProfileId).then((value){
      userDetails = value;

      setState(() {
        username = userDetails.documents[0].data["username"];
        gender = userDetails.documents[0].data["gender"];
        email = userDetails.documents[0].data["email"];
        doB = userDetails.documents[0].data["Date of Birth"];
      });

      peerInfoMap = {
        "peerUsername": username,
        "peerEmail": email,
      };
    }
    );
  }

  getOwnDetail(){
    Helper.getUserName().then((value){
      setState(() {
        ownUsername = value;
      });
    });
  }

  addFriend(){

    setState(() {
      requestSent = true;
    });

    _fSystem.sendFriendRequest(ownUsername, peerInfoMap);
  }

  cancelRequest(){

    setState(() {
      //_fSystem.cancelRequest(ownUsername,peerUsername);
    });
  }

  @override
  Widget build(BuildContext context) {

    final addButton = GestureDetector(
      onTap: addFriend,
      child: requestSent ?
      Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 75.0),
        height: 40,
        alignment: Alignment.center,
        decoration: buttonDeco.copyWith(
          color: Colors.lightBlue[300],
        ),
        child: Text(
            "Request Sent",
          style: style,
          textAlign: TextAlign.center,
        ),
      ):
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 75.0),
            height: 40,
            alignment: Alignment.center,
            decoration: buttonDeco,
            child: Text(
                "Add",
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
          "$username",
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
          title: Text("$email",
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
