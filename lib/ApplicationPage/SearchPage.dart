import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tvf_legion/ApplicationPage/interactionRoomPage.dart';
import 'package:tvf_legion/Function%20Classes/roomManagement.dart';
import 'package:tvf_legion/modal/room.dart';
import 'package:tvf_legion/modal/user.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';
import 'package:toast/toast.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Database databaseMethods = new Database();
  RoomManagement roomService = new RoomManagement();

  List<Room> room = new List();
  List<User> tempMemberList= new List<User>();
  int checkRequest;
  List<String> memberList = new List<String>();
  String memberUsername, memberEmail, memberID;
  String ownUserID, ownEmail, ownUserName;
  final String checkState = "Public";
  bool isOwner = false;
  bool isSent = false;
  bool isLoading = false;
  bool isMember = false;
  bool requestInviteSent = false;

  TextEditingController searchEditingController = new TextEditingController();
  List <int> member = new List();
  int joinRoomPos = 0;
  bool hasRoomSearched = false;
  bool checkMemberFound = true;
  Map<String, String> ownMap;
  Map<String, String> memberMap;
  Map<String, String> retrieveUserMap;

  String filter;
  String roomId;
  String name;
  String state;
  int maxPerson;

  initiateSearch() async {
   setState(() {
     isLoading = false;
     hasRoomSearched = false;
   });

    room = await roomService.searchRoomName();
    member = await roomService.displayMember();

      setState(() {
        isLoading = true;
        hasRoomSearched = true;
      });

  }

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

  addMember(String roomName) async {
    ownMap = {
      "userID": ownUserID,
      "username": ownUserName,
      "email": ownEmail,
    };
    room = await roomService.searchRoomName();

    for (int i = 0; i < room.length; i++) {
      setState(() {
        if (roomName == room[i].rName) {
          roomId = room[i].roomId;
        }
      });
    }
    roomService.memberJoin(ownUserID, ownMap, roomId);
  }


  Future<bool> checkMemberRoom(roomId) async {
    tempMemberList = await roomService.getListMember(roomId);

    for (int i = 0; i < tempMemberList.length; i++) {

        if (ownUserName == tempMemberList[i].userName) {
          return true;
        }
    }
    return false;
  }
  Future<bool> sendInviteRequestChecker(roomId) async{

    checkRequest = await roomService.requestInviteSentChecker(ownUserID, roomId);
    print('$checkRequest');
    if(checkRequest != 0) {
      return true;
    }
    return false;
}

  sendInvite(roomId){
    memberID = ownUserID;
    setState(() {
      retrieveUserMap = {
        "MemberID": ownUserID,
        "MemberUsername": ownUserName,
        "MemberEmail": ownEmail,

      };
    });
    setState(() {
      memberMap = {
        "MemberID": ownUserID,
        "MemberUsername": ownUserName,
        "MemberEmail": ownEmail,
      };
    });

    roomService.sendInviteRequest(roomId, memberID, memberMap);
    roomService.retrieveInviteRequest(memberID, memberMap, roomId);
  }

  cancelInvite(roomId) {

    roomService.cancelInviteRequest(roomId, memberID);
  }



  Widget roomList() {
    return hasRoomSearched
        ? ListView.builder(
        physics:
        const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: room.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: roomListBuilder(
              room[index].roomId,
              room[index].rName,
              room[index].state,
              room[index].maxPerson,
              member[index]
            ),
          );
        })
        : Container(
      padding: EdgeInsets.all(25),
      child: Text(
        "Please enter a room ID",
        style: style.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black38,
        ),
      ),
    );
  }
  Widget roomListBuilder(String roomId, String roomName, String state, int maxPerson, int member) {

    return filter == null || filter == ""
        ?Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            child: new Text(roomName[0]),
          ),
          SizedBox(width: 5),
          Expanded(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              roomName,
              maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black38, fontSize: 15),
              ),

              Text(
                (' $member / $maxPerson'),
                style: TextStyle(color: Colors.black38, fontSize: 15),
              )
            ],
          ),
          ),
          Spacer(),
          SizedBox(
            width: 10,
          ),
          checkState != state ? Icon(Icons.lock):new Container(),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {

              if (checkMemberFound == true && await checkMemberRoom(roomId)) {
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
                  title: "Member exist",
                  desc: "You are already exist and a member in $roomName room?? Do you want to start messaging with your roommates??",
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
                        "Message",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    InteractingRoomPage(roomId: roomId,
                                      roomName: roomName,)));
                      },
                      color: Colors.green,
                      radius: BorderRadius.circular(30.0),
                    ),
                  ],
                ).show();
              }
              else {
                if (maxPerson == member) {
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
                    title: "Whooops!!",
                    desc: "Oh NO!! This room $roomName is full!! Please come back next time if there's position for you",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.red,
                        radius: BorderRadius.circular(30.0),
                      ),
                    ],
                  ).show();
                }
                else {
                  if (checkState == state) {
                    // Go to chatting page Firebase -from Room to Member
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InteractingRoomPage(roomId: roomId,
                                  roomName: roomName,)));

                    addMember(roomName);
                  }
                  else {
                    // pop up dialog ( show give invitation button) Firebase - from Room to joinRequest, acceptRequest then Member.
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
                      title:await sendInviteRequestChecker(roomId)? "Cancel Invite??" : "Send Invite??",
                      desc: await sendInviteRequestChecker(roomId)?"Are you sure you want to cancel the invite" : "Do you want to send the invitation to the room $roomName's owner??",
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
                            await sendInviteRequestChecker(roomId)  ? "Cancel Request" : "Send",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () async{

                            //print('${await sendInviteRequestChecker(roomId)}');
                            isSent = await sendInviteRequestChecker(roomId);//true
                            if(isSent == false) {
                              sendInvite(roomId);
                              Toast.show("Sending Invite", context, duration:Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

                            }
                            else {
                              cancelInvite(roomId);
                              Toast.show("Canceling", context, duration:Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                            }

                            Navigator.pop(context);
                            // Navigator.push(context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         InteractingRoomPage(userName: ownUserName,
                            //             roomId: roomId,
                            //             requestInviteSent: requestInviteSent,
                            //             isMember: isMember),
                            //   ),);
                          },
                          color: Colors.green,
                          radius: BorderRadius.circular(30.0),
                        ),

                      ],

                    ).show();
                  }
                }
              }

            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.lightBlue[500],
                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                checkState == state ? "Join" : "Invite",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )
        ],
      ),
    ) :
    roomName.toLowerCase().contains(filter.toLowerCase())
        ?Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            child: new Text(roomName[0]),
          ),
          SizedBox(width: 5),
          Expanded(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roomName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black38, fontSize: 15),
                ),

                Text(
                  (' $member / $maxPerson'),
                  style: TextStyle(color: Colors.black38, fontSize: 15),
                )
              ],
            ),
          ),
          Spacer(),
          SizedBox(
            width: 10,
          ),
          checkState != state ? Icon(Icons.lock):new Container(),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {

              if (checkMemberFound == true && await checkMemberRoom(roomId)) {
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
                  title: "Member exist",
                  desc: "You are already exist and a member in $roomName room?? Do you want to start messaging with your roommates??",
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
                        "Message",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    InteractingRoomPage(roomId: roomId,
                                      roomName: roomName,)));
                      },
                      color: Colors.green,
                      radius: BorderRadius.circular(30.0),
                    ),
                  ],
                ).show();
              }
              else {
                if (maxPerson == member) {
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
                    title: "Whooops!!",
                    desc: "Oh NO!! This room $roomName is full!! Please come back next time if there's position for you",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.red,
                        radius: BorderRadius.circular(30.0),
                      ),
                    ],
                  ).show();
                }
                else {
                  if (checkState == state) {
                    // Go to chatting page Firebase -from Room to Member
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InteractingRoomPage(roomId: roomId,
                                  roomName: roomName,)));

                    addMember(roomName);
                  }
                  else {
                    // pop up dialog ( show give invitation button) Firebase - from Room to joinRequest, acceptRequest then Member.
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
                      title:await sendInviteRequestChecker(roomId)? "Cancel Invite??" : "Send Invite??",
                      desc: await sendInviteRequestChecker(roomId)?"Are you sure you want to cancel the invite" : "Do you want to send the invitation to the room $roomName's owner??",
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
                            await sendInviteRequestChecker(roomId)  ? "Cancel Request" : "Send",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () async{

                            //print('${await sendInviteRequestChecker(roomId)}');
                            isSent = await sendInviteRequestChecker(roomId);//true
                            if(isSent == false) {
                              sendInvite(roomId);
                              Toast.show("Sending Invite", context, duration:Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

                            }
                            else {
                              cancelInvite(roomId);
                              Toast.show("Canceling", context, duration:Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                            }

                            Navigator.pop(context);
                            // Navigator.push(context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         InteractingRoomPage(userName: ownUserName,
                            //             roomId: roomId,
                            //             requestInviteSent: requestInviteSent,
                            //             isMember: isMember),
                            //   ),);
                          },
                          color: Colors.green,
                          radius: BorderRadius.circular(30.0),
                        ),

                      ],

                    ).show();
                  }
                }
              }

            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.lightBlue[500],

                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                checkState == state ? "Join" : "Invite",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )
        ],
      ),
    ) : new Container();
  }
  @override
  void initState() {
    super.initState();
    getOwnDetail();
    initiateSearch();
    roomList();
    searchEditingController.addListener(() {
      setState(() {
        filter = searchEditingController.text;
      });
    });
  }
  @override  void dispose() {
    searchEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    final searchLabel = TextField(
      controller: searchEditingController,
      cursorColor: Colors.white,
      style: style.copyWith(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search Room',
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final searchBar = Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: searchLabel,
          ),
        ],
      ),
    );

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 25, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton,
                SizedBox(height: 5),
                searchBar,
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          roomList(),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            )),
      ),
    );
  }
}
