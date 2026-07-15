import 'package:_10_geo_tracker/models/recordroute_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DirectionsHistory {
  static SharedPreferences? _prefs;
  static const String historyKey = 'route_history';

  static Future<void> _initPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveHistory(List<RecordRoute> records) async {
    await _initPreferences();
    final jsonRecords = records.map((record) => record.toJson()).toList();
    await _prefs!.setStringList(historyKey, jsonRecords);
  }

  static Future<void> deleteHistory(int id) async {
    await _initPreferences();
    final jsonRecords = _prefs!.getStringList(historyKey) ?? [];
    jsonRecords.removeAt(id);
    await _prefs!.setStringList(historyKey, jsonRecords);
  }

  static Future<List<RecordRoute>> getHistory() async {
    await _initPreferences();
    final jsonRecords = _prefs!.getStringList(historyKey) ?? [];
    final records = jsonRecords.map((json) => RecordRoute.fromJson(json)).toList();
    return records;
  }
}
