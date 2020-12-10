
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Function%20Classes/Messaging.dart';
import 'package:tvf_legion/services/helper.dart';

class ChatRoom extends StatefulWidget {
  final String peerID,peerUsername,chatRoomId;
  ChatRoom({this.peerID,this.peerUsername, this.chatRoomId});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextStyle defaultStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
  TextEditingController messageController = new TextEditingController();
  String ownUsername,userID;

  Messaging _message = new Messaging();

  Stream<QuerySnapshot> chats;

  Widget chatMessages(){
    bool meSend;

    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index){

              if(ownUsername == snapshot.data.documents[index].data["sendBy"]){
                meSend = true;
              }else{
                meSend = false;
              }

              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: meSend,
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": ownUsername,
        "message": messageController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      _message.addMessage(widget.chatRoomId, chatMessageMap);

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
        ownUsername = value;
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
        backgroundColor: Colors.lightBlueAccent[300],
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [

            Container(

              alignment: Alignment.topCenter,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 75),
              child: chatMessages(),
            ),

            Container(
              alignment:  Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
              child: Container(
                height: 75,
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xff42a5f5),
                      const Color(0xff2196f3),
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child:TextField(
                          controller: messageController,
                          style: defaultStyle,
                          decoration: InputDecoration(
                            hintText: "Message",
                            hintStyle: defaultStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                    ),
                    SizedBox(width: 5),

                    GestureDetector(
                      onTap: (){
                        addMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Text("Send",
                        style: defaultStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff42a5f5),
                        )
                        ),
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
          left: sendByMe ? 0 : 10,
          right: sendByMe ? 10 : 0),
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
              const Color(0xff42a5f5),
                const Color(0xff2196f3)]
                  :
              [const Color(0xff2196f3),
                const Color(0xff42a5f5)],
            ),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}