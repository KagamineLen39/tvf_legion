import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

  getUserByUserEmail(String userEmail)async{
<<<<<<< HEAD
    return await Firestore.instance.collection("Users")
    .where("email",isEqualTo: userEmail).getDocuments();
  }

  getUserbyUserName(String username)async{
    return await Firestore.instance.collection("Users")
        .where("username",isEqualTo: username).getDocuments();
  }


=======
    return await Firestore.instance.collection("Users").getDocuments();
  }

>>>>>>> parent of 88b2cac... HomePage
  uploadUserInfo(userMap){
    Firestore.instance.collection("Users").add(userMap);
  }
}