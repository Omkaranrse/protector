import 'package:flutter/foundation.dart';
import 'package:protector/models/booking_model.dart';
import 'package:protector/services/api/booking_service.dart';

class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();
  
  List<Booking> _userBookings = [];
  List<Booking> _allBookings = []; // For admin
  Booking? _currentBooking;
  bool _isLoading = false;
  String? _errorMessage;

  List<Booking> get userBookings => _userBookings;
  List<Booking> get allBookings => _allBookings;
  Booking? get currentBooking => _currentBooking;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Create a new booking
  Future<bool> createBooking(String token, Booking booking) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _bookingService.createBooking(token, booking);
      
      _isLoading = false;
      
      if (response['success']) {
        _currentBooking = Booking.fromJson(response['booking']);
        _userBookings.add(_currentBooking!);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to create booking';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred while creating the booking';
      notifyListeners();
      return false;
    }
  }

  // Get all bookings for a user
  Future<void> getUserBookings(String token, String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final bookings = await _bookingService.getUserBookings(token, userId);
      _userBookings = bookings;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load bookings';
      notifyListeners();
    }
  }

  // Get a specific booking by ID
  Future<Booking?> getBookingById(String token, String bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final booking = await _bookingService.getBookingById(token, bookingId);
      _currentBooking = booking;
      _isLoading = false;
      notifyListeners();
      return booking;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load booking details';
      notifyListeners();
      return null;
    }
  }

  // Update booking status (for admin)
  Future<bool> updateBookingStatus(String token, String bookingId, BookingStatus newStatus) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _bookingService.updateBookingStatus(token, bookingId, newStatus);
      
      _isLoading = false;
      
      if (success) {
        // Update the booking in the lists
        final userBookingIndex = _userBookings.indexWhere((b) => b.id == bookingId);
        if (userBookingIndex != -1) {
          _userBookings[userBookingIndex] = _userBookings[userBookingIndex].copyWith(status: newStatus);
        }
        
        final allBookingIndex = _allBookings.indexWhere((b) => b.id == bookingId);
        if (allBookingIndex != -1) {
          _allBookings[allBookingIndex] = _allBookings[allBookingIndex].copyWith(status: newStatus);
        }
        
        if (_currentBooking?.id == bookingId) {
          _currentBooking = _currentBooking!.copyWith(status: newStatus);
        }
        
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to update booking status';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred while updating the booking';
      notifyListeners();
      return false;
    }
  }

  // Get all bookings (for admin)
  Future<void> getAllBookings(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final bookings = await _bookingService.getAllBookings(token);
      _allBookings = bookings;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load all bookings';
      notifyListeners();
    }
  }

  // Cancel a booking
  Future<bool> cancelBooking(String token, String bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _bookingService.cancelBooking(token, bookingId);
      
      _isLoading = false;
      
      if (success) {
        // Update the booking status in the lists
        return await updateBookingStatus(token, bookingId, BookingStatus.cancelled);
      } else {
        _errorMessage = 'Failed to cancel booking';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred while cancelling the booking';
      notifyListeners();
      return false;
    }
  }

  // Clear current booking
  void clearCurrentBooking() {
    _currentBooking = null;
    notifyListeners();
  }
}