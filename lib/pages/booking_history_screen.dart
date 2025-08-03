import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protector/models/booking_model.dart';
import 'package:protector/pages/booking_details_screen.dart';
import 'package:protector/providers/auth_provider.dart';
import 'package:protector/providers/booking_provider.dart';
import 'package:protector/utils/page_transitions.dart';
import 'package:protector/widgets/booking_card.dart';
import 'package:protector/widgets/loading_indicator.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

      if (authProvider.token == null || authProvider.user == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'You need to be logged in to view your bookings';
        });
        return;
      }

      await bookingProvider.getUserBookings(
        authProvider.token!,
        authProvider.user!.id,
      );

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load bookings';
      });
    }
  }

  void _viewBookingDetails(Booking booking) {
    Navigator.of(context).push(
      PageTransitions.slideRightTransition(
        BookingDetailsScreen(bookingId: booking.id),
      ),
    ).then((_) => _loadBookings()); // Refresh on return
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingMessage: 'Loading bookings...',
        child: _errorMessage != null
            ? _buildErrorView()
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingList(BookingFilter.upcoming),
                  _buildBookingList(BookingFilter.past),
                  _buildBookingList(BookingFilter.all),
                ],
              ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadBookings,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(BookingFilter filter) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, _) {
        final bookings = _filterBookings(bookingProvider.userBookings, filter);

        if (bookings.isEmpty) {
          return _buildEmptyView(filter);
        }

        return RefreshIndicator(
          onRefresh: _loadBookings,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return BookingCard(
                booking: booking,
                onTap: () => _viewBookingDetails(booking),
                onCancel: booking.status == BookingStatus.pending
                    ? () => _viewBookingDetails(booking)
                    : null,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyView(BookingFilter filter) {
    String message;
    switch (filter) {
      case BookingFilter.upcoming:
        message = 'You have no upcoming bookings';
        break;
      case BookingFilter.past:
        message = 'You have no past bookings';
        break;
      case BookingFilter.all:
        message = 'You have no bookings yet';
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate to booking screen
                Navigator.of(context).pop();
                // Select the booking tab in the main navigation
                // This would typically be handled by a navigation service or state management
              },
              child: const Text('Book a Protector'),
            ),
          ],
        ),
      ),
    );
  }

  List<Booking> _filterBookings(List<Booking> bookings, BookingFilter filter) {
    final now = DateTime.now();
    
    switch (filter) {
      case BookingFilter.upcoming:
        return bookings
            .where((booking) =>
                booking.pickupDateTime.isAfter(now) &&
                booking.status != BookingStatus.cancelled)
            .toList()
            ..sort((a, b) => a.pickupDateTime.compareTo(b.pickupDateTime));
      
      case BookingFilter.past:
        return bookings
            .where((booking) =>
                booking.pickupDateTime.isBefore(now) ||
                booking.status == BookingStatus.cancelled ||
                booking.status == BookingStatus.completed)
            .toList()
            ..sort((a, b) => b.pickupDateTime.compareTo(a.pickupDateTime)); // Reverse chronological
      
      case BookingFilter.all:
        return bookings
            .toList()
            ..sort((a, b) => b.pickupDateTime.compareTo(a.pickupDateTime)); // Reverse chronological
    }
  }
}

enum BookingFilter {
  upcoming,
  past,
  all,
}