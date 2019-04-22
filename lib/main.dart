import 'package:flutter/material.dart';
import 'package:join_to_eat/app/main_app.dart';
import 'package:join_to_eat/app/repository/load_json.dart';
import 'package:join_to_eat/app/bloc/user_bloc.dart';
void main() {
  /// Notify out Bloc of events by calling dispatch like so:
  final _usersBloc = UserBloc();
  runApp(MainApp());
//  loadJsonUsers();
}