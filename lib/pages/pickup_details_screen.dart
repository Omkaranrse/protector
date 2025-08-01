import 'package:flutter/material.dart';
import 'pickup_location_screen.dart';
import 'booking_summary_screen.dart';

class PickupDetailsScreen extends StatefulWidget {
  const PickupDetailsScreen({super.key});

  @override
  State<PickupDetailsScreen> createState() => _PickupDetailsScreenState();
}

class _PickupDetailsScreenState extends State<PickupDetailsScreen> {
  DateTime pickupDate = DateTime.now();
  TimeOfDay pickupTime = const TimeOfDay(hour: 12, minute: 0);
  Duration protectionDuration = const Duration(hours: 5);

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickupDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        pickupDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: pickupTime,
    );
    if (picked != null) {
      setState(() {
        pickupTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute$period';
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
    final endHour = pickupTime.hour + protectionDuration.inHours;
    final endTime = TimeOfDay(hour: endHour % 24, minute: pickupTime.minute);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Where should we have your motorcade meet you?",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Pickup Location
            _buildDetailTile(
              icon: Icons.location_on,
              title: 'Pickup Location',
              subtitle: 'Select Location',
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PickupLocationScreen()),
                );
                if (result != null) {
                  setState(() {
                    // Save or display selected location from `result`
                  });
                }
              },

            ),

            const SizedBox(height: 12),

            // Pickup Date
            _buildDetailTile(
              icon: Icons.calendar_today,
              title: 'Pickup Date',
              subtitle: _formattedDate(pickupDate),
              onTap: _selectDate,
            ),

            const SizedBox(height: 12),

            // Pickup Time
            _buildDetailTile(
              icon: Icons.access_time,
              title: 'Pickup Time',
              subtitle: _formatTime(pickupTime),
              onTap: _selectTime,
            ),

            const SizedBox(height: 12),

            // Duration
            _buildDetailTile(
              icon: Icons.timer,
              title: 'Duration of Protection',
              subtitle:
              '${protectionDuration.inHours} hours · ${_formatTime(pickupTime)} — ${_formatTime(endTime)}',
              onTap: () {
                // TODO: Add duration picker if needed
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Example values, replace with actual selections from previous screens
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingSummaryScreen(
                        protectees: 1, // TODO: fetch from user selection
                        protectors: 1, // TODO: fetch from user selection
                        dressCode: 'Business Casual', // TODO: fetch from user selection
                        cars: 1, // TODO: fetch from user selection
                        pickupLocation: 'Select Location', // TODO: fetch from user selection
                        pickupDate: pickupDate,
                        pickupTime: pickupTime,
                        protectionDuration: protectionDuration,
                        isMember: false, // TODO: fetch from user selection
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text("Next"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
