// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meeting _$MeetingFromJson(Map<String, dynamic> json) {
  return Meeting(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      idMapPlace: json['idMapPlace'] as String,
      users: (json['users'] as List)?.map((e) => e as String)?.toList(),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      expiredTime: json['expiredTime'] == null
          ? null
          : DateTime.parse(json['expiredTime'] as String));
}

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'idMapPlace': instance.idMapPlace,
      'users': instance.users,
      'expiredTime': instance.expiredTime?.toIso8601String(),
      'time': instance.time?.toIso8601String()
    };
