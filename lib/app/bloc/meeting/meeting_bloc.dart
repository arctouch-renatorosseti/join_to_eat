import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/repository/repository.dart';

class MeetingState extends Equatable {
  String route;
  bool isLoading;

  MeetingState(String route, bool isLoading) {
    this.route = route;
    this.isLoading = isLoading;
  }
}

enum MeetingEvent { showMeetings, createMeeting, updateMeeting, userJoin, leave, delete }

class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  final _repository = MeetingRepository();

  @override
  MeetingState get initialState => MeetingState("", true);

  @override
  Stream<MeetingState> mapEventToState(MeetingEvent event) {
    switch (event) {
      case MeetingEvent.createMeeting:
        // TODO: Handle this case.
        break;
      case MeetingEvent.updateMeeting:
        // TODO: Handle this case.
        break;
      case MeetingEvent.showMeetings:
        // TODO: Handle this case.
        break;
      case MeetingEvent.userJoin:
        // TODO: Handle this case.
        break;
      case MeetingEvent.leave:
        // TODO: Handle this case.
        break;
      case MeetingEvent.delete:
        // TODO: Handle this case.
        break;
    }
    return null;
  }

  Future<String> getSignedUser() async {
    return await _repository.getSignedUser();
  }

  void create(Meeting meeting) {
    _repository.saveMeetingCollection(meeting);
  }

  void update(Meeting meeting) {
    _repository.saveMeetingCollection(meeting);
  }
}
