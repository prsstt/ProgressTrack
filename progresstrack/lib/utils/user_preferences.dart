// lib/models/user_preferences.dart
import 'package:progresstrack/utils/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static User user = User();
  static SharedPreferences? prefs;
}
