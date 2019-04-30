import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'package:join_to_eat/app/repository/preferences_provider.dart';

import 'firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();
  final _preferencesProvider = PreferencesProvider();
}

class UserRepository extends Repository {
  Future<UsersList> getUsers(String jsonString) async {
    Map decoded = jsonDecode(jsonString);
    UsersList usersList = UsersList.fromJsonFile(decoded['users']);
    return usersList;
  }

  Future<bool> isEmailRegistered(String email) async {
    final userDocument = await _firestoreProvider.isEmailRegistered(email);
    bool status = userDocument != null;
    if (status) _setUserSigned(userDocument.documentID);
    return status;
  }

  Future<void> _setUserSigned(String userId) async {
    await _preferencesProvider.setUserSigned(userId);
  }

  Future<bool> setUserSigned(String userId) async {
    return _preferencesProvider.setUserSigned(userId);
  }

  void setUserStatusSigned(bool status) async {
    await _preferencesProvider.setUserSignedStatus(status);
  }

  Future<bool> isUserSigned() async {
    bool isUserSaved = false;
    await _preferencesProvider.getUserSigned().then((onValue) => isUserSaved = onValue.toString().isNotEmpty);
    return await _preferencesProvider.getUserSignedStatus() && isUserSaved;
  }

  void loadDataFromPingBoard() async {
    String jsonUsers = await _loadUsersAsset();
    getUsers(jsonUsers).then((onValue) {
      UsersList _usersList = onValue;
      for (var user in _usersList.users) {
        _saveUserCollection(user.toJson(), user.id);
      }
    });
  }

  Future<String> _loadUsersAsset() async {
    return await rootBundle.loadString('assets/users.json');
  }

  void _saveUserCollection(Map<String, dynamic> json, String id) {
    _firestoreProvider.saveUserCollection(json, id);
  }
}

class MeetingRepository extends Repository {
  Future<void> insertMeeting(Meeting meeting) async {
    await _firestoreProvider.insertMeeting(meeting);
  }

  void updateMeetingCollection(Meeting meeting) {
//    _firestoreProvider.updateMeetingCollection(meeting, meeting.id);
  }

  Stream<Iterable<Meeting>> getCurrentMeetings() {
    return _firestoreProvider.getCurrentMeetings().map((querySnap) => querySnap.documents.map((docSnap) => Meeting(
        description: docSnap.data["description"],
        idMapPlace: docSnap.data["idMapPlace"],
        users: docSnap.data["users"].cast<String>(),
        startTime: docSnap.data["startTime"],
        endTime: docSnap.data["endTime"])));
  }

  Future<String> getSignedUser() async {
    return await _preferencesProvider.getUserSigned();
  }
}
