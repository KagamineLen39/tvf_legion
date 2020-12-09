import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tvf_legion/modal/room.dart';
import 'package:tvf_legion/modal/user.dart';

class RoomManagement {

  getRoomId(ownerId){
   var ref= Firestore.instance
        .collection("Owner")
        .document(ownerId)
        .collection("Room").document();
    return ref.documentID;
  }

  getListMember(roomId) async {
    String userId;
    List<User> tempUserList = new List<User>();
    List<Room> tempRoomList = new List<Room>();
    List<User> memberList = new List<User>();
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    for (int i = 0; i < listOwner.length; i++) {
      User tempOwner = new User();
      tempOwner.userId = listOwner[i]["userID"];
      tempUserList.add(tempOwner);

      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        Room tempRoom = new Room();
        tempRoom.roomId = listRoom[j]["RoomID"];
        tempRoomList.add(tempRoom);

        if (roomId == tempRoom.roomId) {
          userId = tempOwner.userId;

          final listMember = await Firestore.instance
              .collection("Owner")
              .document(userId)
              .collection("Room")
              .document(roomId)
              .collection("Member")
              .getDocuments()
              .then((val) => val.documents);

          for (int k = 0; k < listMember.length; k++) {
            User member = new User();

            member.userName = listMember[k]["username"];

            memberList.add(member);


          }
        }
      }
    }
    return memberList;
  }

  checkRoomOwner(roomId) async{
    String ownerId;
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    for (int i = 0; i < listOwner.length; i++) {

      User tempOwner = new User();
      tempOwner.userId = listOwner[i]["userID"];

      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        Room tempRoom = new Room();
        tempRoom.roomId = listRoom[j]["RoomID"];

        if (roomId == tempRoom.roomId) {
          ownerId = tempOwner.userId;
          return ownerId;

          }
        }
      }
    }


  createOwnerRoomInfo(ownerId, ownerMap, roomId, roomMap) {
    Firestore.instance.collection("Owner").document(ownerId).setData(ownerMap);
    Firestore.instance
        .collection("Owner")
        .document(ownerId)
        .collection("Room")
        .document(roomId)
        .setData(roomMap);
    Firestore.instance
        .collection("Owner")
        .document(ownerId)
        .collection("Room")
        .document(roomId).collection("Member").document(ownerId).setData(ownerMap);
  }

  updateOwnerRoomInfo(ownerId, ownerMap, roomId, roomMap) {
    Firestore.instance.collection("Owner").document(ownerId).setData(ownerMap);
    Firestore.instance
        .collection("Owner")
        .document(ownerId)
        .collection("Room")
        .document(roomId)
        .setData(roomMap);
  }

  searchRoomName() async {
    final listOwnerValue = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

   List<Room> tempRoomList = new List<Room>();

    for (int i = 0; i < listOwnerValue.length; i++) {

      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwnerValue[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        Room tempRoom = new Room();
        tempRoom.roomId = listRoom[j]["RoomID"];
        tempRoom.rName = listRoom[j]["Name"];
        tempRoom.state = listRoom[j]["State"];
        tempRoom.maxPerson = listRoom[j]["MaxPerson"];
        //tempRoom.roomId = listRoom[j]["Picture"];
        tempRoom.rDescription = listRoom[j]["Description"];

        tempRoomList.add(tempRoom);

      }

    }
    return tempRoomList;

  }

  memberJoin(ownUserID, ownMap, roomId) async {
    String userId;
    List<User> tempUserList = new List<User>();
    List<Room> tempRoomList = new List<Room>();
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    for (int i = 0; i < listOwner.length; i++) {
      User tempOwner = new User();
      tempOwner.userId = listOwner[i]["userID"];
      tempUserList.add(tempOwner);

      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        Room tempRoom = new Room();
        tempRoom.roomId = listRoom[j]["RoomID"];
        tempRoomList.add(tempRoom);

        if(roomId == tempRoom.roomId) {
          userId = tempOwner.userId;

          return Firestore.instance.collection("Owner").document(userId)
              .collection("Room").document(roomId)
              .collection("Member").document(ownUserID).setData(ownMap);
        }
      }
    }

  }

  displayOwnerRoom(String ownerId) {
    return Firestore.instance
        .collection("Owner")
        .document(ownerId)
        .collection("Room")
        .getDocuments();
  }

  displayMember() async {
    List<int> numberMember = new List();
    int tempMember;
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    for (int i = 0; i < listOwner.length; i++) {
      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        final listMember = await Firestore.instance
            .collection("Owner")
            .document(listOwner[i].documentID.toString())
            .collection("Room")
            .document(listRoom[j].documentID.toString())
            .collection("Member")
            .getDocuments()
            .then((val) => val.documents);

        tempMember = listMember.length;
        numberMember.add(tempMember);
      }
    }
    return numberMember;
  }

  displayMemberDetailed(roomId) async{
    List<User> memberDetailed = new List<User>();
    User member = new User();
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    for (int i = 0; i < listOwner.length; i++) {
      final listMember = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
            .document(roomId)
            .collection("Member")
            .getDocuments()
            .then((val) => val.documents);

        for(int k = 0; k < listMember.length; k++){
          User member = new User();
          member.userId = listMember[k]["userID"];
          member.userName = listMember[k]["username"];
          member.email = listMember[k]["email"];

          memberDetailed.add(member);

        }

    }
    return memberDetailed;
  }

  displayOwnerRoomMember(String ownerId) async{
    List<int> numberMember = new List();
    int tempMember;
      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(ownerId)
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        final listMember = await Firestore.instance
            .collection("Owner")
            .document(ownerId)
            .collection("Room")
            .document(listRoom[j].documentID.toString())
            .collection("Member")
            .getDocuments()
            .then((val) => val.documents);

        tempMember = listMember.length;
        numberMember.add(tempMember);
      }

    return numberMember;
  }

  sendInviteRequest(roomId, memberId, memberMap) async{
    String ownerId;
    List<User> tempUserList = new List<User>();
    List<Room> tempRoomList = new List<Room>();
    Map<String, String> roomOwnerMap;
    Map<String, dynamic> roomMap;
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    for (int i = 0; i < listOwner.length; i++) {
      User tempOwner = new User();
      tempOwner.userId = listOwner[i]["userID"];
      tempOwner.userName = listOwner[i]["username"];
      tempOwner.email = listOwner[i]["email"];
      tempUserList.add(tempOwner);

      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        Room tempRoom = new Room();
        tempRoom.roomId = listRoom[j]["RoomID"];
        tempRoom.rName = listRoom[j]["Name"];
        tempRoom.state = listRoom[j]["State"];
        tempRoom.maxPerson = listRoom[j]["MaxPerson"];
        tempRoom.rPic = listRoom[j]["Picture"];
        tempRoom.rDescription = listRoom[j]["Description"];
        tempRoomList.add(tempRoom);

        if(roomId == tempRoom.roomId) {
          ownerId = tempOwner.userId;

          roomMap ={
            "RoomID" :roomId,
            "Name" :tempRoom.rName,
            "State" :tempRoom.state,
            "MaxPerson":tempRoom.maxPerson,
            "Picture" :tempRoom.rPic,
            "Description" :tempRoom.rDescription,
          };
          roomOwnerMap = {
            "OwnerID": ownerId,
            "OwnerUsername": tempOwner.userName,
            "OwnerEmail": tempOwner.email,
          };

          Firestore.instance
          .collection("RoomInviteManagementSystem")
          .document(roomId)
          .setData(roomMap);
          Firestore.instance
              .collection("RoomInviteManagementSystem")
              .document(roomId)
              .collection("InviteSystem")
              .document(memberId)
              .setData(memberMap);
           Firestore.instance
               .collection("RoomInviteManagementSystem")
               .document(roomId)
              .collection("InviteSystem")
              .document(memberId)
              .collection("SentInviteRequest")
              .document(ownerId)
              .setData(roomOwnerMap);

        }
      }
    }
  }

  cancelInviteRequest(roomId, memberId)async {
    String ownerId;
    List<User> tempUserList = new List<User>();
    List<Room> tempRoomList = new List<Room>();

    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    for (int i = 0; i < listOwner.length; i++) {
      User tempOwner = new User();
      tempOwner.userId = listOwner[i]["userID"];
      tempOwner.userName = listOwner[i]["username"];
      tempOwner.email = listOwner[i]["email"];
      tempUserList.add(tempOwner);

      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        Room tempRoom = new Room();
        tempRoom.roomId = listRoom[j]["RoomID"];
        tempRoom.rName = listRoom[j]["Name"];
        tempRoom.state = listRoom[j]["State"];
        tempRoom.maxPerson = listRoom[j]["MaxPerson"];
        tempRoom.rPic = listRoom[j]["Picture"];
        tempRoom.rDescription = listRoom[j]["Description"];
        tempRoomList.add(tempRoom);

        if(roomId == tempRoom.roomId) {
          ownerId = tempOwner.userId;
          Firestore.instance
              .collection("RoomInviteManagementSystem")
              .document(roomId)
              .collection("InviteSystem")
              .document(memberId)
              .collection("SentInviteRequest")
              .document(ownerId)
              .delete();
          Firestore.instance
              .collection("RoomInviteManagementSystem")
              .document(roomId)
              .collection("InviteSystem")
              .document(ownerId)
              .collection("ReceivedInviteRequests")
              .document(memberId)
              .delete();

        }
      }
    }

  }

  retrieveInviteRequest(memberId, memberMap, roomId) async{
    String ownerId;
    List<User> tempUserList = new List<User>();
    List<Room> tempRoomList = new List<Room>();
    Map<String, String> roomOwnerMap;
    Map<String, dynamic> roomMap;
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    for (int i = 0; i < listOwner.length; i++) {
      User tempOwner = new User();
      tempOwner.userId = listOwner[i]["userID"];
      tempOwner.userName = listOwner[i]["username"];
      tempOwner.email = listOwner[i]["email"];
      tempUserList.add(tempOwner);

      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        Room tempRoom = new Room();
        tempRoom.roomId = listRoom[j]["RoomID"];
        tempRoom.rName = listRoom[j]["Name"];
        tempRoom.state = listRoom[j]["State"];
        tempRoom.maxPerson = listRoom[j]["MaxPerson"];
        tempRoom.rPic = listRoom[j]["Picture"];
        tempRoom.rDescription = listRoom[j]["Description"];
        tempRoomList.add(tempRoom);

        if(roomId == tempRoom.roomId) {
          ownerId = tempOwner.userId;

          roomMap ={
            "RoomID" :roomId,
            "Name" :tempRoom.rName,
            "State" :tempRoom.state,
            "MaxPerson":tempRoom.maxPerson,
            "Picture" :tempRoom.rPic,
            "Description" :tempRoom.rDescription,
          };
          roomOwnerMap = {
            "OwnerID": ownerId,
            "OwnerUsername": tempOwner.userName,
            "OwnerEmail": tempOwner.email,
          };

          Firestore.instance
              .collection("RoomInviteManagementSystem")
              .document(roomId)
              .setData(roomMap);
          Firestore.instance
              .collection("RoomInviteManagementSystem")
              .document(roomId)
              .collection("InviteSystem")
              .document(ownerId)
              .setData(roomOwnerMap);
          Firestore.instance
              .collection("RoomInviteManagementSystem")
              .document(roomId)
              .collection("InviteSystem")
              .document(ownerId)
              .collection("ReceivedInviteRequests")
              .document(memberId)
              .setData(memberMap);
        }
      }
    }
  }

  acceptInviteRequest(ownerId, ownMap,memberId, memberMap, roomId) {
    Firestore.instance
        .collection("InviteSystem")
        .document(ownerId)
        .collection("AcceptMember")
        .document(memberId)
        .setData(memberMap);

    Firestore.instance
        .collection("InviteSystem")
        .document(memberId)
        .collection("AcceptMember")
        .document(ownerId)
        .setData(ownMap);

    Firestore.instance
        .collection("InviteSystem")
        .document(ownerId)
        .collection("ReceivedInviteRequests")
        .document(memberId)
        .delete();

    Firestore.instance
        .collection('InviteSystem')
        .document(memberId)
        .collection("SentInviteRequest")
        .document(ownerId)
        .delete();

    memberJoin(ownerId, ownMap, roomId);
  }

  declineInviteRequest(ownerId, memberId) {
    Firestore.instance
        .collection("InviteSystem")
        .document(ownerId)
        .collection("ReceivedInviteRequests")
        .document(memberId)
        .delete();

    Firestore.instance
        .collection('InviteSystem')
        .document(memberId)
        .collection("SentInviteRequest")
        .document(ownerId)
        .delete();
  }

  requestInviteSentChecker(memberId, roomId) async{

    int userRequest;

           final checkRequest = await Firestore.instance
              .collection("RoomInviteManagementSystem")
              .document(roomId)
              .collection("InviteSystem")
              .document(memberId)
              .collection("SentInviteRequest")
              .getDocuments()
               .then((value) => value.documents);

          userRequest = checkRequest.length;


        return userRequest;

  }

  receivedInviteRequestChecker(ownerId, memberId) {
    // return Firestore.instance
    //     .collection("InviteSystem")
    //     .document(ownerId)
    //     .collection("ReceivedInviteRequests")
    //     .where("MemberID", isEqualTo: memberId)
    //     .getDocuments();
  }

  memberChecker(memberId, roomId) async {
    String ownerId;
    List<User> tempUserList = new List<User>();
    List<Room> tempRoomList = new List<Room>();
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    for (int i = 0; i < listOwner.length; i++) {
      User tempOwner = new User();
      tempOwner.userId = listOwner[i]["userID"];
      tempUserList.add(tempOwner);

      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        Room tempRoom = new Room();
        tempRoom.roomId = listRoom[j]["RoomID"];
        tempRoomList.add(tempRoom);

        if(roomId == tempRoom.roomId) {
          ownerId = tempOwner.userId;

          return Firestore.instance.collection("Owner").document(ownerId)
              .collection("Room").document(roomId)
              .collection("Member").where("userID", isEqualTo: memberId)
              .getDocuments();
        }
      }
    }
  }
}





