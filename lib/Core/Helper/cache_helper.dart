import 'package:shared_preferences/shared_preferences.dart';

class CachePrfHelper {
  static SharedPreferences? _preferences;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save uid
  static Future<void> saveUid(String uid) async {
    await _preferences?.setString('uid', uid);
  }

  // Retrieve uid
  static String? getUid() {
    return _preferences?.getString('uid');
  }

  // Remove uid
  static Future<void> removeUid() async {
    await _preferences?.remove('uid');
  }
}
