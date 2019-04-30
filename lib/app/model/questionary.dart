import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'questionary.g.dart';

@JsonSerializable()
class Questionary extends Equatable {
  String question;
  List<String> answersOptions;

  Questionary({question, answersOptions})
      : super([question, answersOptions]) {
  }

  factory Questionary.fromJson(Map<String, dynamic> json) => _$QuestionaryFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionaryToJson(this);
}