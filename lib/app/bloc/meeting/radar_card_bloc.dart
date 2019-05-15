import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:sprintf/sprintf.dart';

enum RadarCardEvent { load, joinMeeting, showUsers }

class RadarCardState extends Equatable {
  final String placeName;
  final String title;
  final String creator;
  final int partySize;
  final DateTime date;
  final int distance;

  RadarCardState({this.placeName = "", this.title = "", this.creator = "", this.partySize = 0, this.date, this.distance = 0})
      : super([placeName, creator, date]);
}

class RadarCardBloc extends Bloc<RadarCardEvent, RadarCardState> {
  final _repository = MeetingRepository();
  final Meeting meeting;
  List<String> photoUsers = List<String>();

  RadarCardBloc({this.meeting});

  @override
  RadarCardState get initialState => RadarCardState();

  @override
  Stream<RadarCardState> mapEventToState(RadarCardEvent event) async* {
    switch (event) {
      case RadarCardEvent.load:
        yield await loadData();
        break;
      case RadarCardEvent.joinMeeting:
        yield await joinMeeting();
        break;
      case RadarCardEvent.showUsers:
        yield await loadUsersImage();
        break;
    }
  }
  Future<RadarCardState> loadUsersImage() async {
    for(String userId in meeting.users) {
      _repository.getUser(userId).then((value) => print("Load user ${value}"));
          //handleUserPhotosRequest(value));
    }
  }

  Future<RadarCardState> handleUserPhotosRequest(User user) {
    if(!photoUsers.contains(user.photo)) {
      photoUsers.add(user.photo);
    }
  }

  Future<RadarCardState> joinMeeting() async {
    List<String> users = meeting.users;
    _repository.getSignedUser().then((onValue) => handleUpdateMeeting(users, onValue)).whenComplete(() => RadarCardState(
    placeName: meeting.description,
    creator: meeting.users.first,
    partySize: meeting.users.length,
    date: meeting.startTime.toDate(),
    distance: 0)  );
  }

  Future<void> handleUpdateMeeting(List<String> users, String loggedUserId) async {
    if (!users.contains(loggedUserId)) {
      meeting.users.add(loggedUserId);
      _repository.updateMeetingCollection(meeting);
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
    String placeName = places.isOkay ? places.result.name : "";
    if (title == null || title.isEmpty) {
      if (places.isOkay) title = places.result.name;
      else title = Strings.radarUntitledEvent;
    } 
    loadUsersImage();

    return RadarCardState(
        placeName: placeName,
        title: title,
        creator: creator,
        partySize: meeting.users.length,
        date: meeting.startTime.toDate(),
        distance: 0); // TODO : distance
  }
}
