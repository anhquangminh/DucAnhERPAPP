import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/application_user.dart';

class UserStorageHelper {
  static Future<ApplicationUser?> getCachedUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userInfo');
    if (userJson != null) {
      return ApplicationUser.fromJson(json.decode(userJson));
    }
    return null;
  }

  static Future<void> saveUserInfo(ApplicationUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInfo', json.encode(user.toJson()));
  }

  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userInfo');
  }
}
