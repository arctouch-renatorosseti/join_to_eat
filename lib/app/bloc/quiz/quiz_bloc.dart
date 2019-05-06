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

  int currentOptionNumbers = 3;

  @override
  QuizState get initialState => QuizState(currentOptionNumbers, false);

  @override
  Stream<QuizState> mapEventToState(QuizEvent event) async* {
    switch (event) {
      case QuizEvent.ADD_QUIZ_OPTION:
        print("Estou aqui ${initialState.optionNumbers}");
        currentOptionNumbers++;
        yield QuizState((currentOptionNumbers > 6) ? 6 : currentOptionNumbers, false);
        break;
    }
  }
}
