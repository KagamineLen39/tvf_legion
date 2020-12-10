import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/displayUserProfile.dart';
import 'package:tvf_legion/Function%20Classes/AddorRemoveFriends.dart';
import 'package:tvf_legion/services/helper.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  friendSystem _fSystem = new friendSystem();

  String ownUserID,ownEmail,ownUsername;
  String numFriends= "0";

  bool isLoading = false;
  bool hasFriends = false;
  bool hasRequest=false;

  bool isFriend = false;
  bool requestReceived = false;
  bool requestSent = false;

  QuerySnapshot friendCount;

  Widget fListStreamer(){
    return StreamBuilder(
        stream: Firestore.instance
            .collection("friendSystem")
            .document(ownUserID)
            .collection("Friends")
            .snapshots(),
        builder: (BuildContext context,AsyncSnapshot <QuerySnapshot> snapshot){
          numFriends = snapshot.data.documents.length.toString();
          return snapshot.data.documents.length == 0?
          Container(
            alignment: Alignment.center,
            child:Text("No friend",
              style: style.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),

          ):
          ListView.builder(
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder:(context,index){

                if(snapshot.data.documents[index].data != null){
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
                        snapshot.data.documents[index].data["username"],
                        snapshot.data.documents[index].data["email"],
                        snapshot.data.documents[index].data["userID"]
                    ),
                  );
                }else{
                  return Container(
                    margin: EdgeInsets.fromLTRB(0,20, 0, 20),
                    width: 50,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }

              });
        }
    );
  }

  @override
  void initState(){
    super.initState();
    getUserPreferences();
  }

  getUserPreferences() async{
    Helper.getUserId().then((value){
      setState(()=>ownUserID = value);
    });
    Helper.getUserName().then((value){
      setState(()=> ownUsername= value);
    });
    Helper.getUserEmail().then((value){
      setState(() => ownEmail =value);
    });

  }

  Widget peerList(String userName,String userEmail,String _peerID){
    try{
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            viewUserProfile(_peerID,userName),

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
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 16
                      ),
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 16
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }catch(e){
      print(e.toString());
    }
  }

  viewUserProfile(userID,username){

    _fSystem.requestSentChecker(ownUserID, userID)
        .then((val) {
      if (val.documents.isEmpty) {
        setState(() {
          requestSent = false;
        });
      } else {
        print(val.documents[0].data["peerID"]);
        setState(() {
          requestSent = true;
        });
      }
    });

    _fSystem.receivedRequestChecker(ownUserID, userID)
        .then((val) {
      if (val.documents.isEmpty) {
        setState(() {
          requestReceived = false;
        });
      } else {
        setState(() {
          requestReceived = true;
        });
      }
    });

    _fSystem.friendChecker(ownUserID, userID).then((val) {
      if (val.documents.isEmpty) {
        setState(() {
          isFriend = false;
        });
      } else {
        setState(() {
          isFriend = true;
        });
      }
    });

    return  GestureDetector(
      child: CircleAvatar(
        radius: 30,
        //TODO
        //getUserProfilePic
        backgroundImage: AssetImage('assets/images/profilePic.png'),
      ),
      onTap:(){
        print("$requestSent,$requestReceived,$isFriend");

        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> displayUserProfile(userName: username,isFriend: isFriend,requestReceived: requestReceived,requestSent: requestSent,))
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Friends"
        ),
      ),
      body:Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Text(
                "Friends: $numFriends",
                style: style.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),

            fListStreamer(),
          ],
        ),
      ),
    );
  }
}

