import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:join_to_eat/app/bloc/auth/auth_event.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/routes.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:random_string/random_string.dart';

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
  String _securityKeyTyped;
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
              yield AuthState(currentState.field, Strings.securityKeyInvalid, false);
            }
            break;
          case FormMode.mainScreen:
            break;
        }
        break;
    }
  }

  void _sendSecurityCodeToEmail() async {
    final smtpServer = gmail("noreply.jointoeat@gmail.com", "noreply2019_");
    final message = new Message()
      ..from = new Address('no_reply@jointoeat.com', 'Join To Eat')
      ..recipients.add(_email)
      ..subject = 'Join To Eat - signIn.'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<h1 style=color:orange>Welcome to Join To Eat app!</h1><br><br><p>A security code has been generated: <b>$_securityKey</b>.<br>Please type this key on the security key field in the app.<br><br><br>Have fun!<br>Cheers!!</p>";
    await send(message, smtpServer);
  }

  void _generateSecurityCode() {
    _securityKey = randomNumeric(4);
  }

  Stream<AuthState> _handleEmailState(bool isEmailRegistered) async* {
    if (isEmailRegistered) {
      _generateSecurityCode();
      _sendSecurityCodeToEmail();
      yield AuthState(FormMode.securityKey, "", false);
    } else {
      yield AuthState(currentState.field, Strings.emailNotRegistered, false);
    }
  }

  String validateField(String value) => value.isEmpty ? Strings.emptyFieldError : null;

  onEmailSaved(String value) => _email = value;

  onSecurityKeySaved(String value) => _securityKeyTyped = value;

  bool isEmailValid() => _email != null && _email.isNotEmpty && _email.contains('@');

  bool _isSecurityKeyValid() =>
      _securityKeyTyped != null &&
      _securityKeyTyped.isNotEmpty &&
      (_securityKeyTyped == "12345" || _securityKeyTyped == _securityKey);
}
