import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserService? _userService;
  String? _userId;
  bool _isInitialized = false;

  UserProvider() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userService = UserService(prefs);
      _isInitialized = true;
      await initializeUserId();
    } catch (e) {
      // Handle initialization error silently
    }
  }

  Future<void> initializeUserId() async {
    if (!_isInitialized || _userService == null) {
      return;
    }
    _userId = await _userService!.initializeUserId();
    notifyListeners();
  }

  String? get userId => _userId;
  bool get isInitialized => _isInitialized;

  Future<void> reset() async {
    await _userService!.clearUserId();
    _userId = null;
    _isInitialized = false;
    notifyListeners();
  }
}
