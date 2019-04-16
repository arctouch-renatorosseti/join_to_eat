
import 'package:join_to_eat/app/model/meeting.dart';

abstract class MeetingState {}

class UninitializedState extends MeetingState {
  @override
  String toString() => 'UninitializedState';
}

class ErrorState extends MeetingState {
  @override
  String toString() => 'ErrorState';
}

class NoInternetConnectionState extends MeetingState {
  @override
  String toString() => 'NoInternetConnectionState';
}

class MeetingsLoadedState extends MeetingState {
  final List<Meeting> meetings;

  MeetingsLoadedState(this.meetings);

  @override
  String toString() => 'MeetingsLoadedState';
}

class OfflineDataState extends MeetingState {
  final List<Meeting> meetings;

  OfflineDataState({this.meetings});

  @override
  String toString() =>
      'OfflineDataState { movies: ${meetings.length}';
}