import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  savePreferenceKeyValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  readPreferenceKeyValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    return value;
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
