import 'package:flutter/foundation.dart';
import 'package:protector/models/user_model.dart';
import 'package:protector/services/api/user_service.dart';
import 'package:protector/services/storage_service.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error
}

class AuthProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final StorageService _storageService = StorageService();
  
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _token;
  String? _errorMessage;
  bool _isAdmin = false;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  bool get isAdmin => _isAdmin;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Initialize auth state from storage
  Future<void> initAuth() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      if (token != null && token.isNotEmpty) {
        final user = await _storageService.getUser();
        if (user != null) {
          _token = token;
          _user = user;
          _isAdmin = user.isAdmin;
          _status = AuthStatus.authenticated;
        } else {
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Failed to initialize authentication';
    }

    notifyListeners();
  }

  // Send OTP for phone verification
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      return await _userService.sendOtp(phoneNumber);
    } catch (e) {
      _errorMessage = 'Failed to send OTP';
      return false;
    }
  }

  // Verify OTP and login
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userService.verifyOtp(phoneNumber, otp);
      
      if (response['success']) {
        _token = response['token'];
        _user = User.fromJson(response['user']);
        _isAdmin = _user!.isAdmin;
        
        // Save to secure storage
        await _storageService.saveToken(_token!);
        await _storageService.saveUser(_user!);
        
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = response['message'] ?? 'Verification failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'An error occurred during verification';
      notifyListeners();
      return false;
    }
  }

  // Admin login
  Future<bool> adminLogin(String username, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userService.adminLogin(username, password);
      
      if (response['success']) {
        _token = response['token'];
        _user = User.fromJson(response['user']);
        _isAdmin = true;
        
        // Save to secure storage
        await _storageService.saveToken(_token!);
        await _storageService.saveUser(_user!);
        
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = response['message'] ?? 'Login failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'An error occurred during login';
      notifyListeners();
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({String? name, String? email}) async {
    if (_user == null || _token == null) return false;

    try {
      final updatedUser = _user!.copyWith(
        name: name ?? _user!.name,
        email: email ?? _user!.email,
      );
      
      final success = await _userService.updateUserProfile(_token!, updatedUser);
      
      if (success) {
        _user = updatedUser;
        await _storageService.saveUser(_user!);
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _status = AuthStatus.unauthenticated;
    _user = null;
    _token = null;
    _isAdmin = false;
    
    await _storageService.clearAll();
    notifyListeners();
  }
}