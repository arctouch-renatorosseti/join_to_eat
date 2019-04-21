import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:join_to_eat/app/bloc/users_event.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends Bloc<UserEvent, int> {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  UsersList _usersList;

  Observable<String> get email => _email.stream.transform(_validateEmail);

  Observable<String> get password => _password.stream.transform(_validatePassword);

  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(UserEvent event) async* {
    switch (event) {
      case UserEvent.signed:
        yield currentState - 1;
        break;
      case UserEvent.signIn:
        yield currentState + 1;
        break;
    }
  }

  UserBloc() {
    fetchUsers().then((onValue) {
      _usersList = onValue;
      print("Users length: ${onValue.users.length}");
    });
  }

  final _validateEmail = StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError("Email not valide.");
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length > 3) {
          sink.add(password);
        } else {
          sink.addError("Error to validate signin.");
        }
      });


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


}