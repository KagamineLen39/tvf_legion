import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

  getUserByUserEmail(String userEmail)async{
    return await Firestore.instance.collection("Users")
    .where("email",isEqualTo: userEmail).getDocuments();
  }

  getUserIdByUserEmail(String userEmail)async{
    return await Firestore.instance.collection("Users")
    .where("userID",isEqualTo: userEmail).getDocuments();
  }

  uploadUserInfo(userId,userMap){
    Firestore.instance.collection("Users").document(userId).setData(userMap);
  }

  getUsername(String searchField){
    return Firestore.instance
        .collection("Users")
        .where("username", isEqualTo: searchField)
        .getDocuments();
  }

  searchByUsername(String searchField){
    return Firestore.instance.collection("Users").where('username',isGreaterThanOrEqualTo: searchField).getDocuments();
  }
}