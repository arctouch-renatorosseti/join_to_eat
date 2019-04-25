import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/model/single_event.dart';
import 'package:join_to_eat/app/repository/repository.dart';

class MeetingState extends Equatable {
  String route;
  bool isLoading;

  MeetingState(String route, bool isLoading) {
    this.route = route;
    this.isLoading = isLoading;
  }
}

enum _MeetingEvent { showMeetings, createMeeting, updateMeeting, userJoin, leave, delete }

class MeetingBloc extends Bloc<_MeetingEvent, MeetingState> {
  final _repository = MeetingRepository();

  @override
  MeetingState get initialState => MeetingState("", true);

  @override
  Stream<MeetingState> mapEventToState(_MeetingEvent event) {
    switch (event) {
      case _MeetingEvent.createMeeting:
        // TODO: Handle this case.
        break;
      case _MeetingEvent.updateMeeting:
        // TODO: Handle this case.
        break;
      case _MeetingEvent.showMeetings:
        // TODO: Handle this case.
        break;
      case _MeetingEvent.userJoin:
        // TODO: Handle this case.
        break;
      case _MeetingEvent.leave:
        // TODO: Handle this case.
        break;
      case _MeetingEvent.delete:
        // TODO: Handle this case.
        break;
    }
    return null;
  }

  void create(Meeting meeting) {
    _repository.saveMeetingCollection(meeting);
  }

  void update(Meeting meeting) {
    _repository.saveMeetingCollection(meeting);
  }
}
