import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  void saveUserCollection(Map<String, dynamic> json, String id) {
    _firestoreProvider.saveUserCollection(json, id);
  }

  Future<UsersList> getUsers(String jsonString) async {
    Map decoded = jsonDecode(jsonString);
    UsersList usersList = UsersList.fromJson(decoded['users']);
    return usersList;
  }
}
