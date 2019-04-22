import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:join_to_eat/app/bloc/auth_event.dart';
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
  String _email;
  String _password;

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
        if(validateFields()) {
          switch(currentState.field) {
            case FormMode.email:
              yield AuthState(FormMode.securityKey,"");
              break;
            case FormMode.securityKey:
              AuthState userState = AuthState(FormMode.mainScreen,"");
              userState.route = Routes.main;
              yield userState;
              break;
            case FormMode.mainScreen:
              print("Main Screen");
              break;
          }
        } else {
          yield AuthState(currentState.field ,(currentState.field == FormMode.email) ? "Invalid email" : "Invalid security key");
        }
        break;
    }
  }

  String validateEmail(String value) => value.isEmpty ? Strings.appName : null;

  onEmailSaved(String value) => _email = value;

  bool validateFields() => _email != null &&
      _email.isNotEmpty &&
      _email.contains('@');

  Future<UsersList> fetchUsers() {
    return _repository.getUsers();
  }

  void submit() {

  }


}