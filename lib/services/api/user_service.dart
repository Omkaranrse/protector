import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:protector/models/user_model.dart';

class UserService {
  // This would be replaced with actual API base URL
  static const String _baseUrl = 'https://api.protector.example.com';
  
  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Verify phone number (send OTP)
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      await _simulateNetworkDelay();
      // In a real app, this would make an API call to send OTP
      // For now, we'll just return success
      return true;
    } catch (e) {
      debugPrint('Error sending OTP: $e');
      return false;
    }
  }

  // Verify OTP and login
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    try {
      await _simulateNetworkDelay();
      
      // In a real app, this would verify the OTP with the backend
      // For now, we'll simulate a successful verification with any 6-digit OTP
      if (otp.length == 6) {
        // Generate a fake JWT token
        const String fakeToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IlByb3RlY3RvciBVc2VyIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
        
        // Create a mock user
        final user = User(
          id: '123456',
          name: 'John Doe',
          phoneNumber: phoneNumber,
          isAdmin: false,
        );
        
        return {
          'success': true,
          'token': fakeToken,
          'user': user.toJson(),
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid OTP',
        };
      }
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
      return {
        'success': false,
        'message': 'An error occurred',
      };
    }
  }

  // Admin login
  Future<Map<String, dynamic>> adminLogin(String username, String password) async {
    try {
      await _simulateNetworkDelay();
      
      // In a real app, this would verify admin credentials with the backend
      // For now, we'll use a hardcoded admin/admin123 credential
      if (username == 'admin' && password == 'admin123') {
        // Generate a fake JWT token
        const String fakeToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsIm5hbWUiOiJBZG1pbiBVc2VyIiwiaWF0IjoxNTE2MjM5MDIyLCJpc0FkbWluIjp0cnVlfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
        
        // Create a mock admin user
        final user = User(
          id: 'admin123',
          name: 'Admin User',
          phoneNumber: '+911234567890',
          isAdmin: true,
        );
        
        return {
          'success': true,
          'token': fakeToken,
          'user': user.toJson(),
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid credentials',
        };
      }
    } catch (e) {
      debugPrint('Error in admin login: $e');
      return {
        'success': false,
        'message': 'An error occurred',
      };
    }
  }

  // Get user profile
  Future<User?> getUserProfile(String token) async {
    try {
      await _simulateNetworkDelay();
      
      // In a real app, this would fetch the user profile from the backend
      // For now, we'll return a mock user
      return User(
        id: '123456',
        name: 'John Doe',
        phoneNumber: '+911234567890',
        email: 'john.doe@example.com',
      );
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(String token, User user) async {
    try {
      await _simulateNetworkDelay();
      
      // In a real app, this would update the user profile in the backend
      // For now, we'll just return success
      return true;
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      return false;
    }
  }

  // Logout (in a real app, this might invalidate the token on the server)
  Future<bool> logout(String token) async {
    try {
      await _simulateNetworkDelay();
      // In a real app, this would invalidate the token on the server
      // For now, we'll just return success
      return true;
    } catch (e) {
      debugPrint('Error logging out: $e');
      return false;
    }
  }
}