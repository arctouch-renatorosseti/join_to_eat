import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<bool> isEmailRegistered(String email) {
    return _firestoreProvider.isEmailRegistered(email).then((onValue) => _setStateSignIn(onValue.documents.length > 0));
  }

  Future<bool> _setStateSignIn(bool state) async {
    _preferencesProvider.setUserSigned(state);
    return state;
  }
}
