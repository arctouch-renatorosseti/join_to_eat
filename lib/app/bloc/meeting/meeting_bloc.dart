import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/repository/repository.dart';
import 'package:join_to_eat/app/utils/routes.dart';

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
  Meeting _meeting;

  @override
  MeetingState get initialState => MeetingState("", true);

  @override
  Stream<MeetingState> mapEventToState(MeetingEvent event) async* {
    switch (event) {
      case MeetingEvent.createMeeting:
        await _repository.saveMeetingCollection(_meeting);
        yield MeetingState(Routes.listMeetings,true);
        break;
      case MeetingEvent.updateMeeting:

        break;
      case MeetingEvent.showMeetings:

        break;
      case MeetingEvent.userJoin:

        break;
      case MeetingEvent.leave:

        break;
      case MeetingEvent.delete:

        break;
    }
  }

  Future<String> getSignedUser() async {
    return await _repository.getSignedUser();
  }

  void update(Meeting meeting) {
    _repository.saveMeetingCollection(meeting);
  }

  onSave(Meeting value) => _meeting = value;
}
