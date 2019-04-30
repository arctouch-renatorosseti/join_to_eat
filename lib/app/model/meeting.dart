import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Meeting extends Equatable {
  String description;
  String idMapPlace;
  List<String> users;
  Timestamp startTime;
  Timestamp endTime;

  Meeting({this.description, this.idMapPlace, this.users, this.startTime, this.endTime})
      : super([description, idMapPlace, users, startTime, endTime]) {
    users = new List<String>();
  }
}
