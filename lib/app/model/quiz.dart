import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'quiz.g.dart';

@JsonSerializable()
class Quiz extends Equatable {
  String question;
  String userId;
  List<String> answersOptions = [];

  Quiz({question, answersOptions}) : super([question, answersOptions]) {
  }

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

  Map<String, dynamic> toJson() => _$QuizToJson(this);

}