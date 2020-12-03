

<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
=======
>>>>>>> parent of d312a60... Update
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Function%20Classes/Messaging.dart';
import 'package:tvf_legion/services/helper.dart';

class ChatRoom extends StatefulWidget {
<<<<<<< HEAD
  final String peerID,peerUsername,chatRoomId;
  ChatRoom({this.peerID,this.peerUsername, this.chatRoomId});
=======
  final String peerID,peerUsername;
  ChatRoom({this.peerID,this.peerUsername});
>>>>>>> parent of d312a60... Update

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextStyle defaultStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
  TextEditingController messageController = new TextEditingController();

  String username,userID;

  Messaging _message = new Messaging();

  Stream<QuerySnapshot> chats;

  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: username == snapshot.data.documents[index].data["sendBy"],
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": username,
        "message": messageController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      _message.addMessage( widget.chatRoomId, chatMessageMap);

      setState(() {
        messageController.text = "";
      });
    }
  }

  @override
  void initState() {
    getUserPreferences();
    _message.getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();

  }

  getUserPreferences(){
    Helper.getUserName().then((value){
      setState(() {
        username = value;
      });
    });
    Helper.getUserId().then((value){
      setState(() {
        userID = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peerUsername),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            chatMessages(),

            Container(
              alignment:  Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
              child: Container(
                height: 75,
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                color: Colors.grey,
                child: Row(
                  children: [
                    Expanded(
                        child:TextField(
                          controller: messageController,
                          style: defaultStyle,
                          decoration: InputDecoration(
<<<<<<< HEAD
                            hintText: "Message",
=======
                            hintText: "Message...",
>>>>>>> parent of d312a60... Update
                            hintStyle: defaultStyle,
                            border: InputBorder.none,
                          ),
                        ),
                    ),
                    SizedBox(width: 5),

                    GestureDetector(
<<<<<<< HEAD
                      onTap: (){
                        addMessage();
                      },
=======
                      onTap: (){},
>>>>>>> parent of d312a60... Update
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF),
                              ],
                            begin: FractionalOffset.topLeft,
                            end: FractionalOffset.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Text("Send",
                        style: defaultStyle,),
                      ),
                    )

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}