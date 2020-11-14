import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

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


}