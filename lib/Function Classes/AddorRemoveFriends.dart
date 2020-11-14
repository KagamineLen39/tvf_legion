// ignore: camel_case_types
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tvf_legion/services/serviceLoacators.dart';

// ignore: camel_case_types
class friendSystem{

  final getFirestore = serviceLocator<Firestore>();

  Future<void> unFriendUser(String currentUserId, String friendId) async {
    final friendDoc = await getFirestore.collection('Users').document(friendId).get();
    final userDoc = await getFirestore.collection('Users').document(currentUserId).get();

    final friendFriends =
    List<String>.from(json.decode(friendDoc.data['Friend_System'] ?? '[]'));

    final userFriends =
    List<String>.from(json.decode(userDoc.data['Friend_System'] ?? '[]'));

    userFriends.remove(friendId);
    friendFriends.remove(currentUserId);

    getFirestore
        .collection('users')
        .document(currentUserId)
        .updateData({'friends': json.encode(userFriends)});

    getFirestore
        .collection('users')
        .document(friendId)
        .updateData({'friends': json.encode(friendFriends)});
  }

  Future<void> sendFriendRequest(String currentUserId, String friendId) async {
    final friendDoc =
    await getFirestore.collection('users').document(friendId).get();
    final requests =
    List<String>.from(json.decode(friendDoc.data['requests'] ?? '[]'));

    requests.add(currentUserId);
    getFirestore
        .collection('users')
        .document(friendId)
        .updateData({'requests': json.encode(requests)});
  }

  Future<void> acceptFriendRequest(
      String currentUserId, String friendId) async {
    final friendDoc =
    await getFirestore.collection('users').document(friendId).get();
    final friendRequests =
    List<String>.from(json.decode(friendDoc.data['requests'] ?? '[]'));
    final friendFriends =
    List<String>.from(json.decode(friendDoc.data['friends'] ?? '[]'));

    final userDoc =
    await getFirestore.collection('users').document(currentUserId).get();
    final userRequests =
    List<String>.from(json.decode(userDoc.data['requests'] ?? '[]'));
    final userFriends =
    List<String>.from(json.decode(userDoc.data['friends'] ?? '[]'));

    friendRequests.remove(currentUserId);
    friendFriends.add(currentUserId);

    userRequests.remove(friendId);
    userFriends.add(friendId);

    getFirestore.collection('users').document(currentUserId)
      ..updateData({
        'friends': json.encode(userFriends),
        'requests': json.encode(userRequests),
      });

    getFirestore.collection('users').document(friendId).updateData({
      'friends': json.encode(friendFriends),
      'requests': json.encode(friendRequests),
    });
  }

  Future<void> deleteFriendRequest(
      String currentUserId, String friendId) async {
    final userDoc =
    await getFirestore.collection('users').document(currentUserId).get();

    final userRequests = List<String>.from(
      json.decode(userDoc.data['requests'] ?? '[]'),
    );

    userRequests.remove(friendId);

    getFirestore
        .collection('users')
        .document(currentUserId)
        .updateData({'requests': json.encode(userRequests)});
  }
}