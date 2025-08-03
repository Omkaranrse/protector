import 'package:protector/models/user_model.dart';

class StorageService {
  String? _token;
  User? _user;
  bool _isAdmin = false;

  // Save auth token
  Future<void> saveToken(String token) async {
    _token = token;
  }

  // Get auth token
  Future<String?> getToken() async {
    return _token;
  }

  // Save user data
  Future<void> saveUser(User user) async {
    _user = user;
    _isAdmin = user.isAdmin;
  }

  // Get user data
  Future<User?> getUser() async {
    return _user;
  }

  // Check if user is admin
  Future<bool> isAdmin() async {
    return _isAdmin;
  }

  // Clear all stored data (logout)
  Future<void> clearAll() async {
    _token = null;
    _user = null;
    _isAdmin = false;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return _token != null && _token!.isNotEmpty;
  }
}