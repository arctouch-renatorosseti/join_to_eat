// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questionary _$QuestionaryFromJson(Map<String, dynamic> json) {
  return Questionary(
      question: json['question'], answersOptions: json['answersOptions']);
}

Map<String, dynamic> _$QuestionaryToJson(Questionary instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answersOptions': instance.answersOptions
    };
