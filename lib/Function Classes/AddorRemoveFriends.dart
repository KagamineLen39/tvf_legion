import 'package:cloud_firestore/cloud_firestore.dart';


// ignore: camel_case_types
class friendSystem{
  sendFriendRequest(username, peerMap){
    Firestore.instance.collection("friendSystem").document(username).setData(peerMap);
  }

  cancelRequest(username,peerUsername){

  }

  checkIsFriend(String username,peerUsername){

  }
}