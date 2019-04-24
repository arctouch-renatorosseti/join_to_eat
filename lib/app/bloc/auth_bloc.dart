import 'dart:async';

import 'package:bloc/bloc.dart';
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

  AuthState(FormMode field, String errorMessage) {
    this.field = field;
    this.errorMessage = errorMessage;
  }
}

class AuthBloc extends Bloc<UserEvent, AuthState> {
  final _repository = Repository();
  String _email;
  String _securityKey;

  UsersList _usersList;

  AuthBloc() {
    fetchUsers().then((onValue) {
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
                yield AuthState(currentState.field, Strings.emailNotRegistered);
              }
            } else {
              yield AuthState(currentState.field, Strings.emailInvalid);
            }
            break;
          case FormMode.securityKey:
            if (_isSecurityKeyValid()) {
              AuthState userState = AuthState(FormMode.mainScreen, "");
              userState.route = Routes.main;
              yield userState;
            } else {
              yield AuthState(currentState.field, Strings.securityKeyInvalid);
            }

            break;
          case FormMode.mainScreen:
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
    for (User user in _usersList.users) {
      if (user.email == email) {
        return true;
      }
    }
    return false;
  }

  bool _isSecurityKeyValid() => _securityKey != null && _securityKey.isNotEmpty && _securityKey == "12345";

  Future<UsersList> fetchUsers() {
    return _repository.getUsers();
  }

  void submit() {}
}
