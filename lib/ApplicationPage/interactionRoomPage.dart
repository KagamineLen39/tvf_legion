import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tvf_legion/ApplicationPage/displayRoom.dart';
import 'package:tvf_legion/Function%20Classes/roomManagement.dart';
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

            //chatMessages(),

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
                          hintText: "Message",
                          hintStyle: defaultStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),

                    GestureDetector(
                      onTap: (){
                        //addMessage();
                      },
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
                          //style: defaultStyle,
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
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        title: roomName,
        backgroundColor: Colors.lightBlue[600],
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



