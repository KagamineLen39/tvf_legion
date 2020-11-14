import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tvf_legion/services/serviceLoacators.dart';

class Database{
  final _firestore = serviceLocator<Firestore>();

  getUserByUserEmail(String userEmail)async{
    return await Firestore.instance.collection("Users")
    .where("email",isEqualTo: userEmail).getDocuments();
  }

  uploadUserInfo(userId,userMap){
    Firestore.instance.collection("Users").document(userId).setData(userMap);
  }

  searchByUsername(String searchField) {
    return Firestore.instance
        .collection("Users")
        .where('username', isEqualTo: searchField)
        .getDocuments();
  }

  Future<Stream<List<DocumentSnapshot>>> getListOfFriends(
      String currentUserId) {
    return _getListOfUsers(currentUserId: currentUserId, isFriends: true);
  }

  Future<Stream<List<DocumentSnapshot>>> getFriendRequests(
      String currentUserId) {
    return _getListOfUsers(
      currentUserId: currentUserId,
      isFriends: false,
      isGetRequest: true,
    );
  }

  Future<Stream<List<DocumentSnapshot>>> _getListOfUsers({
    @required String currentUserId,
    @required bool isFriends,
    bool isGetRequest = false,
  }) async {
    return _firestore.collection('users').snapshots().transform(
      StreamTransformer<QuerySnapshot, List<DocumentSnapshot>>.fromHandlers(
        handleData: (querySnapshot, sink) async {
          print('loading friend list of $currentUserId');

          final userDocument = await _firestore
              .collection('users')
              .document(currentUserId)
              .get();

          final friendList = List<String>.from(
            json.decode(
              (userDocument).data['friends'] ?? "[]",
            ),
          );

          final requestList = List<String>.from(
            json.decode(
              (userDocument).data['requests'] ?? "[]",
            ),
          );

          print(friendList);

          final _firendsList = List<DocumentSnapshot>();
          final _unFriendsList = List<DocumentSnapshot>();
          final _friendRequests = List<DocumentSnapshot>();

          for (final doc in querySnapshot.documents) {
            if (friendList.contains(doc.data['id']) ||
                doc.data['id'] == currentUserId) {
              _firendsList.add(doc);
            } else {
              final userRequests = List<String>.from(
                json.decode(doc.data['requests'] ?? '[]'),
              );

              if (!requestList.contains(doc.data['id']) &&
                  !userRequests.contains(currentUserId)) {
                _unFriendsList.add(doc);
              }

              if (requestList.contains(doc.data['id'])) {
                _friendRequests.add(doc);
              }
            }
          }

          print(_firendsList);

          if (isFriends) {
            sink.add(_firendsList);
          } else {
            if (isGetRequest)
              sink.add(_friendRequests);
            else
              sink.add(_unFriendsList);
          }
        },
      ),
    );
  }


}