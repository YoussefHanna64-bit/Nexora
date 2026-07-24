import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static const _isOnboardingCompleted = "isOnboardingCompleted";

  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOnboardingCompleted, true);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isOnboardingCompleted) ?? false;
  }
}
