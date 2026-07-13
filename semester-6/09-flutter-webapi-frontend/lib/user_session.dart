import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static SharedPreferences? _prefs;
  static Future<void> _iniPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  static Future<void> saveSession(int userId) async {
    await _iniPreferences();
    await _prefs!.setInt('user_id', userId);
  }
  static Future<void> removeSession() async {
    await _iniPreferences();
    await _prefs!.remove('user_id');
  }
  static Future<int?> getSession() async {
    await _iniPreferences();
    return _prefs!.getInt('user_id');
  }
}