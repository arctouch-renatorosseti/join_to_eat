
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class Meeting extends Equatable {
  String id;
  String description;
  String idMapPlace;
  List<String> users;
  Timestamp time;
  Timestamp expiredTime;

  Meeting({this.id, this.description, this.idMapPlace, this.users, this.time, this.expiredTime})
      : super([id, description, idMapPlace, users, time, expiredTime]) {
    users = new List<String>();
  }



}
