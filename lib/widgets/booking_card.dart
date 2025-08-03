import 'package:flutter/material.dart';
import 'package:protector/models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final bool isAdmin;
  final Function(BookingStatus)? onStatusChange;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.onCancel,
    this.isAdmin = false,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking #${booking.id.substring(0, 8)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _buildStatusChip(context),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on, 'Location', booking.pickupLocation),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.calendar_today,
                'Date & Time',
                '${booking.formattedDate} at ${booking.formattedTime}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.people,
                'People',
                '${booking.protectees} Protectee${booking.protectees > 1 ? 's' : ''}, ${booking.protectors} Protector${booking.protectors > 1 ? 's' : ''}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.directions_car,
                'Cars',
                '${booking.cars} Car${booking.cars > 1 ? 's' : ''}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.style,
                'Dress Code',
                booking.dressCode,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.formattedPrice,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  if (isAdmin && booking.status == BookingStatus.pending)
                    _buildAdminActions(context)
                  else if (!isAdmin && booking.status == BookingStatus.pending && onCancel != null)
                    _buildCancelButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$title: ',
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color chipColor;
    switch (booking.status) {
      case BookingStatus.pending:
        chipColor = Colors.orange;
        break;
      case BookingStatus.confirmed:
        chipColor = Colors.green;
        break;
      case BookingStatus.completed:
        chipColor = Colors.blue;
        break;
      case BookingStatus.cancelled:
        chipColor = Colors.red;
        break;
    }

    return Chip(
      label: Text(
        booking.status.name[0].toUpperCase() + booking.status.name.substring(1),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildAdminActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () => onStatusChange?.call(BookingStatus.confirmed),
          icon: const Icon(Icons.check, size: 16),
          label: const Text('Confirm'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => onStatusChange?.call(BookingStatus.cancelled),
          icon: const Icon(Icons.close, size: 16),
          label: const Text('Cancel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton.icon(
      onPressed: onCancel,
      icon: const Icon(Icons.cancel, size: 16),
      label: const Text('Cancel Booking'),
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
}