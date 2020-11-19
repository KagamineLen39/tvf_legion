import 'package:cloud_firestore/cloud_firestore.dart';


// ignore: camel_case_types
class friendSystem{
  
  sendFriendRequest(userID,userMap,peerID,peerMap){
    Firestore.instance.collection("friendSystem").document(userID).setData(userMap);
    Firestore.instance.collection("friendSystem").document(userID).collection("sentRequests").document(peerID).setData(peerMap);
  }

  cancelRequest(userID,peerID){
    Firestore.instance.collection("friendSystem").document(userID).collection("sentRequests").document(peerID).delete();
  }

  checkRequestSent(userID,peerID){
   var found =  Firestore.instance.collection("friendSystem").document(userID).collection("sentRequests").where("peerID",isEqualTo: peerID).getDocuments();

   if(found != null){
     return found;
   }else{
     return 0;
   }
  }
}