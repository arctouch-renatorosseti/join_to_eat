import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'package:join_to_eat/app/repository/preferences_provider.dart';
import 'firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();
  final _preferencesProvider = PreferencesProvider();

  void saveUserCollection(Map<String, dynamic> json, String id) {
    _firestoreProvider.saveUserCollection(json, id);
  }

  Future<UsersList> getUsers(String jsonString) async {
    Map decoded = jsonDecode(jsonString);
    UsersList usersList = UsersList.fromJson(decoded['users']);
    return usersList;
  }

  Future<bool> isEmailRegistered(String email) async {
    return await _firestoreProvider.isEmailRegistered(email).then((onValue) => _setStateSignIn(onValue.documents.length > 0));
  }

  Future<bool> _setStateSignIn(bool state) async {
    _preferencesProvider.setUserSigned(state);
    return state;
  }

  Future<bool> getUserSignedState() async {
    return _preferencesProvider.getUserSigned();
  }

  void loadDataFromPingBoard() async {
    String jsonUsers = await _loadUsersAsset();
    getUsers(jsonUsers).then((onValue) {
      UsersList _usersList = onValue;
      print("Users: ${_usersList.toString()}");
      for (var user in _usersList.users) {
        saveUserCollection(user.toJson(), user.id);
      }
    });
  }

  Future<String> _loadUsersAsset() async {
    return await rootBundle.loadString('assets/users.json');
  }

}
