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
  final List<String> partyPhotos;
  final DateTime date;
  final int distance;
  final String address;
  final bool isCreator;
  final bool hasJoined;

  RadarCardState(
      {this.placeName = "",
      this.title = "",
      this.creator = "",
      this.partySize = 0,
      this.partyPhotos,
      this.date,
      this.distance = 0,
      this.address = "",
      this.isCreator = false,
      this.hasJoined = false})
      : super([placeName, title, creator, partySize, date, distance, address, isCreator, hasJoined]);
}

class RadarCardBloc extends Bloc<RadarCardEvent, RadarCardState> {
  final _repository = MeetingRepository();

  Meeting meeting;
  String currentUser;

  RadarCardBloc({this.meeting});

  @override
  RadarCardState get initialState => RadarCardState();

  @override
  Stream<RadarCardState> mapEventToState(RadarCardEvent event) async* {
    switch (event) {
      case RadarCardEvent.startStream:
        currentUser = await _repository.getSignedUser();

        _repository.getMeeting(this.meeting).listen((meeting) => _consumeStream(meeting));
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

  Future<RadarCardState> joinMeeting() async {
    List<String> users = meeting.users;

    await _toggleJoin(users, currentUser);

    return await loadData();
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
    bool isCreator = false;
    String creator = Strings.radarNoCreator;

    List<String> partyPhotos = List<String>();

    bool isFirstUser = true;
    for (String userId in meeting.users) {
      User user = await _repository.getUser(userId);

      if (user != null) {
        if (isFirstUser) {
          isCreator = currentUser == userId;
          creator = sprintf("%s %s", [user.firstName, user.lastName]);
          isFirstUser = false;
        }

        if (user.photo != null && user.photo.isNotEmpty) {
          partyPhotos.add(user.photo);
        }
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

    return RadarCardState(
        placeName: placeName,
        title: title,
        creator: creator,
        partySize: meeting.users.length,
        partyPhotos: partyPhotos,
        date: meeting.startTime.toDate(),
        distance: 0, // TODO : distance
        address: address,
        isCreator: isCreator,
        hasJoined: meeting.users.indexOf(currentUser) > 0);
  }
}
