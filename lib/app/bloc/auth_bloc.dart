import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:join_to_eat/app/bloc/auth_event.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/routes.dart';
import 'package:rxdart/rxdart.dart';

enum FormMode { email, securityKey, mainScreen }

class AuthState {
  FormMode field;
  String errorMessage;
  String route;

  AuthState(FormMode field, String errorMessage) {
    this.field = field;
    this.errorMessage = errorMessage;
//    this.route = route;
  }
}

class AuthBloc extends Bloc<UserEvent, AuthState> {
  final _repository = Repository();

  final _firestore = Firestore.instance;

  String _email;
  String _securityKey;

  UsersList _usersList;

  AuthBloc() {
//    submit();
  }

  Future init() async {
    String jsonUsers = await _loadUsersAsset();
    fetchUsers(jsonUsers).then((onValue) {
      _usersList = onValue;
      print("Users length: ${onValue.users.length}");
    });
  }

  @override
  AuthState get initialState => AuthState(FormMode.email, "");

  @override
  Stream<AuthState> mapEventToState(UserEvent event) async* {
    switch (event) {
      case UserEvent.submit:
        switch (currentState.field) {
          case FormMode.email:
            if (isEmailValid()) {
              if (_isEmailRegistered(_email)) {
                yield AuthState(FormMode.securityKey, "");
              } else {
                yield AuthState(currentState.field, "Email is not registered");
              }
            } else {
              yield AuthState(currentState.field, "Invalid email");
            }
            break;
          case FormMode.securityKey:
            if (_isSecurityKeyValid()) {
              AuthState userState = AuthState(FormMode.mainScreen, "");
              userState.route = Routes.main;
              yield userState;
            } else {
              yield AuthState(currentState.field, "Invalid security key");
            }
            break;
          case FormMode.mainScreen:
            print("Main Screen");
            break;
        }
        break;
    }
  }

  String validateField(String value) => value.isEmpty ? Strings.emptyFieldError : null;

  onEmailSaved(String value) => _email = value;

  onSecurityKeySaved(String value) => _securityKey = value;

  bool isEmailValid() => _email != null && _email.isNotEmpty && _email.contains('@');

  bool _isEmailRegistered(String email) {
    searchUserEmail(email).listen((onData) => {
      print("Documents: " + onData.documents.length.toString())
    });
//    for (User user in _usersList.users) {
//      if (user.email == email) {
//        return true;
//      }
//    }
    return false;
  }

  bool _isSecurityKeyValid() => _securityKey != null && _securityKey.isNotEmpty && _securityKey == "12345";

  Future<UsersList> fetchUsers(String jsonUsers) {
    return _repository.getUsers(jsonUsers);
  }

  Future<String> _loadUsersAsset() async {
    return await rootBundle.loadString('assets/users.json');
  }

  void submit() async {
    Firestore.instance.collection('users').snapshots().listen((onData) => {
          fetchUsers(onData.documents.toString()).then((onValue) {
            _usersList = onValue;
            print("Users length: ${onValue.users.length}");
          })
        });
  }

  Stream<QuerySnapshot> searchUserEmail(String email) {
    return _firestore
        .collection("users")
        .where('email', isEqualTo: email)
        .snapshots();
  }
}
