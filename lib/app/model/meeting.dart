import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Meeting extends Equatable {
  String reference;
  String description;
  String idMapPlace;
  List<String> users;
  Timestamp startTime;
  Timestamp endTime;

  Meeting({this.reference, this.description, this.idMapPlace, this.users, this.startTime, this.endTime})
      : super([reference /*, description, idMapPlace, users, startTime, endTime*/]) {
    if (users == null) {
      users = List<String>();
    }
  }

  Map<String, dynamic> toDocument() {
    return {
      "description": this.description,
      "idMapPlace": this.idMapPlace,
      "users": this.users,
      "startTime": this.startTime,
      "endTime": this.endTime,
    };
  }

  static Meeting fromDocumentSnap(DocumentSnapshot docSnap) {
    return Meeting(
        reference: docSnap.documentID,
        description: docSnap.data["description"],
        idMapPlace: docSnap.data["idMapPlace"],
        users: List.from(docSnap.data["users"]),
        startTime: docSnap.data["startTime"],
        endTime: docSnap.data["endTime"]);
  }
}
