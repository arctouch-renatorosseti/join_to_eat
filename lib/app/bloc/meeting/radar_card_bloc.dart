import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:sprintf/sprintf.dart';

enum RadarCardEvent { startStream, load, joinMeeting }

class RadarCardState extends Equatable {
  final String placeName;
  final String title;
  final String creator;
  final int partySize;
  final DateTime date;
  final int distance;
  final String address;

  RadarCardState(
      {this.placeName = "",
      this.title = "",
      this.creator = "",
      this.partySize = 0,
      this.date,
      this.distance = 0,
      this.address = ""})
      : super([placeName, creator, date, address]);
}

class RadarCardBloc extends Bloc<RadarCardEvent, RadarCardState> {
  final _repository = MeetingRepository();

  Meeting meeting;
  List<User> meetingUsers = List<User>();
  String currentUser;

  RadarCardBloc({this.meeting});

  @override
  RadarCardState get initialState => RadarCardState();

  @override
  Stream<RadarCardState> mapEventToState(RadarCardEvent event) async* {
    switch (event) {
      case RadarCardEvent.startStream:
        _repository.getMeeting(this.meeting).listen((meeting) => _consumeStream(meeting), onDone: _onDone);
        currentUser = await _repository.getSignedUser();
        break;
      case RadarCardEvent.load:
        yield await loadData();
        break;
      case RadarCardEvent.joinMeeting:
        yield await joinMeeting();
        break;
    }
  }

  void _consumeStream(Meeting meeting) {
    this.meeting = meeting;
    this.dispatch(RadarCardEvent.load);
  }

  Future<void> loadUsersImage() async {
    for (String userId in meeting.users) {
      _repository.getUser(userId).then((value) => _handleUserPhotosRequest(value));
    }
  }

  void _handleUserPhotosRequest(User user) {
    if (!meetingUsers.contains(user)) {
      meetingUsers.add(user);
    }
  }

  Future<RadarCardState> joinMeeting() async {
    List<String> users = meeting.users;

    await _toggleJoin(users, user);

    return await loadData();
  }

  bool hasJoined() {
    return meetingUsers.contains(user);
  }

  Future<void> _toggleJoin(List<String> users, String loggedUserId) async {
    if (!users.contains(loggedUserId)) {
      meeting.users.add(loggedUserId);
    } else {
      meeting.users.remove(loggedUserId);
    }

    await _repository.updateMeetingCollection(meeting);

    return await loadData();
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
    String address = places.isOkay ? places.result.vicinity : "";
    if (title == null || title.isEmpty) {
      if (places.isOkay)
        title = places.result.name;
      else
        title = Strings.radarUntitledEvent;
    }

    loadUsersImage();

    return RadarCardState(
        placeName: placeName,
        title: title,
        creator: creator,
        partySize: meeting.users.length,
        date: meeting.startTime.toDate(),
        distance: 0, // TODO : distance
        address: address);
  }
}
