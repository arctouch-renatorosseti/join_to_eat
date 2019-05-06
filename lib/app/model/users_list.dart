import 'package:equatable/equatable.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'users_list.g.dart';

@JsonSerializable()
class UsersList extends Equatable {
  final List<User> users;

  UsersList({
    this.users,
  });

  factory UsersList.fromJsonFile(List<dynamic> parsedJson) {
    List<User> users = List<User>();
    users = parsedJson.map((i) => User.fromJsonFile(i)).toList();
    return UsersList(
      users: users,
    );
  }

  Map<String, dynamic> toJson() => _$UsersListToJson(this);

  factory UsersList.fromJson(Map<String, dynamic> json) => _$UsersListFromJson(json);
}
