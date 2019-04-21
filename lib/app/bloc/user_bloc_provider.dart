import 'package:flutter/cupertino.dart';
import 'package:join_to_eat/app/bloc/user_bloc.dart';

class UsersBlocProvider extends InheritedWidget {
  final bloc = UserBloc();

  UsersBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static UserBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(UsersBlocProvider) as UsersBlocProvider).bloc;
  }
}