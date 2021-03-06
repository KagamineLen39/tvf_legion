import 'package:cloud_firestore/cloud_firestore.dart';

class Messaging{
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  Future<void> addMessage(String chatRoomId,chatMessageData){
    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());

    });
  }

  chatRoomIdChecker(String chatRoomId) {
    return Firestore.instance
        .collection("chatRoom")
        .where("chatRoomId",isEqualTo: chatRoomId).getDocuments();
  }

}