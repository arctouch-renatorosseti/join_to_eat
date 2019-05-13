import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'option_quiz.g.dart';

@JsonSerializable()
class OptionQuiz extends Equatable {
  String answer;
  int selectedTimes;
  OptionQuiz({answer, selectedTimes})
      : super([answer, selectedTimes]) {
  }

  factory OptionQuiz.fromJson(Map<String, dynamic> json) => _$OptionsQuizFromJson(json);

  Map<String, dynamic> toJson() => _$OptionsQuizToJson(this);
}