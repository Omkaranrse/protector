import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protector/models/booking_model.dart';
import 'package:protector/providers/auth_provider.dart';
import 'package:protector/providers/booking_provider.dart';
import 'package:protector/services/notification_service.dart';
import 'package:protector/widgets/loading_indicator.dart';

class AdminBookingDetailsScreen extends StatefulWidget {
  final Booking booking;

  const AdminBookingDetailsScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<AdminBookingDetailsScreen> createState() => _AdminBookingDetailsScreenState();
}

class _AdminBookingDetailsScreenState extends State<AdminBookingDetailsScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  late Booking _booking;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
  }

  Future<void> _updateBookingStatus(BookingStatus newStatus) async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      final notificationService = Provider.of<NotificationService>(context, listen: false);

      if (authProvider.token == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Authentication error';
        });
        return;
      }

      final success = await bookingProvider.updateBookingStatus(
        authProvider.token!,
        _booking.id,
        newStatus,
      );

      if (success) {
        setState(() {
          _isLoading = false;
        });

        String statusMessage;
        switch (newStatus) {
          case BookingStatus.confirmed:
            statusMessage = 'Booking has been confirmed';
            break;
          case BookingStatus.completed:
            statusMessage = 'Booking has been marked as completed';
            break;
          case BookingStatus.cancelled:
            statusMessage = 'Booking has been cancelled';
            break;
          default:
            statusMessage = 'Booking status has been updated';
        }

        notificationService.showNotification(
          statusMessage,
          NotificationType.success,
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to update booking status';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking #${_booking.id.substring(0, 8)}'),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingMessage: 'Updating booking...',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_errorMessage != null) ...[  
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              _buildStatusSection(),
              const SizedBox(height: 24),
              _buildBookingDetailsCard(),
              const SizedBox(height: 24),
              _buildCustomerDetailsCard(),
              const SizedBox(height: 24),
              _buildAdminActionsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    Color statusColor;
    IconData statusIcon;
    
    switch (_booking.status) {
      case BookingStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.pending_actions;
        break;
      case BookingStatus.confirmed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case BookingStatus.completed:
        statusColor = Colors.blue;
        statusIcon = Icons.task_alt;
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(statusIcon, color: statusColor, size: 48),
          const SizedBox(height: 8),
          Text(
            _booking.status.name[0].toUpperCase() + _booking.status.name.substring(1),
            style: TextStyle(
              color: statusColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Last updated: ${_formatDateTime(_booking.createdAt)}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Booking ID', _booking.id),
            _buildDetailRow('Pickup Location', _booking.pickupLocation),
            _buildDetailRow('Date', _booking.formattedDate),
            _buildDetailRow('Time', _booking.formattedTime),
            _buildDetailRow('Duration', '${_booking.durationHours} hours'),
            _buildDetailRow('Protectees', _booking.protectees.toString()),
            _buildDetailRow('Protectors', _booking.protectors.toString()),
            _buildDetailRow('Cars', _booking.cars.toString()),
            _buildDetailRow('Dress Code', _booking.dressCode),
            _buildDetailRow('Price', _booking.formattedPrice),
            _buildDetailRow('Created At', _formatDateTime(_booking.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetailsCard() {
    // In a real app, you would fetch user details from the API
    // For now, we'll use dummy data based on the booking's userId
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('User ID', _booking.userId),
            _buildDetailRow('Name', 'John Doe'), // Dummy data
            _buildDetailRow('Phone', '+1 (555) 123-4567'), // Dummy data
            _buildDetailRow('Email', 'john.doe@example.com'), // Dummy data
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActionsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Update booking status:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_booking.status == BookingStatus.pending) ...[  
                  _buildActionButton(
                    'Confirm',
                    Icons.check_circle,
                    Colors.green,
                    () => _updateBookingStatus(BookingStatus.confirmed),
                  ),
                  _buildActionButton(
                    'Cancel',
                    Icons.cancel,
                    Colors.red,
                    () => _updateBookingStatus(BookingStatus.cancelled),
                  ),
                ] else if (_booking.status == BookingStatus.confirmed) ...[  
                  _buildActionButton(
                    'Complete',
                    Icons.task_alt,
                    Colors.blue,
                    () => _updateBookingStatus(BookingStatus.completed),
                  ),
                  _buildActionButton(
                    'Cancel',
                    Icons.cancel,
                    Colors.red,
                    () => _updateBookingStatus(BookingStatus.cancelled),
                  ),
                ] else ...[  
                  // For completed or cancelled bookings
                  const Text(
                    'No actions available for this booking status',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$day/$month/$year $hour:$minute';
  }
}