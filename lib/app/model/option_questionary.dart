import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'option_questionary.g.dart';

@JsonSerializable()
class OptionsQuestionary extends Equatable {
  String answer;
  int selectedTimes;
  OptionsQuestionary({answer, selectedTimes})
      : super([answer, selectedTimes]) {
  }

  factory OptionsQuestionary.fromJson(Map<String, dynamic> json) => _$OptionsQuestionaryFromJson(json);

  Map<String, dynamic> toJson() => _$OptionsQuestionaryToJson(this);
}