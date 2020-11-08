import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

  getUserByUserEmail(String userEmail)async{
    return await Firestore.instance.collection("Users")
    .where("email",isEqualTo: userEmail).getDocuments();
  }

  getUserbyUserName(String username)async{
    return await Firestore.instance.collection("Users")
        .where("username",isEqualTo: username).getDocuments();
  }


  uploadUserInfo(userMap){
    Firestore.instance.collection("Users").add(userMap);
  }
}