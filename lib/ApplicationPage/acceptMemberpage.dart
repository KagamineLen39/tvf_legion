import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/interactionRoomPage.dart';
import 'package:tvf_legion/Function%20Classes/roomManagement.dart';
import 'package:tvf_legion/modal/user.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';

class AddMemberPage extends StatefulWidget {
  final String roomName, roomId, userName, ownUserID;

  AddMemberPage({Key key, @required this.roomName, this.roomId, this.userName, this.ownUserID})
      : super(key: key);

  @override
  _AddMemberPage createState() => _AddMemberPage();
}

class _AddMemberPage extends State<AddMemberPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  RoomManagement roomService = new RoomManagement();
  Database databaseMethods = new Database();
  QuerySnapshot searchResultSnapshot;
  QuerySnapshot memberSnapshotDetails;
  QuerySnapshot displayMemberResult;

  String memberUsername, memberEmail, memberID;
  String ownUserID, ownEmail, ownUserName;

  Map<String, String> ownMap;
  Map<String, String> memberMap;
  Map<String, String> retrieveOwnerMap;
  Map<String, String> retrieveMemberMap;

  List<User> memberInviteDetails = new List<User>();

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

  getMemberInviteRequest() async {

    memberInviteDetails = await roomService.displayMemberInvite(widget.roomId, widget.ownUserID);


  }

  acceptInviteRequest(memberInviteId,  memberInviteUserName,  memberInviteEmail) {
    setState(() {
      retrieveOwnerMap = {
        "OwnerID": ownUserID,
        "OwnerUsername": ownUserName,
        "OwnerEmail": ownEmail,
      };
    });

    setState(() {
      retrieveMemberMap = {
        "MemberID": memberInviteId,
        "MemberUsername": memberInviteUserName,
        "MemberEmail": memberInviteEmail,
      };
    });

    setState(() {
      ownMap = {
        "userID": ownUserID,
        "username": ownUserName,
        "email": ownEmail,
      };
    });

    setState(() {
      memberMap = {
        "userID": memberInviteId,
        "username": memberInviteUserName,
        "email": memberInviteEmail,
      };
    });


    roomService.acceptInviteRequest(widget.ownUserID, retrieveOwnerMap, memberInviteId, retrieveMemberMap, widget.roomId, ownMap, memberMap);
  }

  declineInviteRequest(memberInviteId) {

    roomService.declineInviteRequest(widget.ownUserID, memberInviteId,widget.roomId );
  }

  deleteRequest(memberInviteId){

    roomService.deleteInvite(widget.ownUserID, memberInviteId,widget.roomId );
  }

  Widget memberRequestList() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: memberInviteDetails.length,
        itemBuilder: (context, value) {
          print('${memberInviteDetails.length}');
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: memberRequestListBuilder(
              memberInviteDetails[value].userId,
              memberInviteDetails[value].userName,
              memberInviteDetails[value].email,
            ),
          );
        });
  }

  Widget memberRequestListBuilder(String memberInviteId, String memberInviteUserName, String memberInviteEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            child: new Text(memberInviteUserName[0]),
          ),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                memberInviteUserName,
                style: TextStyle(color: Colors.black38, fontSize: 15),
              ),
              Text(
                memberInviteEmail,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black38, fontSize: 15),
              )
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  deleteRequest(memberInviteId);
                  acceptInviteRequest(memberInviteId,  memberInviteUserName,  memberInviteEmail);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.green, borderRadius: BorderRadius.circular(24)),
                  child: Text(
                    "Accept",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {

                  deleteRequest(memberInviteId);
                  declineInviteRequest(memberInviteId);
                  Navigator.pop(context);
  },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.red, borderRadius: BorderRadius.circular(24)),
                  child: Text(
                    "Decline",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getOwnDetail();
    getMemberInviteRequest();
    memberRequestList();
    getMemberDetails();

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
            child: Text("Request List",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        title: roomName,
        backgroundColor: Colors.lightBlue[600],
      ),
      body: Container(
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
                              memberRequestList(),
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
    );
  }
}
