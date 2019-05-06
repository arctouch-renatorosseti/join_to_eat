import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:sprintf/sprintf.dart';

enum RadarCardEvent { load }

class RadarCardState extends Equatable {
  final String title;
  final String creator;
  final int partySize;
  final DateTime date;
  final int distance;

  RadarCardState({this.title = "", this.creator = "", this.partySize = 0, this.date, this.distance = 0})
      : super([title, creator, date]);
}

class RadarCardBloc extends Bloc<RadarCardEvent, RadarCardState> {
  final _repository = MeetingRepository();
  final Meeting meeting;

  RadarCardBloc({this.meeting});

  @override
  RadarCardState get initialState => RadarCardState();

  @override
  Stream<RadarCardState> mapEventToState(RadarCardEvent event) async* {
    switch (event) {
      case RadarCardEvent.load:
        yield await loadData();
        break;
    }
  }

  Future<RadarCardState> loadData() async {
    String creator = Strings.radarNoCreator;

    if (meeting.users.isNotEmpty) {
      User user = await _repository.getUser(meeting.users[0]);

      if (user != null) {
        creator = sprintf("%s %s", [user.firstName, user.lastName]);
      }
    }

    PlacesDetailsResponse places = await Repository.places.getDetailsByPlaceId(meeting.idMapPlace);
    String title = meeting.description;

    if (title == null || title == "") {
      if (places.isOkay) title = places.result.name;
    } else {
      title = Strings.radarUntitledEvent;
    }

    return RadarCardState(
        title: title,
        creator: creator,
        partySize: meeting.users.length,
        date: meeting.startTime.toDate(),
        distance: 0); // TODO : distance
  }
}
