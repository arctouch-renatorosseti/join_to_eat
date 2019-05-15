import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/model/option_quiz.dart';
import 'package:join_to_eat/app/model/quiz.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'package:join_to_eat/app/repository/preferences_provider.dart';
import 'package:join_to_eat/app/resources/constants.dart';
import 'firestore_provider.dart';

class Repository {
  static final places = GoogleMapsPlaces(apiKey: Constants.GOOGLE_MAPS_API_KEY);

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
    _firestoreProvider.updateMeetingCollection(meeting);
  }

  Stream<Iterable<Meeting>> getCurrentMeetings() {
    return _firestoreProvider.getCurrentMeetings().map((querySnap) => querySnap.documents.map((docSnap) => Meeting(
        description: docSnap.data["description"],
        idMapPlace: docSnap.data["idMapPlace"],
        users: List.from(docSnap.data["users"]),
        startTime: docSnap.data["startTime"],
        endTime: docSnap.data["endTime"])));
  }

  Future<String> getSignedUser() async {
    return await _preferencesProvider.getUserSigned();
  }

  Future<User> getUser(String id) async {
    DocumentSnapshot docSnap = await _firestoreProvider.getUser(id);

    if (docSnap == null || !docSnap.exists) {
      return null;
    }

    return User.fromJson(Map.from(docSnap.data["user"]));
  }
}

class QuizRepository extends Repository {
  Future<void> insertQuiz(Quiz quiz, List<OptionQuiz> options) async {
    List<String> idOptions = [];
    for (OptionQuiz option in options) {
      await _firestoreProvider.insertOptionQuiz(option).then((onValue) {
        idOptions.add(onValue.documentID);
      });
    }
    quiz.answersOptions = idOptions;
    await _firestoreProvider.insertQuiz(quiz);
  }
}
