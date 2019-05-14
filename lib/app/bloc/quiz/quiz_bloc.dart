import 'package:bloc/bloc.dart';
import 'package:join_to_eat/app/model/option_quiz.dart';
import 'package:join_to_eat/app/model/quiz.dart';
import 'package:join_to_eat/app/repository/repository.dart';

enum QuizEvent { ADD_QUIZ_OPTION, SAVE_QUIZ }

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
  final _repository = QuizRepository();
  Quiz _quiz = Quiz();
  List<OptionQuiz> options = [];

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
      case QuizEvent.SAVE_QUIZ:
        _repository.insertQuiz(_quiz, options);
        break;
    }
  }

  onSaveQuestion(String value) => _quiz.question = value;

  onSaveOptionAnswers(String value, int index) => options[index - 1].answer = value;
}
