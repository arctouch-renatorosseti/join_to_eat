import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:join_to_eat/app/model/user.dart';
import 'package:join_to_eat/app/model/users_list.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<UsersList> getJsonUsers(String jsonString) async {
    Map decoded = jsonDecode(jsonString);
    UsersList usersList = UsersList.fromJson(decoded['users']);
    return usersList;
  }


}