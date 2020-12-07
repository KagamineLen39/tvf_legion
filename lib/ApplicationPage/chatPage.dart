import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:tvf_legion/ApplicationPage/chatRoom.dart';
import 'package:tvf_legion/ApplicationPage/searchNewFriendPage.dart';
import 'package:tvf_legion/Function%20Classes/AddorRemoveFriends.dart';
import 'package:tvf_legion/Function%20Classes/Messaging.dart';
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

  Stream chatRooms;

  bool isLoading = false;
  bool hasFriends = false;
  bool hasRequest=false;
  bool friendRequestPage = false;
  int index =0;
  String ownUserID,ownEmail,ownUsername;

  bool isFriend;
  bool requestReceived;
  bool requestSent;

  Map<String,String> ownMap;
  Map <String,String> peerMap;
  Map<String, String> retrieveUserMap;
  Map<String, String> retrievePeerMap;

  final List<String> chatPageOptions = ["Chats","Friend Requests"];

  Widget fListStreamer(){
    return StreamBuilder(
      stream: Firestore.instance
          .collection("friendSystem")
          .document(ownUserID)
          .collection("Friends")
          .snapshots(),
      builder: (BuildContext context,AsyncSnapshot <QuerySnapshot> snapshot){
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
                return snapshot.data.documents[index].data["userID"] == null?
                Container():
                Card(
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
              });
        }
    );
  }

  Widget rListStreamer(){
    return StreamBuilder(
      stream: Firestore.instance
          .collection("friendSystem")
          .document(ownUserID)
          .collection("receivedRequests")
          .snapshots(),
      builder: (BuildContext context,AsyncSnapshot <QuerySnapshot> snapshot){
        if(snapshot.hasData){
          return snapshot.data.documents.length == 0?
              Container(
                  alignment: Alignment.center,
                  child:Text(
                    "No requests",
                    style: style.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
              ): ListView.builder(
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder:(context,index){
                return snapshot.data.documents[index].data["peerID"] == null?
                Container():
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45),
                    side: BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: userRequest(
                    snapshot.data.documents[index].data["peerID"],
                    snapshot.data.documents[index].data["peerUsername"],
                    snapshot.data.documents[index].data["peerEmail"],
                  ),
                );
              });
          }else{
          return Container(
            child:Text(
              "No requests"
            )
          );
        }
      },
    );
  }


  @override
  void initState(){
    super.initState();
    getUserPreferences();
  }

  sendMessage(String userName,String _peerID){
    List<String> users = [ownUsername,userName];

    String chatRoomID = getChatRoomId(ownUsername,userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomID,
    };

    Messaging().addChatRoom(chatRoom, chatRoomID);

    Navigator.push(
        context, MaterialPageRoute(
      builder: (context)=> ChatRoom(peerID: _peerID,peerUsername: userName,chatRoomId: chatRoomID),
    )
    );

  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
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



  //initializations
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

    setState(() {
      ownMap = {
        "peerID": ownUserID,
        "peerUsername": ownUsername,
        "peerEmail": ownEmail,
      };
    });
  }

  //Functions
  acceptRequest(peerID,peerMap){
    setState(() {
      ownMap = {
        "userID": ownUserID,
        "username": ownUsername,
        "email": ownEmail,
      };
    });

    setState(() {
      retrieveUserMap = {
        "peerID": ownUserID,
        "peerUsername": ownUsername,
        "peerEmail": ownEmail,
      };
    });
    _fSystem.acceptRequest(ownUserID, ownMap,peerID, peerMap);
  }

  deleteRequest(peerID){
    _fSystem.deleteRequest(ownUserID, peerID);
  }

  Widget peerList(String userName,String userEmail,String _peerID){

      return GestureDetector(
        onTap: (){
          sendMessage(userName, _peerID);
        },

        child: Container(
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
        ),
      );
    }

  //Requests
  Widget userRequest(String userID,String userName,String userEmail){

    peerMap = {
      "peerID": userID,
      "peerUsername": userName,
      "peerEmail": userEmail,
    };

    retrievePeerMap = {
      "userID": userID,
      "username": userName,
      "email": userEmail,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          viewUserProfile(userID,userName),

          Container(
            padding: EdgeInsets.all(10),
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16
                  ),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          
          Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    acceptRequest(userID, retrievePeerMap);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(24)
                    ),
                    child: Text("Accept",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),),
                  ),
                ),

                SizedBox(
                  height: 3,
                ),

                GestureDetector(
                  onTap: (){
                    deleteRequest(userID);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(24)
                    ),
                    child: Text("Delete",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),),
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  loadingContainer(){
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


  viewUserProfile(userID,username){

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

    return  GestureDetector(
      child: CircleAvatar(
        radius: 30,
        //TODO
        //getUserProfilePic
        backgroundImage: AssetImage('assets/images/profilePic.png'),
      ),
      onTap:(){

        print("Received: $requestReceived");
        print("Friend: $isFriend");
        print("Sent: $requestSent");

        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> displayUserProfile(userName: username,isFriend: isFriend,requestReceived: requestReceived,requestSent: requestSent,))
        );
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => searchNewFriendPage())
            );
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



    pageChanger(){
      return Container(
        height: 75,
        color: Colors.lightBlue[200],
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: chatPageOptions.length,
          itemBuilder: (BuildContext context,int _index){
              return Container(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      index = _index;
                    });

                    if(index == 0){
                      setState(() {
                        friendRequestPage = false;
                      });
                    }else{
                      setState(() {
                        friendRequestPage = true;
                      });
                    }
                  },
                  child: RelativeBuilder(
                    builder:(context,screenHeight,screenWidth,sy,sx){
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:sx(60),
                          vertical:25
                        ),
                        child: Text(chatPageOptions[_index],
                            style: style.copyWith(
                            color: _index == index? Colors.white: Colors.white54,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      );
                    }

                  ),
                ),
              );
          },

        ),
      );
    }

    contentPages(){
     return friendRequestPage? Expanded(
       child: Container(
         padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
         alignment: Alignment.topLeft,
         decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.only(
               topLeft: Radius.circular(30),
               topRight: Radius.circular(30),
             )
         ),
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
                 ],
               ),
               Container(
                 child: SingleChildScrollView(child: rListStreamer(),),
                 ),
             ],
           ),
         ),
       ),
     ):
     Expanded(
       child: Container(
         padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
         alignment: Alignment.topLeft,
         decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.only(
               topLeft: Radius.circular(30),
               topRight: Radius.circular(30),
             )
         ),
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
                 ],
               ),

               Container(
                 child: SingleChildScrollView(child: fListStreamer()),
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


