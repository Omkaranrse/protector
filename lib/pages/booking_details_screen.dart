import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protector/models/booking_model.dart';
import 'package:protector/providers/auth_provider.dart';
import 'package:protector/providers/booking_provider.dart';
import 'package:protector/services/notification_service.dart';
import 'package:protector/widgets/loading_indicator.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailsScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _isLoading = true;
  Booking? _booking;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBookingDetails();
  }

  Future<void> _loadBookingDetails() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    if (authProvider.token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'You need to be logged in to view booking details';
      });
      return;
    }

    try {
      final booking = await bookingProvider.getBookingById(
        authProvider.token!,
        widget.bookingId,
      );

      setState(() {
        _booking = booking;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load booking details';
      });
    }
  }

  Future<void> _cancelBooking() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final notificationService = Provider.of<NotificationService>(context, listen: false);

    if (authProvider.token == null || _booking == null) return;

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final success = await bookingProvider.cancelBooking(
        authProvider.token!,
        _booking!.id,
      );

      if (success) {
        // Show notification
        notificationService.showBookingStatusUpdate(
          _booking!.id.substring(0, 8),
          'cancelled',
        );

        // Reload booking details
        await _loadBookingDetails();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to cancel booking';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred while cancelling the booking';
      });
    }
  }

  Future<void> _updateBookingStatus(BookingStatus newStatus) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final notificationService = Provider.of<NotificationService>(context, listen: false);

    if (authProvider.token == null || _booking == null || !authProvider.isAdmin) return;

    setState(() => _isLoading = true);

    try {
      final success = await bookingProvider.updateBookingStatus(
        authProvider.token!,
        _booking!.id,
        newStatus,
      );

      if (success) {
        // Show notification
        notificationService.showBookingStatusUpdate(
          _booking!.id.substring(0, 8),
          newStatus.name,
        );

        // Reload booking details
        await _loadBookingDetails();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to update booking status';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred while updating the booking';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingMessage: 'Loading booking details...',
        child: _errorMessage != null
            ? _buildErrorView()
            : _booking != null
                ? _buildBookingDetails(isAdmin)
                : const SizedBox(),
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
              onPressed: () => _loadBookingDetails(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetails(bool isAdmin) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookingHeader(),
            const SizedBox(height: 24),
            _buildInfoCard(),
            const SizedBox(height: 24),
            if (_booking!.status == BookingStatus.pending) ...[  
              if (isAdmin)
                _buildAdminActions()
              else
                _buildUserActions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookingHeader() {
    Color statusColor;
    switch (_booking!.status) {
      case BookingStatus.pending:
        statusColor = Colors.orange;
        break;
      case BookingStatus.confirmed:
        statusColor = Colors.green;
        break;
      case BookingStatus.completed:
        statusColor = Colors.blue;
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Booking #${_booking!.id.substring(0, 8)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _booking!.statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Created on ${_formatDate(_booking!.createdAt)}',
          style: TextStyle(color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Pickup Location', _booking!.pickupLocation),
            const Divider(),
            _buildInfoRow('Date', _booking!.formattedDate),
            const Divider(),
            _buildInfoRow('Time', _booking!.formattedTime),
            const Divider(),
            _buildInfoRow('Duration', '${_booking!.durationHours} hours'),
            const Divider(),
            _buildInfoRow('Protectees', _booking!.protectees.toString()),
            const Divider(),
            _buildInfoRow('Protectors', _booking!.protectors.toString()),
            const Divider(),
            _buildInfoRow('Cars', _booking!.cars.toString()),
            const Divider(),
            _buildInfoRow('Dress Code', _booking!.dressCode),
            const Divider(),
            _buildInfoRow(
              'Total Amount',
              _booking!.formattedPrice,
              valueStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: valueStyle ?? const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Admin Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _updateBookingStatus(BookingStatus.confirmed),
                icon: const Icon(Icons.check),
                label: const Text('Confirm Booking'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _updateBookingStatus(BookingStatus.cancelled),
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel Booking'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _cancelBooking,
          icon: const Icon(Icons.cancel),
          label: const Text('Cancel Booking'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    
    return '$day/$month/$year $hour:$minute';
  }
}