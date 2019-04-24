import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider {

  final String _userSigned = "allowNotifications";

  Future<bool> getUserSigned() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_userSigned) ?? '';
  }

  Future<bool> setUserSigned(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_userSigned, value);
  }

}