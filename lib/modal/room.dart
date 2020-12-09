import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String roomId;
  String rName;
  String rPic;
  String state;
  String rDescription;
  int maxPerson;

  Room({
    this.roomId,
    this.rName,
    this.rPic,
    this.state,
    this.rDescription,
    this.maxPerson,
  });

  factory Room.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Room(
      roomId: doc.documentID,
      rName: data['Name'] ?? '',
      rPic: data['Picture'] ?? '',
      state: data['State'] ?? 'Public',
      rDescription: data['Description'] ?? '',
      maxPerson: data['MaxPerson'] ?? 1,
    );
  }
}
