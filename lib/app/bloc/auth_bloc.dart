import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:join_to_eat/app/bloc/auth_event.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/routes.dart';

enum FormMode { email, securityKey, mainScreen }

class AuthState {
  FormMode field;
  String errorMessage;
  String route;
  bool isLoading;

  AuthState(FormMode field, String errorMessage, bool isLoading) {
    this.field = field;
    this.errorMessage = errorMessage;
    this.isLoading = isLoading;
  }
}

class AuthBloc extends Bloc<UserEvent, AuthState> {
  final _repository = Repository();
  String _email;
  String _securityKey;
  UsersList _usersList;

  AuthBloc() {
    init();
  }

  Future init() async {
    String jsonUsers = await _loadUsersAsset();
    fetchUsers(jsonUsers).then((onValue) {
      _usersList = onValue;
      print("Users length: ${onValue.users.length}");
      for (var user in _usersList.users) {
        _repository.saveUserCollection(user.toJson(), user.id);
      }
    });
  }

  @override
  AuthState get initialState => AuthState(FormMode.email, "", false);

  @override
  Stream<AuthState> mapEventToState(UserEvent event) async* {
    switch (event) {
      case UserEvent.submit:
        switch (currentState.field) {
          case FormMode.email:
            if (isEmailValid()) {
              yield AuthState(currentState.field, "", true);
              yield* await _repository
                  .isEmailRegistered(_email)
                  .then((onValue) => handleEmailState(onValue));
            } else {
              yield AuthState(currentState.field, "Invalid email", false);
            }
            break;
          case FormMode.securityKey:
            if (_isSecurityKeyValid()) {
              AuthState userState = AuthState(FormMode.mainScreen, "", false);
              userState.route = Routes.main;
              yield userState;
            } else {
              yield AuthState(currentState.field, "Invalid security key", false);
            }
            break;
          case FormMode.mainScreen:
            print("Main Screen");
            break;
        }
        break;
    }
  }

  Stream<AuthState> handleEmailState(bool isEmailRegistered) async* {
    print("State: $isEmailRegistered");
    if (isEmailRegistered) {
      yield AuthState(FormMode.securityKey, "", false);
    } else {
      yield AuthState(currentState.field, "Email is not registered", false);
    }
  }

  String validateField(String value) => value.isEmpty ? Strings.emptyFieldError : null;

  onEmailSaved(String value) => _email = value;

  onSecurityKeySaved(String value) => _securityKey = value;

  bool isEmailValid() => _email != null && _email.isNotEmpty && _email.contains('@');

  bool _isEmailRegistered(String email) {
    for (User user in _usersList.users) {
      if (user.email == email) {
        return true;
      }
    }
    return false;
  }

  bool _isSecurityKeyValid() => _securityKey != null && _securityKey.isNotEmpty && _securityKey == "12345";

  Future<UsersList> fetchUsers(String jsonUsers) {
    return _repository.getUsers(jsonUsers);
  }

  Future<String> _loadUsersAsset() async {
    return await rootBundle.loadString('assets/users.json');
  }
}
