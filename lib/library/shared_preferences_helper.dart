import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper._internal();
  static SharedPreferencesHelper get instance { return _preferencesHelper; }
  SharedPreferencesHelper._internal();

  /// Rotinas do Shared Preferences
  Future<bool> saveData(String nameKey, String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(nameKey, value);
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<String> loadData(String nameKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String response = prefs.getString(nameKey);
    return response ?? '';
  }

  Future<bool> deleteData(String nameKey) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.remove(nameKey);
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> clear() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.clear();
    } catch(e){}
    return false;
  }
}