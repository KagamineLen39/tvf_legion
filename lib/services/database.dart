import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

  getUsername(String username){

  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("Users").add(userMap);
  }
}