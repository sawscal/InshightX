import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const _key = 'user_preferences';

  static Future<void> savePreferences(List<String> preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, preferences);
  }

  static Future<List<String>> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? ['top']; // default
  }
}
