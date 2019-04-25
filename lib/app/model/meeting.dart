import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'meeting.g.dart';

@JsonSerializable()
class Meeting extends Equatable {
  String id;
  String title;
  String description;
  String idMapPlace;
  List<String> users;
  DateTime expiredTime;
  DateTime time;

  Meeting({this.id, this.title, this.description, this.idMapPlace, this.users, this.time, this.expiredTime})
      : super([id, title, description, idMapPlace, users, time, expiredTime]);

  factory Meeting.fromJson(Map<String, dynamic> json) => _$MeetingFromJson(json);

  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}
