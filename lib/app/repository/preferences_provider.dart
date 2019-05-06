import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider {

  static const String USER_SIGNED_STATUS = "USER_SIGNED_STATUS";
  static const String USER_SIGNED = "USER_SIGNED";

  Future<bool> getUserSignedStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(USER_SIGNED_STATUS) ?? false;
  }

  Future<bool> setUserSignedStatus(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(USER_SIGNED_STATUS, value);
  }

  Future<String> getUserSigned() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_SIGNED) ?? "";
  }

  Future<bool> setUserSigned(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(USER_SIGNED, value) ?? false;
  }
}