import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class friendSystem {
  sendFriendRequest(userID, userMap, peerID, peerMap) {
    Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .setData(userMap);
    Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .collection("sentRequests")
        .document(peerID)
        .setData(peerMap);
  }

  cancelRequest(userID, peerID) {
    Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .collection("sentRequests")
        .document(peerID)
        .delete();
    Firestore.instance
        .collection("friendSystem")
        .document(peerID)
        .collection("receivedRequests")
        .document(userID)
        .delete();
  }

  retrieveRequest(peerID, peerMap, userID, userMap) {
    Firestore.instance
        .collection("friendSystem")
        .document(peerID)
        .setData(peerMap);
    Firestore.instance
        .collection("friendSystem")
        .document(peerID)
        .collection("receivedRequests")
        .document(userID)
        .setData(userMap);
  }

  acceptRequest(userID, userMap, peerID, peerMap) {
    Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .collection("Friends")
        .document(peerID)
        .setData(peerMap);
    Firestore.instance
        .collection("friendSystem")
        .document(peerID)
        .collection("Friends")
        .document(userID)
        .setData(userMap);

    Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .collection("receivedRequests")
        .document(peerID)
        .delete();
    Firestore.instance
        .collection('friendSystem')
        .document(peerID)
        .collection("sentRequests")
        .document(userID)
        .delete();
  }

  deleteRequest(userID, peerID) {
    Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .collection("receivedRequests")
        .document(peerID)
        .delete();
    Firestore.instance
        .collection('friendSystem')
        .document("peerID")
        .collection("sentRequests")
        .document(userID)
        .delete();
  }

  requestSentChecker(userID, peerID) {
    return Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .collection("sentRequests")
        .where("peerID", isEqualTo: peerID)
        .getDocuments();
  }

  receivedRequestChecker(userID, peerID) {
    return Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .collection("receivedRequests")
        .where("peerID", isEqualTo: peerID)
        .getDocuments();
  }

  friendChecker(userID, peerID) {
    return Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .collection("Friends")
        .where("peerID", isEqualTo: peerID)
        .getDocuments();
  }

  getRequestList(userID) {
    return Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .collection("receivedRequests")
        .getDocuments();
  }

  getFriendList(userID) {
    return Firestore.instance
        .collection("friendSystem")
        .document(userID)
        .collection("Friends")
        .getDocuments();
  }
}
