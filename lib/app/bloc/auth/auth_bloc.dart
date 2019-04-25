import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:join_to_eat/app/bloc/auth/auth_event.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/routes.dart';

enum FormMode {
  email,
  securityKey,
  mainScreen,
}

class AuthState {
  FormMode field;
  String errorMessage;
  String route;
  bool isLoading = false;
  bool isUserLogged = false;

  AuthState(FormMode field, String errorMessage, bool isLoading) {
    this.field = field;
    this.errorMessage = errorMessage;
    this.isLoading = isLoading;
  }
}

class AuthBloc extends Bloc<UserEvent, AuthState> {
  final _repository = UserRepository();
  String _email;
  String _securityKey;

  bool isUserLogged = false;

  @override
  AuthState get initialState => AuthState(isUserLogged ? FormMode.mainScreen : FormMode.email, "", false);

  @override
  Stream<AuthState> mapEventToState(UserEvent event) async* {
    switch (event) {
      case UserEvent.submit:
        switch (currentState.field) {
          case FormMode.email:
            if (isEmailValid()) {
              yield AuthState(currentState.field, "", true);
              yield* await _repository.isEmailRegistered(_email).then((onValue) => _handleEmailState(onValue));
            } else {
              yield AuthState(currentState.field, "Invalid email", false);
            }
            break;
          case FormMode.securityKey:
            if (_isSecurityKeyValid()) {
              _repository.setUserStatusSigned(true);
              AuthState userState = AuthState(FormMode.mainScreen, "", false);
              userState.route = Routes.main;
              yield userState;
            } else {
              _repository.setUserStatusSigned(false);
              yield AuthState(currentState.field, Strings.securityKeyInvalid,false);
            }
            break;
          case FormMode.mainScreen:
            break;
        }
        break;
    }
  }

  Stream<AuthState> _handleEmailState(bool isEmailRegistered) async* {
    if (isEmailRegistered) {
      yield AuthState(FormMode.securityKey, "", false);
    } else {
      yield AuthState(currentState.field, Strings.emailNotRegistered, false);
    }
  }

  String validateField(String value) => value.isEmpty ? Strings.emptyFieldError : null;

  onEmailSaved(String value) => _email = value;

  onSecurityKeySaved(String value) => _securityKey = value;

  bool isEmailValid() => _email != null && _email.isNotEmpty && _email.contains('@');

  bool _isSecurityKeyValid() => _securityKey != null && _securityKey.isNotEmpty && _securityKey == "12345";
}
