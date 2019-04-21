import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:join_to_eat/app/bloc/user_event.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:rxdart/rxdart.dart';

enum FormMode { login, signUp, resetPassword }

class UserBloc extends Bloc<UserEvent, int> {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  UsersList _usersList;

  UserBloc() {
    fetchUsers().then((onValue) {
      _usersList = onValue;
      print("Users length: ${onValue.users.length}");
    });
  }

  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(UserEvent event) async* {
    switch (event) {
      case UserEvent.signed:
        yield currentState - 1;
        break;
      case UserEvent.submit:
        yield currentState + 1;
        break;
    }
  }

  String validateEmail(String value) => value.isEmpty ? Strings.appName : null;

  bool validateFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _email.value.contains('@') &&
        _password.value.length > 3) {
      return true;
    } else {
      return false;
    }
  }

  Future<UsersList> fetchUsers() {
    return _repository.getUsers();
  }

  void submit() {

  }


}