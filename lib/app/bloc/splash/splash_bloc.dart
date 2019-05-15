import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_to_eat/app/model/single_event.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/utils/routes.dart';

class SplashState extends Equatable {
  final SingleEvent<String> route;

  SplashState({this.route}) : super([route]);

  factory SplashState.initial() => SplashState();

  factory SplashState.login() => SplashState(route: SingleEvent(Routes.login));

  factory SplashState.main() => SplashState(route: SingleEvent(Routes.main));
}

enum _SplashEvent { checkAuthentication }

class SplashBloc extends Bloc<_SplashEvent, SplashState> {
  final UserRepository _repository = UserRepository();

  SplashBloc() {
//    _repository.loadDataFromPingBoard();
  }

  @override
  SplashState get initialState => SplashState.initial();

  @override
  Stream<SplashState> mapEventToState(_SplashEvent event) async* {
    switch (event) {
      case _SplashEvent.checkAuthentication:
        yield* await _repository.isUserSigned().then((value) => navigateToView(value));
        break;
    }
  }

  Stream<SplashState> navigateToView(bool isUserLogged) async* {
    if (isUserLogged) {
      yield SplashState.main();
    } else {
      yield SplashState.login();
    }
  }

  checkAuthentication() => dispatch(_SplashEvent.checkAuthentication);
}
