import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:join_to_eat/app/model/users_list.dart';

  Future<String> _loadUsersAsset() async {
    return await rootBundle.loadString('assets/users.json');
  }

  Future loadJsonUsers() async {
    String jsonUsers = await _loadUsersAsset();
    _parseJsonForUsers(jsonUsers);
  }

  void _parseJsonForUsers(String jsonString) {
    Map decoded = jsonDecode(jsonString);
    UsersList usersList = UsersList.fromJsonFile(decoded['users']);
    print("Lenght of users: ${usersList.users.length}");
  }