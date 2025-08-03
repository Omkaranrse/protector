import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protector/models/booking_model.dart';
// import 'package:protector/models/dress_code_model.dart';
import 'package:protector/pages/booking_confirmation_screen.dart';
import 'package:protector/providers/auth_provider.dart';
import 'package:protector/providers/booking_provider.dart';
import 'package:protector/services/notification_service.dart';
import 'package:protector/utils/page_transitions.dart';
import 'package:protector/widgets/loading_indicator.dart';

class BookingSummaryScreen extends StatefulWidget {
  final int protectees;
  final int protectors;
  final String dressCode;
  final int cars;
  final String pickupLocation;
  final DateTime pickupDate;
  final TimeOfDay pickupTime;
  final Duration protectionDuration;
  final bool isMember;

  const BookingSummaryScreen({
    Key? key,
    required this.protectees,
    required this.protectors,
    required this.dressCode,
    required this.cars,
    required this.pickupLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.protectionDuration,
    required this.isMember,
  }) : super(key: key);

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  bool _isLoading = false;
  double _calculatedPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _calculatePrice();
  }

  void _calculatePrice() {
    // Base price calculation
    double basePrice = 5000.0;
    
    // Add price for protectors
    basePrice += (widget.protectors * 1500.0);
    
    // Add price for cars
    basePrice += (widget.cars * 2000.0);
    
    // Add price for duration (per hour after first 2 hours)
    if (widget.protectionDuration.inHours > 2) {
      basePrice += ((widget.protectionDuration.inHours - 2) * 1000.0);
    }
    
    // Member discount
    if (widget.isMember) {
      basePrice = basePrice * 0.9; // 10% discount
    }
    
    setState(() {
      _calculatedPrice = basePrice;
    });
  }

  Future<void> _confirmBooking() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    
    if (!authProvider.isAuthenticated) {
      notificationService.showNotification(
        'Please login to confirm your booking',
        NotificationType.warning,
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Create booking object
      final booking = Booking(
        userId: authProvider.user!.id,
        protectees: widget.protectees,
        protectors: widget.protectors,
        dressCode: widget.dressCode,
        cars: widget.cars,
        pickupLocation: widget.pickupLocation,
        pickupDateTime: DateTime(
          widget.pickupDate.year,
          widget.pickupDate.month,
          widget.pickupDate.day,
          widget.pickupTime.hour,
          widget.pickupTime.minute,
        ),
        durationHours: widget.protectionDuration.inHours,
        price: _calculatedPrice,
        status: BookingStatus.pending,
      );
      
      // Save booking
      final success = await bookingProvider.createBooking(
        authProvider.token!,
        booking
      );
      
      if (!mounted) return;
      
      if (success) {
        // Navigate to confirmation screen with the booking ID
        Navigator.of(context).pushReplacement(
          PageTransitions.fadeTransition(
            BookingConfirmationScreen(bookingId: bookingProvider.currentBooking!.id),
          ),
        );
      } else {
        notificationService.showNotification(
          bookingProvider.errorMessage ?? 'Failed to create booking',
          NotificationType.error,
        );
      }
    } catch (e) {
      notificationService.showNotification(
        'Failed to create booking: ${e.toString()}',
        NotificationType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute $period';
  }

  String _formattedDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final endHour = widget.pickupTime.hour + widget.protectionDuration.inHours;
    final endTime = TimeOfDay(hour: endHour % 24, minute: widget.pickupTime.minute);
    final authProvider = Provider.of<AuthProvider>(context);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text('Booking Summary', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.white),
                title: Text(widget.pickupLocation, style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  '${_formattedDate(widget.pickupDate)} · ${_formatTime(widget.pickupTime)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.access_time, color: Colors.white),
                title: Text('Duration: ${widget.protectionDuration.inHours} hours', style: const TextStyle(color: Colors.white)),
                subtitle: Text('${_formatTime(widget.pickupTime)} — ${_formatTime(endTime)}', style: const TextStyle(color: Colors.white70)),
              ),
              ListTile(
                leading: const Icon(Icons.security, color: Colors.white),
                title: Text('${widget.protectors} Armed Protector(s)', style: const TextStyle(color: Colors.white)),
                subtitle: Text('${widget.protectees} Protectee(s)', style: const TextStyle(color: Colors.white70)),
              ),
              ListTile(
                leading: const Icon(Icons.checkroom, color: Colors.white),
                title: Text('Dress Code: ${widget.dressCode}', style: const TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: const Icon(Icons.directions_car, color: Colors.white),
                title: Text('Cars: ${widget.cars}', style: const TextStyle(color: Colors.white)),
                subtitle: const Text('Cadillac Escalade or similar', style: TextStyle(color: Colors.white70)),
              ),
              ListTile(
                leading: const Icon(Icons.card_membership, color: Colors.white),
                title: Text(widget.isMember ? 'Member' : 'Not a Member', style: const TextStyle(color: Colors.white)),
                subtitle: widget.isMember
                    ? const Text('10% Discount Applied', style: TextStyle(color: Colors.white70))
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                'Total Price: ₹${_calculatedPrice.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (!authProvider.isAuthenticated)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'You need to be logged in to confirm your booking',
                    style: TextStyle(color: Colors.amber, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text('Confirm Booking'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
