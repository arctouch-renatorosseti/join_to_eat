import 'package:flutter/services.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Future<UsersList> getUsers() async {
    String jsonUsers = await _loadUsersAsset();
    return _firestoreProvider.getJsonUsers(jsonUsers);
  }

  Future<String> _loadUsersAsset() async {
    return await rootBundle.loadString('assets/users.json');
  }

}