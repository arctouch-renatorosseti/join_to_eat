import 'package:equatable/equatable.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class UsersList extends Equatable {
  final List<User> users;

  UsersList({
    this.users,
  });

  factory UsersList.fromJson(List<dynamic> parsedJson) {
    List<User> users = List<User>();
    users = parsedJson.map((i) => User.fromJson(i)).toList();
    return UsersList(
      users: users,
    );
  }
}
