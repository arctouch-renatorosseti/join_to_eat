// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      freeTimeText: json['freeTimeText'] as String,
      photo: json['photo'] as String,
      interests:
          (json['interests'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'freeTimeText': instance.freeTimeText,
      'photo': instance.photo,
      'interests': instance.interests
    };
