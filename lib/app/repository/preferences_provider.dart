import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider {

  static const String USER_SIGNED = "USER_SIGNED";

  Future<bool> getUserSigned() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(USER_SIGNED) ?? false;
  }

  Future<bool> setUserSigned(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(USER_SIGNED, value);
  }

}