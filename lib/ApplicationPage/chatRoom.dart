

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String peerID,peerUsername;
  ChatRoom({this.peerID,this.peerUsername});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextStyle defaultStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
  TextEditingController messageController = new TextEditingController();

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
            Text(widget.peerID),
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
                            hintText: "Message...",
                            hintStyle: defaultStyle,
                            border: InputBorder.none,
                          ),
                        ),
                    ),
                    SizedBox(width: 5),

                    GestureDetector(
                      onTap: (){},
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
