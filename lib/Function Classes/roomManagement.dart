
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tvf_legion/modal/room.dart';

class RoomManagement {

  getRoomId(ownerId){
   var ref= Firestore.instance
        .collection("Owner")
        .document(ownerId)
        .collection("Room").document();
    return ref.documentID;
  }

  getSearchRoomId(){

  }

  createOwnerRoomInfo(ownerId, ownerMap, roomId, roomMap) {
    Firestore.instance.collection("Owner").document(ownerId).setData(ownerMap);
    Firestore.instance
        .collection("Owner")
        .document(ownerId)
        .collection("Room")
        .document(roomId)
        .setData(roomMap);
    Firestore.instance
        .collection("Owner")
        .document(ownerId)
        .collection("Room")
        .document(roomId).collection("Member").document(ownerId).setData(ownerMap);
  }


  updateOwnerRoomInfo(ownerId, ownerMap, roomId, roomMap) {
    Firestore.instance.collection("Owner").document(ownerId).setData(ownerMap);
    Firestore.instance
        .collection("Owner")
        .document(ownerId)
        .collection("Room")
        .document(roomId)
        .setData(roomMap);
  }

  Future<List<Room>>searchRoomName(ownerId) async {
    final listOwnerValue = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

   List<Room> tempRoomList = new List<Room>();

    for (int i = 0; i < listOwnerValue.length; i++) {

      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwnerValue[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {
        Room tempRoom = new Room();
        tempRoom.roomId = listRoom[j]["RoomID"];
        tempRoom.rName = listRoom[j]["Name"];
        tempRoom.rPassword = listRoom[j]["Password"];
        tempRoom.state = listRoom[j]["State"];
        tempRoom.maxPerson = listRoom[j]["MaxPerson"];
        //tempRoom.roomId = listRoom[i]["Picture"];
        tempRoom.rDescription = listRoom[j]["Description"];

        tempRoomList.add(tempRoom);

      }

    }
    return tempRoomList;

  }

  memberJoin(index, ownUserID, ownMap) async{
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);
    print('$index');

    for (int i = 0; i < listOwner.length; i++) {
         final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
           .getDocuments()
           .then((val) => val.documents);


       for (int j = 0; j < listRoom.length; j++) {
          Firestore.instance
             .collection("Owner")
             .document(listOwner[i].documentID.toString())
             .collection("Room")
             .document(listRoom[index].documentID.toString())
             .collection("Member")
              .document(ownUserID)
              .setData(ownMap);
       }

    }
  }

  displayOwnerRoom(String ownerId) {
    return Firestore.instance
        .collection("Owner")
        .document(ownerId)
        .collection("Room")
        .getDocuments();
  }

  displayMember() async {
    List<int> numberMember = new List();
    int tempMember;
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    for (int i = 0; i < listOwner.length; i++) {
      final listRoom = await Firestore.instance
          .collection("Owner")
          .document(listOwner[i].documentID.toString())
          .collection("Room")
          .getDocuments()
          .then((val) => val.documents);

      for (int j = 0; j < listRoom.length; j++) {

       return Firestore.instance
            .collection("Owner")
            .document(listOwner[i].documentID.toString())
            .collection("Room")
            .document(listRoom[j].documentID.toString())
            .collection("Member")
            .getDocuments();
          //  .then((val) => val.documents);

    // for(int k = 0; j <listMember.length; k++ ){
    //   int tempMember;
    //
    //   final noOfMember =  await Firestore.instance
    //       .collection("Owner")
    //       .document(listOwner[i].documentID.toString())
    //       .collection("Room")
    //       .document(listRoom[j].documentID.toString())
    //       .collection("Member")
    //       .document(listRoom[k].documentID.toString());
    //
    //   //tempMember = noOfMember.documents.length;
    //   print('$noOfMember');
    //
    // }
//        numberMember.add(tempMember);
// print('$tempMember');
      }
    }
    //return numberMember;
  }

  displayOwnerRoomWithPosition(String ownerId, int index) async {
    final listOwner = await Firestore.instance
        .collection("Owner")
        .getDocuments()
        .then((val) => val.documents);

    return Firestore.instance
        .collection("Owner")
        .document(listOwner[index].documentID.toString())
        .collection("Room")
        .getDocuments();
  }


}
