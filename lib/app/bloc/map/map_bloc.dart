import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:join_to_eat/app/repository/repository.dart';

enum MapEvent { load }

class MapState extends Equatable {
  final String userId;
  final String photo;

  MapState({this.userId = "", this.photo = ""}) : super([userId]);
}

class MapBloc extends Bloc<MapEvent, MapState> {
  final _repository = MeetingRepository();

  @override
  MapState get initialState => MapState();

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    switch (event) {
      case MapEvent.load:
        yield await loadData();
        break;
    }
  }

  Future<MapState> loadData() async {
    String userId = await _repository.getSignedUser();

    User user = await _repository.getUser(userId);

    return MapState(userId: userId, photo: user?.photo);
  }
}
