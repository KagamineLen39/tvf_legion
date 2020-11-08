import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance.collection("Users").getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("Users").add(userMap);
  }
}
