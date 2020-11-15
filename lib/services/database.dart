import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

  getUserByUserEmail(String userEmail)async{
    return await Firestore.instance.collection("Users")
    .where("email",isEqualTo: userEmail).getDocuments();
  }

  uploadUserInfo(userId,userMap){
    Firestore.instance.collection("Users").document(userId).setData(userMap);
  }
}

class DatabaseService{
  final String roomId;
  DatabaseService({this.roomId});

  final CollectionReference roomCollection = Firestore.instance.collection('Room');

  Future updateRoomDate(String rPic, String rName, int rMax, String rState, String rPassword, String rDescription )async {
    return await roomCollection.document(roomId).setData({
      'RoomPicture' : rPic,
      'RoomName' : rName,
      'MaxPerson' : rMax,
      'State' : rState,
      'Password' : rPassword,
      'Description' : rDescription,
    });
  }
// }