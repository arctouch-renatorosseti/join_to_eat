import 'package:join_to_eat/app/meeting/meeting_event.dart';
import 'package:join_to_eat/app/meeting/meeting_state.dart';
import 'package:bloc/bloc.dart';

class MeetingBloc extends Bloc<MeetingEvent, int> {
  @override
  int get initialState => 0;

  /// mapEventToState is a method that must be implemented when a class extends Bloc.
  /// The function takes the incoming event as an argument. mapEventToState is called whenever
  /// an event is dispatched by the presentation layer. mapEventToState must convert that event into a
  /// new state and return the new state in the form of a Stream which is consumed by the presentation layer.
  @override
  Stream<int> mapEventToState(MeetingEvent event) async* {
    switch (event) {
      case MeetingEvent.decrement:
        yield currentState - 1;
        break;
      case MeetingEvent.increment:
        yield currentState + 1;
        break;
    }
  }
}
