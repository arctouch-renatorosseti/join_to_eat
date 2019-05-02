import 'package:bloc/bloc.dart';

enum QuizEvent { ADD_QUIZ_OPTION }

class QuizState {
  int optionNumbers;
  bool isLoading;

  QuizState(int optionNumbers, bool isLoading) {
    this.optionNumbers = optionNumbers;
    this.isLoading = isLoading;
  }
}

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  @override
  QuizState get initialState => QuizState(3, false);

  @override
  Stream<QuizState> mapEventToState(QuizEvent event) async* {
    switch (event) {
      case QuizEvent.ADD_QUIZ_OPTION:
        yield QuizState((initialState.optionNumbers + 1 > 6) ? 6 : initialState.optionNumbers + 1, false);
        break;
    }
  }
}
