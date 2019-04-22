import 'package:flutter/cupertino.dart';
import 'package:join_to_eat/app/bloc/auth_bloc.dart';

class AuthBlocProvider extends InheritedWidget {
  final bloc = AuthBloc();

  AuthBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static AuthBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AuthBlocProvider)
            as AuthBlocProvider)
        .bloc;
  }
}
