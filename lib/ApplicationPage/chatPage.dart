import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:tvf_legion/ApplicationPage/searchNewFriendPage.dart';
import 'package:tvf_legion/Function%20Classes/AddorRemoveFriends.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';

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

  bool isLoading = false;
  bool hasFriends = false;
  bool friendRequestPage = false;
  int index =0;
  String userID;

  final List<String> chatPageOptions = ["Chats","Friend Requests"];


  @override
  void initState(){
    super.initState();
    getUserPreferences();
  }

  getUserPreferences() async{
    Helper.getUserId().then((value){
      setState(()=>userID = value);
    });

    await _fSystem.getRequestList(userID).then((value){
      requestSnapshot = value;
    });
  }

  Widget userList(){
    return hasFriends?
    ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot.documents.length,
        itemBuilder: (context, index){
          return peerList(
            searchResultSnapshot.documents[index].data["username"],
            searchResultSnapshot.documents[index].data["email"],
          );
        }
    ):
        Container(
          child: Expanded(
              child: Text("No message yet",
                style: style.copyWith(
                  fontSize: 28,
                  color: Colors.white38,
                ),
          ),
          ),
        );
  }

  Widget peerList(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              //sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }

 /* Widget requestList(){
    return StreamBuilder<QuerySnapshot>(
      stream: _fSystem.getRequestList(userID),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
       if(!snapshot.hasData){
         return Text("There is no requests");
       }else{
         return new ListView(
           children: [
             ListView.builder(
             shrinkWrap: true,
             itemCount: requestSnapshot.documents.length,
             itemBuilder: (context, index){
               return getRequests(snapshot);
             }
             ),
           ]
         );
       }
      }
    );
  }

  getRequests(AsyncSnapshot<QuerySnapshot> snapshot){
    return snapshot.data.documents.map((val) => new ListTile(
      title: Text(val.data["peerUsername"]),
      subtitle: Text(val.data["peerEmail"]),
      )
    );
  }*/

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
         child: Column(
           children: <Widget>[
             Expanded(
               child: Text(
                 "Requests",
                 style: style.copyWith(
                   fontWeight: FontWeight.bold,
                   fontSize: 28,
                 ),
               ),
             ),
             Container(
               child: SingleChildScrollView(
                // child: requestList(),
               ),
               ),
           ],
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
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Expanded(
               child: Text(
                 "Recent",
                 style: style.copyWith(
                   fontWeight: FontWeight.bold,
                   fontSize: 28,
                 ),
               ),
             ),
             Container(
                 child: userList(),
               ),
           ],
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