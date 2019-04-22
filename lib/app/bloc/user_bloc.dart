import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:join_to_eat/app/bloc/user_event.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:rxdart/rxdart.dart';

enum FormMode { email, securityKey, mainScreen }

class UserState {
  FormMode field;
  String errorMessage;
  UserState(FormMode field, String errorMessage) {
    this.field = field;
    this.errorMessage = errorMessage;
  }
}


class UserBloc extends Bloc<UserEvent, UserState> {
  final _repository = Repository();
  String _email;
  String _password;

  UsersList _usersList;

  UserBloc() {
    fetchUsers().then((onValue) {
      _usersList = onValue;
      print("Users length: ${onValue.users.length}");
    });
  }

  @override
  UserState get initialState => UserState(FormMode.email, "");

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    switch (event) {
      case UserEvent.submit:
        if(validateFields()) {
          switch(currentState.field) {
            case FormMode.email:
              yield UserState(FormMode.securityKey,"");
              break;
            case FormMode.securityKey:
              yield UserState(FormMode.mainScreen,"");
              break;
            case FormMode.mainScreen:
              print("Main Screen");
              break;
          }
        } else {
          yield UserState(currentState.field ,(currentState.field == FormMode.email) ? "Invalid email" : "Invalid security key");
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