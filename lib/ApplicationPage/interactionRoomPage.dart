import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tvf_legion/ApplicationPage/displayRoom.dart';
import 'package:tvf_legion/Function%20Classes/roomManagement.dart';
import 'package:tvf_legion/Function%20Classes/roomMessaging.dart';
import 'package:tvf_legion/modal/user.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';

class InteractingRoomPage extends StatefulWidget {
  final String userName, roomId;
  final bool isMember,requestInviteSent;
  final String roomName;

  InteractingRoomPage({Key key, @required this.roomName,this.userName,this.roomId,this.isMember,this.requestInviteSent}): super(key: key);
  @override
  _InteractingRoomPage createState() => _InteractingRoomPage();
}

class _InteractingRoomPage extends State<InteractingRoomPage>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextStyle defaultStyle = TextStyle(fontSize: 14, color: Colors.white,);
  TextEditingController messageController = new TextEditingController();
  final String checkState = "Public";

  Map<String,dynamic> roomInfo;

  roomMessage _roomMessage = new roomMessage();

  bool isLoading = false;
  TextEditingController searchEditingController = new TextEditingController();
  RoomManagement roomService = new RoomManagement();
  Database databaseMethods = new Database();
  QuerySnapshot searchResultSnapshot;
  QuerySnapshot memberSnapshotDetails;
  QuerySnapshot displayMemberResult;
  bool hasRoomSearched = false;

  bool isMember = false;
  bool requestInviteReceived = false;
  bool requestInviteSent = false;

  String memberUsername, memberEmail, memberID;
  String ownUserID, ownEmail, ownUserName;

  Map<String, String> ownMap;
  Map<String, String> memberMap;
  Map<String, String> retrieveUserMap;
  Map<String, String> retrieveMemberMap;

  List<User> memberDetails = new List<User>();

  bool hasFriends = false;
  bool hasRequest=false;
  bool roomPage = false;
  int index =0;

  bool isFriend = false;
  bool requestReceived = false;
  bool requestSent = false;

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

              if(ownUserName == snapshot.data.documents[index].data["sendBy"]){
                meSend = true;
              }else{
                meSend = false;
              }

              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendBy:  snapshot.data.documents[index].data["sendBy"],
                sendByMe: meSend,
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": ownUserName,
        "message": messageController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      _roomMessage.addMessage(widget.roomId, chatMessageMap);

      setState(() {
        messageController.text = "";
      });
    }
  }

  final List<String> chatPageOptions = ["Room Chats","Members"];
  getOwnDetail() {
    Helper.getUserId().then((value) {
      setState(() {
        ownUserID = value;
      });
    });

    Helper.getUserEmail().then((value) {
      setState(() {
        ownEmail = value;
      });
    });
    Helper.getUserName().then((value) {
      setState(() {
        ownUserName = value;
      });
    });
  }

  getMemberDetails() async {
    await databaseMethods.getUsername(widget.userName).then((value) {
      memberSnapshotDetails = value;

      setState(() {
        memberUsername = memberSnapshotDetails.documents[0].data["username"];
        memberID = memberSnapshotDetails.documents[0].data["userID"];
        memberEmail = memberSnapshotDetails.documents[0].data["email"];

      });

      memberMap = {
        "MemberID": memberID,
        "MemberUsername": memberUsername,
        "MemberEmail": memberEmail,
      };

      retrieveMemberMap = {
        "OwnerID": memberID,
        "OwnerUsername": memberUsername,
        "OwnerEmail": memberEmail,
      };
    });
  }
  memberDisplay() async {

    memberDetails = await roomService.displayMemberDetailed(widget.roomId);

  }


  acceptInviteRequest(){

    setState(() {
      ownMap = {
        "OwnerID": ownUserID,
        "OwnerUsername": ownUserName,
        "OwnerEmail": ownEmail,
      };
    });

    setState(() {
      retrieveUserMap = {
        "MemberID": ownUserID,
        "MemberUsername": ownUserName,
        "MemberEmail": ownEmail,
      };
    });

    roomService.acceptInviteRequest(ownUserID,ownMap,memberID,retrieveMemberMap, widget.roomId);
  }

  declineInviteRequest(){
    roomService.declineInviteRequest(ownUserID, memberID);

  }
  Widget memberList() {
    return ListView.builder(
        physics:
        const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: memberDetails.length,
        itemBuilder: (context, value) {
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: memberListBuilder(
              memberDetails[value].userId,
                memberDetails[value].userName,
                memberDetails[value].email,
            ),
          );
        });
  }

  Widget memberListBuilder(String id, String userName, String email) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            child: new Text(userName[0]),
          ),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black38, fontSize: 15),
              ),

              Text(
                email,
                style: TextStyle(color: Colors.black38, fontSize: 15),
              )
            ],
          ),
          Spacer(),
          SizedBox(
            width: 10,
          ),
          id == ownUserID?
          ownUserID == roomService.checkRoomOwner(widget.roomId)?
          GestureDetector(
            onTap: (){
              Alert(
                context: context,
                style: AlertStyle(
                    animationType: AnimationType.fromTop,
                    isCloseButton: false,
                    isOverlayTapDismiss: false,
                    descStyle: style,
                    animationDuration: Duration(milliseconds: 400),
                    alertBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    titleStyle: style
                ),
                type: AlertType.info,
                title: "But, you are the owner ?!??",
                desc: "You cannot leave this room, cause your the owner!!",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                    radius: BorderRadius.circular(30.0),
                  ),
                ],
              ).show();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Leave",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ):
          GestureDetector(
            onTap: (){
              Alert(
                context: context,
                style: AlertStyle(
                    animationType: AnimationType.fromTop,
                    isCloseButton: false,
                    isOverlayTapDismiss: false,
                    descStyle: style,
                    animationDuration: Duration(milliseconds: 400),
                    alertBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    titleStyle: style
                ),
                type: AlertType.info,
                title: "Leaving??",
                desc: "Are you sure you want to leave this room ${widget.roomName}??",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                    radius: BorderRadius.circular(30.0),
                  ),
                  DialogButton(
                    child: Text(
                      "Sure",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      //delete data and navigate to home page
                    },
                    color: Colors.green,
                    radius: BorderRadius.circular(30.0),
                  ),
                ],
              ).show();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Leave",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )
              : new Container(),
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    memberDisplay();
    memberList();
    getOwnDetail();

    roomInfo = {
      "chatRoomId": widget.roomId,
    };

    _roomMessage.addChatRoom(roomInfo,widget.roomId);

    _roomMessage.getChats(widget.roomId).then((val) {
      setState(() {
        chats = val;
      });
    });

    isMember = widget.isMember;
    requestInviteSent = widget.requestInviteSent;

  }
  @override
  Widget build(BuildContext context) {

    final roomName = Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      alignment: Alignment.center,
      height: 40,

        child: Row(

          children: [
            Expanded(
              child: Text("${widget.roomName}",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
          ],
        ),
    );


    pageChanger(){
      return Container(
        height: 75,
        color: Color(0xff42a5f5),
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
                      roomPage = false;
                    });
                  }else{
                    setState(() {
                      roomPage = true;
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
      return roomPage? Expanded(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                          Expanded(
                            child: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                  memberList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ):
      Expanded(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )
          ),
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [

                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 90),
                  child: chatMessages(),
                ),

                Container(
                  alignment:  Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,

                  child: Container(
                    height: 75,
                    padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff42a5f5),
                          const Color(0xff2196f3),
                        ],
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(45),
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

                ),

                // Container(
                //   child: SingleChildScrollView(child: fListStreamer()),
                // ),

      );

    }

    return Scaffold(
      backgroundColor: Color(0xff42a5f5),
      appBar: AppBar(
        title: roomName,
        backgroundColor: Colors.lightBlueAccent[300],
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DisplayRoomPage(
                            roomName: widget.roomName)));
            },
          )
        ],
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

class MessageTile extends StatelessWidget {
  final String message;
  final String sendBy;
  final bool sendByMe;

  MessageTile({@required this.message,@required this.sendBy, @required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              top: 0,
              bottom: 0,
              left: sendByMe ? 0 : 15,
              right: sendByMe ? 15 : 0),
          alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(sendBy,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              top: 4,
              bottom: 4,
              left: sendByMe ? 0 : 2,
              right: sendByMe ? 2 : 0),
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
                colors: sendByMe ?  [
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
        ),
      ],
    );
  }
}



