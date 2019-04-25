// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersList _$UsersListFromJson(Map<String, dynamic> json) {
  return UsersList(
      users: (json['users'] as List)
          ?.map((e) =>
              e == null ? null : User.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$UsersListToJson(UsersList instance) =>
    <String, dynamic>{'users': instance.users};
