import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;

  final String firstName;
  final String lastName;
  final String freeTimeText;
  final List<String> interests;

//  final String nickname;
  final String email;

//  final String phone;
//  final String jobTitle;
//  final String skills;
  String generatedKey;

  User({this.id, this.firstName, this.lastName, this.email, this.freeTimeText, this.interests})
      : super([id, firstName, lastName, email, freeTimeText]);

  factory User.fromJsonFile(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      freeTimeText: json['custom_fields']['f58357'] as String,
      interests: json['interests'].cast<String>(),
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
