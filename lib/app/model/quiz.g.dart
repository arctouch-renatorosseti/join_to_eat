// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) {
  return Quiz(
      question: json['question'], answersOptions: json['answersOptions'])
    ..userId = json['userId'] as String;
}

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'question': instance.question,
      'userId': instance.userId,
      'answersOptions': instance.answersOptions
    };
