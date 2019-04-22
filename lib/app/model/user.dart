import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class User extends Equatable  {
  final String id;
  final String firstName;
  final String lastName;
//  final String nickname;
  final String email;
//  final String phone;
//  final String jobTitle;
//  final String skills;
  String generatedKey;

  User({this.id, this.firstName, this.lastName, this.email}) : super([id,firstName,lastName,email]);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
    );
  }

}