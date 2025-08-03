import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:protector/models/booking_model.dart';

class BookingService {
  // This would be replaced with actual API base URL
  static const String _baseUrl = 'https://api.protector.example.com';
  
  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Create a new booking
  Future<Map<String, dynamic>> createBooking(String token, Booking booking) async {
    try {
      await _simulateNetworkDelay();
      
      // In a real app, this would send the booking data to the backend
      // For now, we'll just return a success response with the booking
      return {
        'success': true,
        'booking': booking.toJson(),
      };
    } catch (e) {
      debugPrint('Error creating booking: $e');
      return {
        'success': false,
        'message': 'An error occurred while creating the booking',
      };
    }
  }

  // Get all bookings for a user
  Future<List<Booking>> getUserBookings(String token, String userId) async {
    try {
      await _simulateNetworkDelay();
      
      // In a real app, this would fetch bookings from the backend
      // For now, we'll return mock bookings
      final random = Random();
      final List<Booking> mockBookings = [];
      
      // Generate 5 mock bookings with different statuses
      final statuses = BookingStatus.values;
      final locations = [
        'Taj Mahal Palace, Mumbai',
        'The Oberoi, New Delhi',
        'ITC Grand Chola, Chennai',
        'The Leela Palace, Bengaluru',
        'Rambagh Palace, Jaipur',
      ];
      
      final now = DateTime.now();
      
      for (int i = 0; i < 5; i++) {
        final status = statuses[random.nextInt(statuses.length)];
        final location = locations[i % locations.length];
        final daysOffset = i * 2 - 4; // Some in past, some in future
        
        mockBookings.add(Booking(
          id: 'booking-${100 + i}',
          userId: userId,
          protectees: random.nextInt(3) + 1,
          protectors: random.nextInt(2) + 1,
          dressCode: ['Business Casual', 'Business Formal', 'Operator', 'Tactical Casual'][random.nextInt(4)],
          cars: random.nextInt(2) + 1,
          pickupLocation: location,
          pickupDateTime: DateTime(now.year, now.month, now.day + daysOffset, 10 + random.nextInt(8), 0),
          durationHours: (random.nextInt(4) + 1) * 2, // 2, 4, 6, or 8 hours
          price: 5000 + random.nextInt(5000).toDouble(),
          status: status,
          createdAt: DateTime.now().subtract(Duration(days: random.nextInt(10))),
        ));
      }
      
      return mockBookings;
    } catch (e) {
      debugPrint('Error getting user bookings: $e');
      return [];
    }
  }

  // Get a specific booking by ID
  Future<Booking?> getBookingById(String token, String bookingId) async {
    try {
      await _simulateNetworkDelay();
      
      // In a real app, this would fetch the booking from the backend
      // For now, we'll return a mock booking
      final random = Random();
      
      return Booking(
        id: bookingId,
        userId: '123456',
        protectees: random.nextInt(3) + 1,
        protectors: random.nextInt(2) + 1,
        dressCode: ['Business Casual', 'Business Formal', 'Operator', 'Tactical Casual'][random.nextInt(4)],
        cars: random.nextInt(2) + 1,
        pickupLocation: 'Taj Mahal Palace, Mumbai',
        pickupDateTime: DateTime.now().add(const Duration(days: 2)),
        durationHours: (random.nextInt(4) + 1) * 2, // 2, 4, 6, or 8 hours
        price: 5000 + random.nextInt(5000).toDouble(),
        status: BookingStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      );
    } catch (e) {
      debugPrint('Error getting booking by ID: $e');
      return null;
    }
  }

  // Update booking status (for admin)
  Future<bool> updateBookingStatus(String token, String bookingId, BookingStatus newStatus) async {
    try {
      await _simulateNetworkDelay();
      
      // In a real app, this would update the booking status in the backend
      // For now, we'll just return success
      return true;
    } catch (e) {
      debugPrint('Error updating booking status: $e');
      return false;
    }
  }

  // Get all bookings (for admin)
  Future<List<Booking>> getAllBookings(String token) async {
    try {
      await _simulateNetworkDelay();
      
      // In a real app, this would fetch all bookings from the backend
      // For now, we'll return mock bookings
      final random = Random();
      final List<Booking> mockBookings = [];
      
      // Generate 10 mock bookings with different statuses
      final statuses = BookingStatus.values;
      final locations = [
        'Taj Mahal Palace, Mumbai',
        'The Oberoi, New Delhi',
        'ITC Grand Chola, Chennai',
        'The Leela Palace, Bengaluru',
        'Rambagh Palace, Jaipur',
      ];
      
      final now = DateTime.now();
      
      for (int i = 0; i < 10; i++) {
        final status = statuses[random.nextInt(statuses.length)];
        final location = locations[i % locations.length];
        final daysOffset = i - 5; // Some in past, some in future
        
        mockBookings.add(Booking(
          id: 'booking-${100 + i}',
          userId: 'user-${200 + i % 3}', // Simulate a few different users
          protectees: random.nextInt(3) + 1,
          protectors: random.nextInt(2) + 1,
          dressCode: ['Business Casual', 'Business Formal', 'Operator', 'Tactical Casual'][random.nextInt(4)],
          cars: random.nextInt(2) + 1,
          pickupLocation: location,
          pickupDateTime: DateTime(now.year, now.month, now.day + daysOffset, 10 + random.nextInt(8), 0),
          durationHours: (random.nextInt(4) + 1) * 2, // 2, 4, 6, or 8 hours
          price: 5000 + random.nextInt(5000).toDouble(),
          status: status,
          createdAt: DateTime.now().subtract(Duration(days: random.nextInt(10))),
        ));
      }
      
      return mockBookings;
    } catch (e) {
      debugPrint('Error getting all bookings: $e');
      return [];
    }
  }

  // Cancel a booking
  Future<bool> cancelBooking(String token, String bookingId) async {
    try {
      await _simulateNetworkDelay();
      
      // In a real app, this would cancel the booking in the backend
      // For now, we'll just return success
      return true;
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      return false;
    }
  }
}