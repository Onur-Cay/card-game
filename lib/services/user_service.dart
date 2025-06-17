import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/app_config.dart';

class UserService {
  static const String _userIdKey = 'user_id';
  final SharedPreferences _prefs;

  UserService(this._prefs);

  Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  Future<void> _setUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  Future<String> initializeUserId() async {
    String? existingUserId = await getUserId();

    if (existingUserId == null || existingUserId.isEmpty) {
      try {
        final response = await http.get(
          Uri.parse('${AppConfig.apiUrl}/player_id'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final newUserId = data['player_id'] as String;

          if (!_isValidUserId(newUserId)) {
            throw Exception('Invalid user ID received from server');
          }

          await _setUserId(newUserId);
          return newUserId;
        } else {
          throw Exception('Failed to get user ID: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to initialize user ID: $e');
      }
    }

    if (!_isValidUserId(existingUserId)) {
      await _prefs.remove(_userIdKey);
      return initializeUserId();
    }

    return existingUserId;
  }

  bool _isValidUserId(String userId) {
    if (userId.isEmpty) return false;
    if (userId.toLowerCase() == 'null') return false;
    if (userId.toLowerCase() == 'none') return false;
    return true;
  }

  Future<void> clearUserId() async {
    await _prefs.remove(_userIdKey);
  }
}
